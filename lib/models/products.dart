import 'package:flutter/material.dart';
import 'package:tmdt/constants/endpoints.dart';

class Product {
  final String productId;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product(
      {required this.productId,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});
  Product copyWith(
      {String? productId,
      String? title,
      String? description,
      double? price,
      String? imageUrl,
      bool? isFavorite}) {
    return Product(
        productId: productId ?? this.productId,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        isFavorite: isFavorite ?? this.isFavorite);
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        productId: json['_id'] ?? '',
        title: json['title'] ?? 'No Data',
        description: json['description'] ?? 'No Data',
        imageUrl: json['imageUrl'] ?? placeholderImage,
        price:
            json['price'] == null ? 0 : double.parse(json['price'].toString()),
        isFavorite: json['isFavorite'] ?? false);
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl
      };
}
