
const express = require("express");
const multer = require("multer");
const path = require("path");
const cors = require("cors");
const WebSocket = require("ws");
const mongoose = require("mongoose");
const dotenv = require("dotenv");

// Load env variables
dotenv.config({ path: "./config.env" });

// Connect to MongoDB
const DB = process.env.DATABASE.replace("<password>", process.env.DATABASE_PASSWORD);
mongoose.connect(DB).then(() => {
  console.log("✅ MongoDB connected");
});

// ----- Models -----
const productSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: String,
  price: Number,
  image: String,
  isVegan: Boolean,
  hasCaffeine: Boolean,
  imageIsAsset: Boolean
});
const Product = mongoose.model("Product", productSchema);

const productStatsSchema = new mongoose.Schema({
  lastCreatedAt: { type: Date, required: true },
  avgVeganPrice: { type: Number, required: true },
  avgCaffeinatedPrice: { type: Number, required: true },
});
const ProductStats = mongoose.model("ProductStats", productStatsSchema);

// ----- Express App -----
const app = express();
const PORT = 3000;

app.use(express.json());
app.use(cors());
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

// Image Upload
const storage = multer.diskStorage({
  destination: (_, __, cb) => cb(null, "uploads/"),
  filename: (_, file, cb) => {
    const uniqueName = Date.now() + "-" + Math.round(Math.random() * 1e9) + path.extname(file.originalname);
    cb(null, uniqueName);
  },
});
const upload = multer({ storage });

// ----- WebSockets -----
const productWSS = new WebSocket.Server({ noServer: true });
const statsWSS = new WebSocket.Server({ noServer: true });

// Broadcast Products
async function broadcastProductUpdate() {
  const products = await Product.find().sort({ _id: -1 });
  const data = JSON.stringify(products);
  productWSS.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) client.send(data);
  });
}

// Broadcast Stats
async function broadcastStatsUpdate() {
  const stats = await ProductStats.findOne();
  if (!stats) return;
  const data = JSON.stringify(stats);
  statsWSS.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) client.send(data);
  });
}

// Recalculate Stats
async function updateProductStats() {
  const veganAvg = await Product.aggregate([
    { $match: { isVegan: true } },
    { $group: { _id: null, avgPrice: { $avg: "$price" } } },
  ]);

  const caffeineAvg = await Product.aggregate([
    { $match: { hasCaffeine: true } },
    { $group: { _id: null, avgPrice: { $avg: "$price" } } },
  ]);

  const statsData = {
    lastCreatedAt: new Date(),
    avgVeganPrice: veganAvg[0]?.avgPrice || 0,
    avgCaffeinatedPrice: caffeineAvg[0]?.avgPrice || 0,
  };

  await ProductStats.findOneAndUpdate({}, statsData, { upsert: true, new: true });
  broadcastStatsUpdate();
}

// ----- Routes -----

app.get("/health", (_, res) => res.status(200).send("OK"));

app.post("/upload", upload.single("image"), (req, res) => {
  if (!req.file) return res.status(400).json({ error: "No image uploaded" });
  const imageUrl = `http://localhost:${PORT}/uploads/${req.file.filename}`;
  res.json({ imageUrl });
});

app.get("/products", async (req, res) => {
  const limit = parseInt(req.query.limit) || 6;
  const offset = parseInt(req.query.offset) || 0;
  const products = await Product.find().sort({ _id: -1 }).skip(offset).limit(limit);
  res.json(products);
});

app.get("/products/vegan", async (req, res) => {
  const limit = parseInt(req.query.limit) || 6;
  const offset = parseInt(req.query.offset) || 0;
  const products = await Product.find({ isVegan: true }).sort({ _id: -1 }).skip(offset).limit(limit);
  res.json(products);
});

app.post("/products", async (req, res) => {
  const { name, description, price, image, isVegan, hasCaffeine, imageIsAsset } = req.body;
  if (!name || !description || !price || !image) {
    return res.status(400).json({ error: "Missing required fields" });
  }

  const newProduct = await Product.create({
    name, description, price, image, isVegan, hasCaffeine, imageIsAsset: imageIsAsset ?? true,
  });

  await broadcastProductUpdate();
  await updateProductStats();

  res.status(201).json(newProduct);
});

app.put("/products/:id", async (req, res) => {
  const { id } = req.params;
  const { name, description, price, image, isVegan, hasCaffeine, imageIsAsset } = req.body;

  const updated = await Product.findByIdAndUpdate(
    id,
    { name, description, price, image, isVegan, hasCaffeine, imageIsAsset: imageIsAsset ?? true },
    { new: true }
  );

  if (!updated) return res.status(404).json({ error: "Product not found" });

  await broadcastProductUpdate();
  await updateProductStats();

  res.json(updated);
});

// app.delete('/products', async (req, res) => {
//   await Product.deleteMany({});
//   res.json({ message: 'All products deleted' });
// });


app.delete("/products/:id", async (req, res) => {
  const { id } = req.params;
  const deleted = await Product.findByIdAndDelete(id);
  if (!deleted) return res.status(404).json({ error: "Product not found" });

  await broadcastProductUpdate();
  await updateProductStats();

  res.json({ message: "Product deleted" });
});

// ----- WebSocket Handling -----
productWSS.on("connection", async (ws) => {
  console.log("📦 Product WebSocket connected");
  const products = await Product.find().sort({ _id: -1 });
  ws.send(JSON.stringify(products));
});

statsWSS.on("connection", async (ws) => {
  console.log("📊 Stats WebSocket connected");
  const stats = await ProductStats.findOne();
  if (stats) ws.send(JSON.stringify(stats));
});

// ----- Start Server -----
const server = app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});

server.on("upgrade", (request, socket, head) => {
  if (request.url === "/stats") {
    statsWSS.handleUpgrade(request, socket, head, (ws) => {
      statsWSS.emit("connection", ws, request);
    });
  } else {
    productWSS.handleUpgrade(request, socket, head, (ws) => {
      productWSS.emit("connection", ws, request);
    });
  }
});

module.exports.Product = Product;
