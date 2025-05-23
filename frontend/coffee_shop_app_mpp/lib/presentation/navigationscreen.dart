import 'package:coffee_shop_app_mpp/presentation/addproductscreen.dart';
import 'package:coffee_shop_app_mpp/presentation/chartscreen.dart';
import 'package:coffee_shop_app_mpp/presentation/dataprovider.dart';
import 'package:coffee_shop_app_mpp/presentation/productlistscreen.dart';
import 'package:coffee_shop_app_mpp/presentation/reportscreen.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final pagecontroller = PageController();
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Provider.of<DataProvider>(context, listen: false)
            .serverStatusStream(const Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.data == false) {
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 237, 201, 154),
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: AppBar(
                  backgroundColor: const Color.fromARGB(0, 249, 153, 57),
                  elevation: 0,
                  centerTitle: true,
                  title: ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(colors: [
                        Color.fromARGB(255, 123, 55, 30),
                        Color.fromARGB(255, 182, 118, 54),
                        Color.fromARGB(255, 155, 77, 0)
                      ]).createShader(bounds);
                    },
                    child: const Text(
                      "Coffee Shop",
                      style: TextStyle(
                          fontFamily: "Food Zone",
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ),
                ),
              ),
              body: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      size: 100,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Server is down",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Please check your server connection",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return StreamBuilder(
                stream: Connectivity().onConnectivityChanged,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.data?[0] == ConnectivityResult.none) {
                    _index = 0;
                    return Scaffold(
                      backgroundColor: const Color.fromARGB(255, 237, 201, 154),
                      appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(50),
                        child: AppBar(
                          backgroundColor:
                              const Color.fromARGB(0, 249, 153, 57),
                          elevation: 0,
                          centerTitle: true,
                          title: ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(colors: [
                                Color.fromARGB(255, 123, 55, 30),
                                Color.fromARGB(255, 182, 118, 54),
                                Color.fromARGB(255, 155, 77, 0)
                              ]).createShader(bounds);
                            },
                            child: const Text(
                              "Coffee Shop",
                              style: TextStyle(
                                  fontFamily: "Food Zone",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                      body: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wifi_off,
                              size: 100,
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "No Internet Connection",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Please check your internet connection",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Scaffold(
                      backgroundColor: const Color.fromARGB(255, 237, 201, 154),
                      appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(50),
                        child: AppBar(
                          backgroundColor:
                              const Color.fromARGB(0, 249, 153, 57),
                          elevation: 0,
                          centerTitle: true,
                          leading: IconButton(
                            icon: const Icon(Icons.sort),
                            onPressed: () {
                              Provider.of<DataProvider>(context, listen: false)
                                  .toggleVegan();
                            },
                          ),
                          title: ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(colors: [
                                Color.fromARGB(255, 123, 55, 30),
                                Color.fromARGB(255, 182, 118, 54),
                                Color.fromARGB(255, 155, 77, 0)
                              ]).createShader(bounds);
                            },
                            child: const Text(
                              "Coffee Shop",
                              style: TextStyle(
                                  fontFamily: "Food Zone",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                      body: PageView(
                        onPageChanged: (value) {
                          setState(() {
                            _index = value;
                          });
                        },
                        controller: pagecontroller,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          const ProductListScreen(),
                          const AddProductScreen(),
                          const ReportScreen(),
                          ChartScreen(),
                        ],
                      ),
                      bottomNavigationBar: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CustomNavigationBar(
                          iconSize: 30.0,
                          selectedColor: Colors.white,
                          strokeColor: Colors.white,
                          unSelectedColor: Colors.grey[600],
                          backgroundColor: Colors.black,
                          borderRadius: const Radius.circular(20.0),
                          blurEffect: true,
                          opacity: 0.8,
                          currentIndex: _index,
                          onTap: (index) {
                            setState(() {
                              _index = index;
                              pagecontroller.jumpToPage(index);
                            });
                          },
                          isFloating: true,
                          items: [
                            CustomNavigationBarItem(
                                icon: const Icon(FontAwesome.coffee)),
                            CustomNavigationBarItem(
                                icon: const Icon(MaterialIcons.add_circle)),
                            CustomNavigationBarItem(
                                icon: const Icon(Entypo.text_document)),
                            CustomNavigationBarItem(
                                icon: const Icon(MaterialIcons.insert_chart)),
                          ],
                        ),
                      ),
                    );
                  }
                });
          }
        });
  }
}
