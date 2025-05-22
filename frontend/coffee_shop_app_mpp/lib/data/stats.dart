// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductStats {
  final DateTime lastCreatedAt;
  final double avgVeganPrice;
  final double avgCaffeinatedPrice;

  ProductStats({
    required this.lastCreatedAt,
    required this.avgVeganPrice,
    required this.avgCaffeinatedPrice,
  });

  factory ProductStats.fromJson(Map<String, dynamic> json) {
    return ProductStats(
      lastCreatedAt: DateTime.parse(json['lastCreatedAt']),
      avgVeganPrice: (json['avgVeganPrice'] as num).toDouble(),
      avgCaffeinatedPrice: (json['avgCaffeinatedPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastCreatedAt': lastCreatedAt.toIso8601String(),
      'avgVeganPrice': avgVeganPrice,
      'avgCaffeinatedPrice': avgCaffeinatedPrice,
    };
  }

  @override
  String toString() =>
      'ProductStats(lastCreatedAt: $lastCreatedAt, avgVeganPrice: $avgVeganPrice, avgCaffeinatedPrice: $avgCaffeinatedPrice)';
}
