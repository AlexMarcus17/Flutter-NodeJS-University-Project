import 'package:coffee_shop_app_mpp/presentation/dataprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 201, 154),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatisticTile(
                "Total Products", dataProvider.totalProducts.toString()),
            _buildStatisticTile("Average Price",
                "\$${dataProvider.averagePrice.toStringAsFixed(2)}"),
            _buildStatisticTile("Highest Price",
                "\$${dataProvider.highestPrice.toStringAsFixed(2)}"),
            _buildStatisticTile("Total Vegan Products",
                dataProvider.totalVeganProducts.toString()),
            _buildStatisticTile("Total Caffeinated Products",
                dataProvider.totalCaffeinatedProducts.toString()),
          ],
        ),
      ),
    );
  }
}

Widget _buildStatisticTile(String title, String value) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      trailing: Text(value, style: TextStyle(fontSize: 18)),
    ),
  );
}
