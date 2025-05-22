import 'package:coffee_shop_app_mpp/data/product.dart';
import 'package:coffee_shop_app_mpp/presentation/dataprovider.dart';
import 'package:coffee_shop_app_mpp/presentation/productwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<DataProvider>(context).products;
    int itemsPerPage = 6;

    int pageCount = (products.length / itemsPerPage).ceil();
    print(pageCount);
    return PageView.builder(
      onPageChanged: (index) {
        if (index >= pageCount - 1) {
          Provider.of<DataProvider>(context, listen: false).fetchMoreProducts();
        }
      },
      itemCount: pageCount,
      itemBuilder: (context, pageIndex) {
        int startIndex = pageIndex * itemsPerPage;
        int endIndex = (startIndex + itemsPerPage).clamp(0, products.length);
        List<Product> pageProducts = products.sublist(startIndex, endIndex);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: pageProducts.length,
            itemBuilder: (context, index) {
              return ProductWidget(product: pageProducts[index]);
            },
          ),
        );
      },
    );
  }
}
