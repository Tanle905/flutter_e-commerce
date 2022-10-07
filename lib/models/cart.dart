import 'package:flutter/material.dart';

class CartItem {
  final String productId;
  final String title;
  final String imageUrl;
  final int quantity;
  final double price;

  CartItem(
      {required this.productId,
      required this.price,
      required this.quantity,
      required this.imageUrl,
      required this.title});

  CartItem copyWith(
      {String? productId,
      String? title,
      int? quantity,
      double? price,
      String? imageUrl}) {
    return CartItem(
        productId: productId ?? this.productId,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        title: title ?? this.title,
        imageUrl: imageUrl ?? this.imageUrl);
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] ?? '',
      title: json['title'] ?? 'No Data',
      quantity: json['quantity'] ?? 0,
      imageUrl: json['imageUrl'] ?? 'No Data',
      price: json['price'] == null ? 0 : double.parse(json['price'].toString()),
    );
  }
}

class CartList extends ChangeNotifier {
  List<CartItem> _cartItem;

  CartList(this._cartItem);

  List<CartItem> get getCartList => _cartItem;

  set setCartList(List<CartItem> itemsList) {
    _cartItem = itemsList;
    notifyListeners();
  }

  void add(CartItem item) {
    _cartItem.add(item);
    notifyListeners();
  }
}
