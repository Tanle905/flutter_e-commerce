import 'package:tmdt/models/cart.dart';

class OrderItem {
  final String? id;
  final double totalPrice;
  final List<CartItem> items;
  final DateTime dateTime;

  int get productCount {
    return items.length;
  }

  OrderItem(
      {this.id,
      required this.totalPrice,
      required this.items,
      DateTime? dateTime})
      : dateTime = dateTime ?? DateTime.now();

  OrderItem copyWith(
      {String? id,
      double? totalPrice,
      List<CartItem>? items,
      DateTime? dateTime}) {
    return OrderItem(
        id: id ?? this.id,
        totalPrice: totalPrice ?? this.totalPrice,
        items: items ?? this.items,
        dateTime: dateTime ?? this.dateTime);
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
        totalPrice: double.parse(json['totalPrice'].toString()),
        items: List.castFrom<dynamic, CartItem>(json['items']
            .map((cartItem) => CartItem.fromJson(cartItem))
            .toList()));
  }
}
