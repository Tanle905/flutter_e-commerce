import 'package:flutter/material.dart';
import 'package:tmdt/constants/endpoints.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/review.dart';

class Product {
  final String productId;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final int productQuantity;
  bool isFavorite;
  List<ReviewDetails> reviews;

  Product(
      {required this.productId,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      required this.productQuantity,
      this.isFavorite = false,
      this.reviews = const []});

  Product copyWith(
      {String? productId,
      String? title,
      String? description,
      double? price,
      String? imageUrl,
      int? productQuantity,
      bool? isFavorite,
      List<ReviewDetails>? reviews}) {
    return Product(
        productId: productId ?? this.productId,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        productQuantity: productQuantity ?? this.productQuantity,
        isFavorite: isFavorite ?? this.isFavorite,
        reviews: reviews ?? this.reviews);
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
        isFavorite: json['isFavorite'] ?? false,
        reviews: json['review'] != null
            ? List.castFrom<dynamic, ReviewDetails>(json['review']
                .map((review) => ReviewDetails.fromJson(review))
                .toList())
            : List.empty());
  }

  factory Product.fromCartItem(CartItem cartItem) {
    return Product(
        productId: cartItem.productId,
        title: cartItem.title,
        description: cartItem.description,
        imageUrl: cartItem.imageUrl,
        price: cartItem.price,
        productQuantity: cartItem.productQuantity,
        isFavorite: cartItem.isFavorite,
        reviews: cartItem.reviews);
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'productQuantity': productQuantity
      };
}

class ProductManager extends ChangeNotifier {
  List<Product> _productsList = List.empty();

  set setProductsList(List<Product> productsList) {
    _productsList = productsList;
    notifyListeners();
  }

  set setInitialProductsList(List<Product> productsList) {
    _productsList = productsList;
  }

  int get productsListCount {
    return _productsList.length;
  }

  List<Product> get productsList {
    return [..._productsList];
  }

  List<Product> get favoriteProducts {
    return _productsList.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _productsList.firstWhere((element) => element.productId == id);
  }

  void addProduct(Product product) {
    _productsList.insert(0, product);
    notifyListeners();
  }

  void updateProduct(Product product) {
    _productsList[_productsList
        .indexWhere((item) => item.productId == product.productId)] = product;
    notifyListeners();
  }

  void deleteProduct(Product product) {
    _productsList.removeAt(_productsList
        .indexWhere((item) => item.productId == product.productId));
    notifyListeners();
  }
}
