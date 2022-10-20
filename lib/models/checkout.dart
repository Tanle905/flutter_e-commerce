import 'package:flutter/material.dart';
import 'package:tmdt/models/address.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/models/user.dart';

class CheckoutDetails extends ChangeNotifier {
  User? user;
  List<Product>? productsList;
  Address? address;
  double? totalPrice;

  CheckoutDetails(
      {this.user, this.address, this.productsList, this.totalPrice});

  set setUser(User user) {
    this.user = user;
  }

  set setProductsList(List<Product> productsList) {
    this.productsList = productsList;
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
