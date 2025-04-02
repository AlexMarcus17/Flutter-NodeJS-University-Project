import 'dart:io';

import 'package:coffee_shop_app_mpp/data/product.dart';
import 'package:coffee_shop_app_mpp/presentation/productformscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  const ProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
          return ProductFormScreen(product: product);
        }));
      },
      child: FittedBox(
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              color: Color.fromARGB(255, 5, 3, 30)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: SizedBox(
                  height: 100,
                  width: 150,
                  child: ClipRRect(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: product.imageIsAsset
                        ? Image.network(product.image)
                        : Image.file(File(product.image)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: 170,
                  child: Text(
                    product.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 225, 206, 181),
                        fontFamily: "Food Zone",
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: SizedBox(
                  height: 30,
                  width: 200,
                  child: Text(
                    product.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 187, 155, 114),
                        fontFamily: "Food Zone",
                        fontSize: 12,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${product.price.toStringAsPrecision(2)}\$",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 229, 193, 146),
                        ),
                      ),
                      (product.hasCaffeine)
                          ? SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.asset("assets/coffeebean.png"),
                            )
                          : const SizedBox(
                              height: 30,
                              width: 30,
                            ),
                      (product.isVegan)
                          ? SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.asset("assets/vegantag.png"),
                            )
                          : const SizedBox(
                              height: 30,
                              width: 30,
                            )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              )
            ],
          ),
        ),
      ),
    );
  }
}
