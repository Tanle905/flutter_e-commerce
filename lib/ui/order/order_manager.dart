import 'package:flutter/material.dart';
import 'package:tmdt/models/cart_items.dart';
import 'package:tmdt/models/order_item.dart';

class OrderManager with ChangeNotifier {
  final List<OrderItem> _orders = [
    OrderItem(
        id: 'o1',
        amount: 59.98,
        products: [
          CartItem(
              productId: 'c1',
              title: 'Red shirt',
              price: 29.99,
              quantity: 2,
              imageUrl: 'sdf')
        ],
        dateTime: DateTime.now())
  ];

  int get orderCount {
    return _orders.length;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }
}
