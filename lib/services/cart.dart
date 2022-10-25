import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:tmdt/constants/endpoints.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/utils/storage.util.dart';

Future<List<CartItem>> fetchCart() async {
  try {
    final cart = await http.get(Uri.parse(baseUrl + CART_ENDPOINT_BASE),
        headers: {'Authorization': 'Bearer ${(await getAccessToken())}'});
    final cartBody = jsonDecode(cart.body);
    final mappedCartData = List.castFrom<dynamic, CartItem>(
        cartBody['data'].map((product) => CartItem.fromJson(product)).toList());
    return mappedCartData;
  } catch (error, stackTrace) {
    throw ('$error\n$stackTrace');
  }
}

Future addToCart({required Product product, required int quantity}) async {
  try {
    final httpBody = jsonEncode({
      "data": [
        {'productId': product.productId, 'quantity': quantity}
      ]
    });
    http.post(Uri.parse(baseUrl + CART_ENDPOINT_BASE),
        body: httpBody,
        headers: {
          'Authorization': 'Bearer ${await getAccessToken()}',
          'Content-Type': 'application/json'
        });
  } catch (error, stackTrace) {
    throw ('$error\n$stackTrace');
  }
}

Future updateItemInCart(
    {required Product product, required int quantity}) async {
  try {
    final httpBody = jsonEncode({
      "data": [
        {'productId': product.productId, 'quantity': quantity}
      ]
    });
    http.put(Uri.parse(baseUrl + CART_ENDPOINT_BASE), body: httpBody, headers: {
      'Authorization': 'Bearer ${await getAccessToken()}',
      'Content-Type': 'application/json'
    });
  } catch (error, stackTrace) {
    throw ('$error\n$stackTrace');
  }
}

Future deleteItemInCart({required String productId}) async {
  final mappedData = {
    "data": [
      {"productId": productId}
    ]
  };

  try {
    final response = await Dio().delete(baseUrl + CART_ENDPOINT_BASE,
        data: jsonEncode(mappedData),
        options: Options(headers: {
          'Authorization': 'Bearer ${await getAccessToken()}',
          'Content-Type': 'application/json'
        }));
    return response.data;
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response?.data;
    }
  }
}

Future<dynamic> clearCart(String? userId) async {
  try {
    await Dio().delete('$baseUrl$CART_ENDPOINT_BASE/$userId',
        options: Options(headers: {
          'Authorization': 'Bearer ${await getAccessToken()}',
          'Content-Type': 'application/json'
        }));
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response?.data;
    }
  }
}
