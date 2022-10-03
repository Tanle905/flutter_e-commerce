import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tmdt/constants/endpoints.dart';

Future<dynamic> fetchProducts({String? initalQuery}) async {
  String query = initalQuery ?? '?Page=1&pageSize=1000';
  try {
    final products =
        await http.get(Uri.parse('$baseUrl$PRODUCTS_ENDPOINT_BASE$query'));
    final productsBody = jsonDecode(products.body);
    return productsBody;
  } catch (error, stackTrace) {
    throw ('$error\n$stackTrace');
  }
}

Future<dynamic> postProduct(dynamic payload) async {
  try {
    return await http.post(Uri.parse(baseUrl + PRODUCTS_ENDPOINT_BASE),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload));
  } catch (error, stackTrace) {
    throw ('$error\n$stackTrace');
  }
}
