import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tmdt/constants/endpoints.dart';
import 'package:tmdt/models/products.dart';

Future<List<dynamic>> fetchProducts() async {
  try {
    final products =
        await http.get(Uri.parse(baseUrl + PRODUCTS_ENDPOINT_BASE));
    final productsBody = jsonDecode(products.body);
    return productsBody.map((product) => Product.fromJson(product)).toList();
  } catch (error, stackTrace) {
    throw ('$error\n$stackTrace');
  }
}
