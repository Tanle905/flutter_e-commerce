class Product {
  final String? productId;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final bool isFavorite;
  Product(
      {required this.productId,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});
  Product copyWith(
      {String? id,
      String? title,
      String? description,
      double? price,
      String? imageUrl,
      bool? isFavorite}) {
    return Product(
        productId: id ?? this.productId,
        title: id ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        isFavorite: isFavorite ?? this.isFavorite);
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        productId: json['productId'] ?? '',
        title: json['title'] ?? 'No Data',
        description: json['description'] ?? 'No Data',
        imageUrl: json['imageUrl'] ?? 'No Data',
        price: json['price'] == null ? 0 : double.parse(json['price']),
        isFavorite: json['isFavorite'] ?? false);
  }
}
