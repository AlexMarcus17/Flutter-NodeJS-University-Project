// ignore_for_file: public_member_api_docs, sort_constructors_first
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final bool isVegan;
  bool hasCaffeine;
  bool imageIsAsset;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.isVegan,
    required this.id,
    this.hasCaffeine = true,
    this.imageIsAsset = true,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? image,
    bool? isVegan,
    bool? hasCaffeine,
    bool? imageIsAsset,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      isVegan: isVegan ?? this.isVegan,
      hasCaffeine: hasCaffeine ?? this.hasCaffeine,
      imageIsAsset: imageIsAsset ?? this.imageIsAsset,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: json['image'],
      isVegan: json['isVegan'],
      hasCaffeine: json['hasCaffeine'],
      imageIsAsset: json['imageIsAsset'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'isVegan': isVegan,
      'hasCaffeine': hasCaffeine,
      'imageIsAsset': imageIsAsset,
    };
  }
}
