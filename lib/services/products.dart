import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tmdt/constants/endpoints.dart';

Future<dynamic> fetchProducts() async {
  try {
    final products =
        await http.get(Uri.parse(baseUrl + PRODUCTS_ENDPOINT_BASE));
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
