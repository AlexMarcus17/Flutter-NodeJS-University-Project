import 'dart:convert';
import 'dart:io';
import 'package:coffee_shop_app_mpp/data/stats.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:web_socket_channel/io.dart';

import 'product.dart';

class DataRepository {
  final String baseUrl =
      'https://flutter-nodejs-university-project.onrender.com/products';
  final String statsUrl =
      'https://flutter-nodejs-university-project.onrender.com/stats';
  final _channel = IOWebSocketChannel.connect(
      'wss://flutter-nodejs-university-project.onrender.com');
  final _statsChannel = IOWebSocketChannel.connect(
      'wss://flutter-nodejs-university-project.onrender.com/stats');

  late final Stream<List<Product>> _productBroadcastStream =
      _channel.stream.map((data) {
    final decoded = jsonDecode(data);
    return (decoded as List).map((item) => Product.fromJson(item)).toList();
  }).asBroadcastStream();

  late final Stream<ProductStats> _statsBroadcastStream =
      _statsChannel.stream.map((data) {
    final decoded = jsonDecode(data);
    print(ProductStats.fromJson(decoded).toString());
    return ProductStats.fromJson(decoded);
  }).asBroadcastStream();

  Stream<List<Product>> get productStream => _productBroadcastStream;
  Stream<ProductStats> get statsStream => _statsBroadcastStream;

  Future<List<Product>> getProducts({int offset = 0, int limit = 6}) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl?offset=$offset&limit=$limit'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) {
          return Product.fromJson(json);
        }).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<Product>> getVeganProducts(
      {int offset = 0, int limit = 6}) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/vegan?offset=$offset&limit=$limit'));
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

  Future<void> addProduct(Product product) async {
    try {
      String finalImage = product.image;
      bool imageIsAsset = product.imageIsAsset;

      if (!finalImage.startsWith('http')) {
        finalImage = await _uploadImage(File(product.image));
        imageIsAsset = true;
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

      if (!image.startsWith('http')) {
        finalImage = await _uploadImage(File(image));
        imageIsAsset = true;
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

  Future<String> _uploadImage(File imageFile) async {
    final mimeType = lookupMimeType(imageFile.path);
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://flutter-nodejs-university-project.onrender.com/upload'),
    )..files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: mimeType != null ? MediaType.parse(mimeType) : null,
      ));

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
