const mongoose = require('mongoose');
const { faker } = require('@faker-js/faker');
require('dotenv').config({ path: './config.env' });

const { Product } = require('../server');

const DB = process.env.DATABASE.replace('<password>', process.env.DATABASE_PASSWORD);

async function seedProducts(count = 100000) {
  try {
    await mongoose.connect(DB);
    console.log('✅ Connected to MongoDB');

    const products = [];
    const staticImage = 'http://localhost:3000/uploads/1745935203237-207161885.jpg';

    for (let i = 0; i < count; i++) {
      const isVegan = faker.datatype.boolean();
      const hasCaffeine = faker.datatype.boolean();
      const price = faker.number.int({ min: 2, max: 9 })


      products.push({
        name: faker.commerce.productName().substring(0, 10),
        description: faker.commerce.productDescription().substring(0, 15),
        price,
        image: staticImage,
        isVegan,
        hasCaffeine,
        imageIsAsset: true,
      });

      if (products.length === 1000) {
        await Product.insertMany(products);
        console.log(`Inserted ${i + 1} products`);
        products.length = 0;
      }
    }

    if (products.length > 0) {
      await Product.insertMany(products);
      console.log(`Inserted final ${products.length} products`);
    }

    console.log('🎉 Seeding complete!');
    process.exit(0);
  } catch (err) {
    console.error('❌ Seeding failed:', err);
    process.exit(1);
  }
}

seedProducts();
