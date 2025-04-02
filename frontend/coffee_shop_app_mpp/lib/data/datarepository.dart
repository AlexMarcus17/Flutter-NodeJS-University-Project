import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'product.dart';

class DataRepository {
  final String baseUrl = 'http://localhost:3000/products';

  /// Fetch all products
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  /// Fetch only vegan products
  Future<List<Product>> getVeganProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vegan'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load vegan products');
      }
    } catch (e) {
      throw Exception('Error fetching vegan products: $e');
    }
  }

  /// Add a new product
  Future<void> addProduct(Product product) async {
    try {
      String finalImage = product.image;
      bool imageIsAsset = product.imageIsAsset;

      // Upload image if it's a file path (not a URL)
      if (!finalImage.startsWith('http')) {
        finalImage = await _uploadImage(File(product.image));
        imageIsAsset = true; // Since it's now a URL
      }

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product
            .copyWith(image: finalImage, imageIsAsset: imageIsAsset)
            .toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }

  /// Update a product
  Future<void> updateProduct(
    String id,
    String name,
    String description,
    double price,
    String image,
    bool isVegan,
    bool hasCaffeine,
    bool imageIsAsset,
  ) async {
    try {
      String finalImage = image;

      // Upload if the image is a local file
      if (!image.startsWith('http')) {
        finalImage = await _uploadImage(File(image));
        imageIsAsset = true; // Convert file path to URL
      }

      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "name": name,
          "description": description,
          "price": price,
          "image": finalImage,
          "isVegan": isVegan,
          "hasCaffeine": hasCaffeine,
          "imageIsAsset": imageIsAsset,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  /// Delete a product
  Future<void> deleteProduct(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }

  /// Upload image and return its URL
  Future<String> _uploadImage(File imageFile) async {
    final mimeType = lookupMimeType(imageFile.path);
    final request = http.MultipartRequest(
        'POST', Uri.parse('http://localhost:3000/upload'))
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['imageUrl'];
    } else {
      throw Exception('Image upload failed');
    }
  }
}
