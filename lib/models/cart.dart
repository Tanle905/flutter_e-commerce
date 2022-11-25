import 'package:flutter/material.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/models/review.dart';

class CartItem extends Product {
  int quantity;

  CartItem(
      {required String productId,
      required String title,
      required this.quantity,
      required String description,
      required String imageUrl,
      required int productQuantity,
      required double price,
      required bool isFavorite,
      List<ReviewDetails> reviews = const []})
      : super(
            description: description,
            imageUrl: imageUrl,
            price: price,
            productId: productId,
            productQuantity: productQuantity,
            title: title,
            isFavorite: isFavorite,
            reviews: reviews);

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
        productId: json['productId'] ?? json['_id'],
        title: json['title'] ?? 'No Data',
        quantity: json['quantity'] ?? 0,
        imageUrl: json['imageUrl'] ?? 'No Data',
        price:
            json['price'] == null ? 0 : double.parse(json['price'].toString()),
        description: json['description'] ?? 'No Data',
        productQuantity: json['productQuantity'] ?? 0,
        isFavorite: json['isFavorite'] ?? false);
  }

  @override
  Map<String, dynamic> toJson() => {
        'productId': productId,
        'title': title,
        'quantity': quantity,
        'productQuantity': productQuantity,
        'imageUrl': imageUrl,
        'price': price,
        'description': description,
        'isFavorite': isFavorite
      };
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
