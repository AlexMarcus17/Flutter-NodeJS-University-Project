const request = require("supertest");
const express = require("express");
const app = require("../server"); // Adjust this path based on where your server file is located

describe("API Tests", () => {
  let productId;


  it("should add a new product", async () => {
    const newProduct = {
      name: "Test Product",
      description: "This is a test product",
      price: 9.99,
      image: "http://localhost:3000/uploads/test.jpg",
      isVegan: true,
      hasCaffeine: false,
    };

    const res = await request(app).post("/products").send(newProduct);
    expect(res.status).toBe(201);
    expect(res.body).toHaveProperty("id");
    productId = res.body.id;
  });

  it("should get all products", async () => {
    const res = await request(app).get("/products");
    expect(res.status).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });

  it("should get only vegan products", async () => {
    const res = await request(app).get("/products/vegan");
    expect(res.status).toBe(200);
    expect(res.body.every((p) => p.isVegan)).toBe(true);
  });

  it("should update a product", async () => {
    const updatedProduct = {
      name: "Updated Product",
      description: "Updated description",
      price: 12.99,
      image: "http://localhost:3000/uploads/updated.jpg",
      isVegan: false,
      hasCaffeine: true,
    };

    const res = await request(app).put(`/products/${productId}`).send(updatedProduct);
    expect(res.status).toBe(200);
    expect(res.body.name).toBe("Updated Product");
  });

  it("should delete a product", async () => {
    const res = await request(app).delete(`/products/${productId}`);
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ message: "Product deleted" });
  });
});
