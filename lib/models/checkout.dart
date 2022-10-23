import 'package:flutter/material.dart';
import 'package:tmdt/models/address.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/user.dart';

class CheckoutDetails extends ChangeNotifier {
  User? user;
  CartList? cartList;
  Address? address;
  double? totalPrice;
  String? currency;
  String? paymentStatus;
  String? orderStatus;

  CheckoutDetails(
      {this.user,
      this.address,
      this.cartList,
      this.totalPrice,
      this.currency,
      this.paymentStatus,
      this.orderStatus});

  set setUser(User user) {
    this.user = user;
    notifyListeners();
  }

  set setProductsList(CartList cartList) {
    this.cartList = cartList;
    notifyListeners();
  }

  set setAddress(Address address) {
    this.address = address;
    notifyListeners();
  }

  set setTotalPrice(double totalPrice) {
    this.totalPrice = totalPrice;
    notifyListeners();
  }

  set setCurrency(String currency) {
    this.currency = currency;
    notifyListeners();
  }

  set setPaymentStatus(String paymentStatus) {
    this.paymentStatus = paymentStatus;
  }

  set setOrderStatus(String orderStatus) {
    this.orderStatus = orderStatus;
  }
}
