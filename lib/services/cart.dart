import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tmdt/constants/endpoints.dart';
import 'package:tmdt/models/cart_items.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/utils/storage.util.dart';

Future<List<CartItem>> fetchCart() async {
  try {
    final cart = await http.get(Uri.parse(baseUrl + CART_ENDPOINT_BASE),
        headers: {'Authorization': 'Bearer ${(await getAccessToken())}'});
    final cartBody = jsonDecode(cart.body);
    print(cartBody['data']);
    return List.castFrom<dynamic, CartItem>(
        cartBody['data'].map((product) => CartItem.fromJson(product)).toList());
  } catch (error, stackTrace) {
    print('$error\n$stackTrace');
    throw ('$error\n$stackTrace');
  }
}
