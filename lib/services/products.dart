import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tmdt/constants/endpoints.dart';
import 'package:tmdt/utils/storage.util.dart';

Future<Map> fetchProducts({String? initalQuery}) async {
  String query = initalQuery ?? '?Page=1&pageSize=1000';
  Map productsData = {};
  try {
    final products = await Dio().get(baseUrl + PRODUCTS_ENDPOINT_BASE + query);
    productsData = products.data;
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }

  return productsData;
}

Future<dynamic> postProduct(dynamic payload) async {
  try {
    return await Dio().post(baseUrl + PRODUCTS_ENDPOINT_BASE,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${(await getAccessToken())}'
        }),
        data: jsonEncode(payload));
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }
}

Future<dynamic> updateProduct(
    {required dynamic payload, required String productId}) async {
  try {
    return await Dio().put('$baseUrl$PRODUCTS_ENDPOINT_BASE/$productId',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${(await getAccessToken())}'
        }),
        data: jsonEncode(payload));
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }
}

Future<dynamic> deleteProduct(List<String> idArray) async {
  try {
    final response = await Dio().delete(baseUrl + PRODUCTS_ENDPOINT_BASE,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${(await getAccessToken())}'
        }),
        data: jsonEncode({"idArray": idArray}));
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }
}
