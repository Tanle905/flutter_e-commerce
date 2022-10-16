import 'package:flutter/material.dart';

class CartItem {
  final String productId;
  final String title;
  final String description;
  final String imageUrl;
  int quantity;
  final double price;
  final bool isFavorite;

  CartItem(
      {required this.productId,
      required this.price,
      required this.quantity,
      required this.imageUrl,
      required this.title,
      required this.description,
      required this.isFavorite});

  CartItem copyWith(
      {String? productId,
      String? title,
      int? quantity,
      double? price,
      String? imageUrl,
      String? description,
      bool? isFavorite}) {
    return CartItem(
        productId: productId ?? this.productId,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        title: title ?? this.title,
        imageUrl: imageUrl ?? this.imageUrl,
        description: description ?? this.description,
        isFavorite: isFavorite ?? false);
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
        productId: json['productId'] ?? json['_id'],
        title: json['title'] ?? 'No Data',
        quantity: json['quantity'] ?? 0,
        imageUrl: json['imageUrl'] ?? 'No Data',
        price:
            json['price'] == null ? 0 : double.parse(json['price'].toString()),
        description: json['description'] ?? 'No Data',
        isFavorite: json['isFavorite'] ?? false);
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

  void updateCartList(CartItem cartItem) {
    _cartItem[_cartItem
        .indexWhere((item) => item.productId == cartItem.productId)] = cartItem;
    notifyListeners();
  }

  void deleteItemInCartList(CartItem cartItem) {
    _cartItem.removeWhere((element) => element.productId == cartItem.productId);
    notifyListeners();
  }

  void add(CartItem item) {
    _cartItem.add(item);
    notifyListeners();
  }
}
