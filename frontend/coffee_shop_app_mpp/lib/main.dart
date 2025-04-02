import 'package:coffee_shop_app_mpp/data/datarepository.dart';
import 'package:coffee_shop_app_mpp/presentation/dataprovider.dart';
import 'package:coffee_shop_app_mpp/presentation/navigationscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataProvider(dataRepository: DataRepository()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: NavigationScreen(),
      ),
    );
  }
}
