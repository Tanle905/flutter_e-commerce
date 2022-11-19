import 'package:tmdt/models/cart.dart';

class OrderItem {
  final String? id;
  final double totalPrice;
  final String orderStatus;
  final List<CartItem> items;
  final DateTime dateTime;

  int get productCount {
    return items.length;
  }

  OrderItem(
      {this.id,
      required this.totalPrice,
      required this.orderStatus,
      required this.items,
      DateTime? dateTime})
      : dateTime = dateTime ?? DateTime.now();

  OrderItem copyWith(
      {String? id,
      double? totalPrice,
      String? orderStatus,
      List<CartItem>? items,
      DateTime? dateTime}) {
    return OrderItem(
        id: id ?? this.id,
        totalPrice: totalPrice ?? this.totalPrice,
        orderStatus: orderStatus ?? this.orderStatus,
        items: items ?? this.items,
        dateTime: dateTime ?? this.dateTime);
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
        orderStatus: json['orderStatus'],
        totalPrice: double.parse(json['totalPrice'].toString()),
        items: List.castFrom<dynamic, CartItem>(json['items']
            .map((cartItem) => CartItem.fromJson(cartItem))
            .toList()));
  }
}
