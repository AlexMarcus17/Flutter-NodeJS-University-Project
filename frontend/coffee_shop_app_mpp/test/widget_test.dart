import 'package:coffee_shop_app_mpp/data/datarepository.dart';
import 'package:coffee_shop_app_mpp/data/product.dart';
import 'package:coffee_shop_app_mpp/presentation/dataprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_shop_app_mpp/main.dart';

void main() {
  late DataProvider dataProvider;
  late DataRepository mockDataRepository;

  setUp(() {
    mockDataRepository = DataRepository();
    dataProvider = DataProvider(dataRepository: mockDataRepository);
  });

  test('Initial product list is not empty', () {
    expect(dataProvider.products.isNotEmpty, true);
  });

  test('Adding a product increases the list size', () {
    int initialCount = dataProvider.totalProducts;
    dataProvider.addProduct(
        "Test Coffee", "Test Description", 5.0, "test.png", true, true);
    expect(dataProvider.totalProducts, initialCount + 1);
  });

  test('Updating a product modifies its properties', () {
    String productId = dataProvider.products.first.id;
    dataProvider.updateProduct(productId, "Updated Coffee",
        "Updated Description", 6.0, "updated.png", false, false, true);
    Product updatedProduct =
        dataProvider.products.firstWhere((p) => p.id == productId);
    expect(updatedProduct.name, "Updated Coffee");
    expect(updatedProduct.price, 6.0);
    expect(updatedProduct.isVegan, false);
  });

  test('Deleting a product decreases the list size', () {
    int initialCount = dataProvider.totalProducts;
    String productId = dataProvider.products.first.id;
    dataProvider.deleteProduct(productId);
    expect(dataProvider.totalProducts, initialCount - 1);
  });

  test('Total vegan products count is correct', () {
    int expectedCount = dataProvider.products.where((p) => p.isVegan).length;
    expect(dataProvider.totalVeganProducts, expectedCount);
  });

  test('Total caffeinated products count is correct', () {
    int expectedCount =
        dataProvider.products.where((p) => p.hasCaffeine).length;
    expect(dataProvider.totalCaffeinatedProducts, expectedCount);
  });

  test('Average price calculation is correct', () {
    double expectedAverage =
        dataProvider.products.map((p) => p.price).reduce((a, b) => a + b) /
            dataProvider.totalProducts;
    expect(dataProvider.averagePrice, expectedAverage);
  });

  test('Highest price calculation is correct', () {
    double expectedHighest = dataProvider.products
        .map((p) => p.price)
        .reduce((a, b) => a > b ? a : b);
    expect(dataProvider.highestPrice, expectedHighest);
  });
}
