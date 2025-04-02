// const mongoose = require('mongoose');
// const dotenv = require('dotenv');


// dotenv.config({ path: './config.env' });

// const DB = process.env.DATABASE.replace("<password>", process.env.DATABASE_PASSWORD);

// mongoose.connect(DB).then(() => {
//   console.log('DB connection successful!');
// });

const express = require("express");
const multer = require("multer");
const path = require("path");
const cors = require("cors");

const app = express();
const PORT = 3000;

// Middleware
app.use(express.json()); // Parse JSON bodies
app.use(cors()); // Allow requests from Flutter app

// Serve static files (uploaded images)
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

// In-memory storage for products
let products = [];
let productId = 1;

// Configure Multer for image uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/"); // Save files in "uploads" folder
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  },
});
const upload = multer({ storage: storage });

/** 
 * 🖼️ Upload Image API
 * POST /upload
 */
app.post("/upload", upload.single("image"), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: "No image uploaded" });
  }

  // Generate image URL
  const imageUrl = `http://localhost:${PORT}/uploads/${req.file.filename}`;
  res.json({ imageUrl });
});

/**
 * 📌 Get All Products
 * GET /products
 */
app.get("/products", (req, res) => {
  res.json(products);
});

/**
 * 🌱 Get Only Vegan Products
 * GET /products/vegan
 */
app.get("/products/vegan", (req, res) => {
  const veganProducts = products.filter((product) => product.isVegan);
  res.json(veganProducts);
});

/**
 * ➕ Add New Product
 * POST /products
 */
app.post("/products", (req, res) => {
  const { name, description, price, image, isVegan, hasCaffeine } = req.body;

  if (!name || !description || !price || !image) {
    return res.status(400).json({ error: "Missing required fields" });
  }

  const newProduct = {
    id: (productId++).toString(), // Convert ID to string
    name,
    description,
    price,
    image,
    isVegan,
    hasCaffeine,
    imageIsAsset: true, // Ensuring images are treated as URLs
  };

  products.push(newProduct);
  res.status(201).json(newProduct);
});

/**
 * ✏️ Update Product
 * PUT /products/:id
 */
app.put("/products/:id", (req, res) => {
  const { id } = req.params;
  const { name, description, price, image, isVegan, hasCaffeine } = req.body;

  const productIndex = products.findIndex((p) => p.id === id);
  if (productIndex === -1) {
    return res.status(404).json({ error: "Product not found" });
  }

  products[productIndex] = {
    ...products[productIndex],
    name,
    description,
    price,
    image,
    isVegan,
    hasCaffeine,
    imageIsAsset: true, // Ensure images are treated as URLs
  };

  res.json(products[productIndex]);
});

/**
 * 🗑️ Delete Product
 * DELETE /products/:id
 */
app.delete("/products/:id", (req, res) => {
  const { id } = req.params;
  const initialLength = products.length;
  products = products.filter((p) => p.id !== id);

  if (products.length === initialLength) {
    return res.status(404).json({ error: "Product not found" });
  }

  res.json({ message: "Product deleted" });
});

// Start the server
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
