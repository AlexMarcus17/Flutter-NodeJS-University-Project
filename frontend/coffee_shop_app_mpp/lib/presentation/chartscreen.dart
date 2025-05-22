import 'package:coffee_shop_app_mpp/data/product.dart';
import 'package:coffee_shop_app_mpp/presentation/dataprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartScreen extends StatefulWidget {
  ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final stats = dataProvider.cachedStreamStats;
    final prices = [stats.avgCaffeinatedPrice, stats.avgVeganPrice];
    // final prices = dataProvider.cachedStreamProducts
    //     .map((product) => product.price)
    //     .toList();
    return Scaffold(
      appBar: AppBar(title: const Text("Product Prices Chart")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: List.generate(prices.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                            toY: prices[index], color: Colors.blue, width: 16)
                      ],
                    );
                  }),
                  // titlesData: FlTitlesData(
                  //   leftTitles:
                  //       AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  //   bottomTitles: AxisTitles(
                  //     sideTitles: SideTitles(
                  //       showTitles: true,
                  //       getTitlesWidget: (value, meta) {
                  //         if (value.toInt() >= 0 &&
                  //             value.toInt() < names.length) {
                  //           return Text(names[value.toInt()],
                  //               style: TextStyle(fontSize: 10),
                  //               overflow: TextOverflow.ellipsis);
                  //         }
                  //         return Text("");
                  //       },
                  //     ),
                  //   ),
                  // ),
                ),
              ),
            ),
            Center(
              child: Text(
                stats.lastCreatedAt.toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
