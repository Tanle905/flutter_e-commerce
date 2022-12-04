import 'package:flutter/material.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/address.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/ui/checkout/checkout_manager.dart';
import 'package:tmdt/models/order_item.dart';
import 'package:tmdt/services/order.dart';

class OrderManager with ChangeNotifier {
  List<OrderItem> _orders = List.empty();

  set setOrder(List<OrderItem>? orderItem) {
    if (orderItem != null) {
      _orders = orderItem;
      notifyListeners();
    }
  }

  int get orderCount {
    return _orders.length;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(CheckoutManager checkoutDetails) async {
    if (checkoutDetails.cartList?.getCartList != null &&
        checkoutDetails.totalPrice != null) {
      await addUserOrder(checkoutDetails);
      _orders.insert(
          0,
          OrderItem(
              totalPrice: checkoutDetails.totalPrice as double,
              orderStatus: PENDING,
              address: checkoutDetails.address as Address,
              items: checkoutDetails.cartList?.getCartList as List<CartItem>,
              dateTime: DateTime.now(),
              id: 'o${DateTime.now().toIso8601String()}'));
      notifyListeners();
    }
  }
}
