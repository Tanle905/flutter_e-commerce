import 'package:tmdt/models/address.dart';
import 'package:tmdt/models/cart.dart';

class OrderItem {
  final String? id;
  final double totalPrice;
  final String orderStatus;
  final Address address;
  final List<CartItem> items;
  final DateTime dateTime;

  int get productCount {
    return items.length;
  }

  OrderItem(
      {this.id,
      required this.totalPrice,
      required this.address,
      required this.orderStatus,
      required this.items,
      DateTime? dateTime})
      : dateTime = dateTime ?? DateTime.now();

  OrderItem copyWith(
      {String? id,
      double? totalPrice,
      Address? address,
      String? orderStatus,
      List<CartItem>? items,
      DateTime? dateTime}) {
    return OrderItem(
        id: id ?? this.id,
        totalPrice: totalPrice ?? this.totalPrice,
        address: address ?? this.address,
        orderStatus: orderStatus ?? this.orderStatus,
        items: items ?? this.items,
        dateTime: dateTime ?? this.dateTime);
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
        id: json['_id'],
        orderStatus: json['orderStatus'],
        totalPrice: double.parse(json['totalPrice'].toString()),
        address: Address.fromJson(json['address']),
        items: List.castFrom<dynamic, CartItem>(json['items']
            .map((cartItem) => CartItem.fromJson(cartItem))
            .toList()),
        dateTime: DateTime.tryParse(json['createdAt']));
  }
}
