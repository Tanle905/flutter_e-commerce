import 'package:tmdt/constants/endpoints.dart';
import 'package:tmdt/models/cart.dart';

class Product {
  final String productId;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final int productQuantity;
  bool isFavorite;
  Product(
      {required this.productId,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      required this.productQuantity,
      this.isFavorite = false});
  Product copyWith(
      {String? productId,
      String? title,
      String? description,
      double? price,
      String? imageUrl,
      int? productQuantity,
      bool? isFavorite}) {
    return Product(
        productId: productId ?? this.productId,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        productQuantity: productQuantity ?? this.productQuantity,
        isFavorite: isFavorite ?? this.isFavorite);
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        productId: json['_id'] ?? '',
        title: json['title'] ?? 'Product Not Existed',
        description: json['description'] ?? 'No Data',
        imageUrl: json['imageUrl'] ?? placeholderImage,
        price:
            json['price'] == null ? 0 : double.parse(json['price'].toString()),
        productQuantity: json['productQuantity'] ?? 0,
        isFavorite: json['isFavorite'] ?? false);
  }

  factory Product.fromCartitem(CartItem cartItem) {
    return Product(
        productId: cartItem.productId,
        title: cartItem.title,
        description: cartItem.description,
        imageUrl: cartItem.imageUrl,
        price: cartItem.price,
        productQuantity: cartItem.productQuantity,
        isFavorite: cartItem.isFavorite);
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'productQuantity': productQuantity
      };
}
