import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tmdt/constants/endpoints.dart';
import 'package:tmdt/models/cart_items.dart';
import 'package:tmdt/models/products.dart';

Future<Map<String, CartItem>> fetchCart() async {
  try {
    final cart = await http.get(Uri.parse(baseUrl + CART_ENDPOINT_BASE));
    final cartBody = jsonDecode(cart.body);
    return cartBody.map((product) => CartItem.fromJson(product));
  } catch (error, stackTrace) {
    throw ('$error\n$stackTrace');
  }
}
