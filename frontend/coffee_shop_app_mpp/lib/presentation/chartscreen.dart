import 'package:coffee_shop_app_mpp/presentation/dataprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Prices Chart")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
            future: Provider.of<DataProvider>(context).products,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final products = snapshot.data;
                var prices = products!.map((product) => product.price).toList();
                return Column(
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
                                    toY: prices[index],
                                    color: Colors.blue,
                                    width: 16)
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
                  ],
                );
              }
            }),
      ),
    );
  }
}
