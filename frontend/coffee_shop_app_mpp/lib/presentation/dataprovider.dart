import 'package:coffee_shop_app_mpp/data/datarepository.dart';
import 'package:coffee_shop_app_mpp/data/product.dart';
import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  DataRepository dataRepository;
  DataProvider({required this.dataRepository}) {}

  List<Product> _products = [];
  //   [
  //   Product(
  //       id: 1.toString(),
  //       name: "Espresso",
  //       price: 2.5,
  //       image: "assets/espresso.png",
  //       isVegan: true,
  //       description: "A small, strong coffee."),
  //   Product(
  //       id: 2.toString(),
  //       name: "Cappuccino",
  //       price: 3.5,
  //       image: "assets/cappuccino.png",
  //       isVegan: false,
  //       description: "A coffee made with milk and foam."),
  //   Product(
  //       id: 3.toString(),
  //       name: "Latte",
  //       price: 4.0,
  //       image: "assets/caffelatte.png",
  //       isVegan: false,
  //       description: "A coffee made with milk."),
  //   Product(
  //       id: 4.toString(),
  //       name: "Decaf Mocha",
  //       price: 6.0,
  //       image: "assets/mocha.png",
  //       isVegan: false,
  //       description:
  //           "A chocolate-flavored coffee made with decaffeinated coffee.",
  //       hasCaffeine: false),
  //   Product(
  //       id: 5.toString(),
  //       name: "Iced Coffee",
  //       price: 3.0,
  //       image: "assets/icedcoffee.png",
  //       isVegan: true,
  //       description: "A cold coffee drink."),
  //   Product(
  //       id: 6.toString(),
  //       name: "Cold Brew",
  //       price: 4.0,
  //       image: "assets/brew.png",
  //       isVegan: true,
  //       description: "A cold coffee drink made with cold water."),
  //   Product(
  //       id: 7.toString(),
  //       name: "Double Espresso",
  //       price: 3.5,
  //       image: "assets/doubleespresso.png",
  //       isVegan: true,
  //       description: "A small, strong coffee."),
  // ];
  bool showVegan = false;

  void toggleVegan() {
    showVegan = !showVegan;
    notifyListeners();
  }

  Future<List<Product>> get products async {
    _products = showVegan
        ? await dataRepository.getVeganProducts() // Fetch only vegan products
        : await dataRepository.getProducts(); // Fetch all products
    return _products;
  }

  Future<void> addProduct(String name, String description, double price,
      String image, bool isVegan, bool hasCaffeine) async {
    var newProduct = Product(
        id: (_products.length + 1).toString(),
        name: name,
        description: description,
        price: price,
        image: image,
        isVegan: isVegan,
        hasCaffeine: hasCaffeine,
        imageIsAsset: false);
    _products.add(newProduct);
    dataRepository.addProduct(newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(
      String id,
      String name,
      String description,
      double price,
      String image,
      bool isVegan,
      bool hasCaffeine,
      bool imageIsAsset) async {
    _products = _products.map((product) {
      if (product.id == id) {
        return product.copyWith(
          name: name,
          description: description,
          price: price,
          image: image,
          isVegan: isVegan,
          hasCaffeine: hasCaffeine,
          imageIsAsset: imageIsAsset,
        );
      } else {
        return product;
      }
    }).toList();
    dataRepository.updateProduct(id, name, description, price, image, isVegan,
        hasCaffeine, imageIsAsset);
    notifyListeners();
  }

  int get totalProducts => _products.length;

  double get averagePrice => _products.isEmpty
      ? 0
      : _products.map((p) => p.price).reduce((a, b) => a + b) /
          _products.length;

  double get highestPrice => _products.isEmpty
      ? 0
      : _products.map((p) => p.price).reduce((a, b) => a > b ? a : b);

  int get totalVeganProducts => _products.where((p) => p.isVegan).length;

  int get totalCaffeinatedProducts =>
      _products.where((p) => p.hasCaffeine).length;

  Future<void> deleteProduct(String id) async {
    _products.removeWhere((product) => product.id == id);
    dataRepository.deleteProduct(id);
    notifyListeners();
  }
}
