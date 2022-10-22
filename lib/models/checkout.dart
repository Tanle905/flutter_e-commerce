import 'package:flutter/material.dart';
import 'package:tmdt/models/address.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/user.dart';

class CheckoutDetails extends ChangeNotifier {
  User? user;
  List<CartItem>? cartItems;
  Address? address;
  double? totalPrice;

  CheckoutDetails({this.user, this.address, this.cartItems, this.totalPrice});

  set setUser(User user) {
    this.user = user;
  }

  set setProductsList(List<CartItem> cartItems) {
    this.cartItems = cartItems;
  }

  set setAddress(Address address) {
    this.address = address;
    notifyListeners();
  }

  set setTotalPrice(double totalPrice) {
    this.totalPrice = totalPrice;
    notifyListeners();
  }
}
