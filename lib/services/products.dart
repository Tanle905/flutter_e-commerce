import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tmdt/constants/endpoints.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/utils/responseMapping.util.dart';
import 'package:tmdt/utils/storage.util.dart';

Future<Map> fetchProducts(
    {String? initalQuery, int? page, int? pageSize}) async {
  String query = initalQuery != null ? '?$initalQuery' : '?';
  if (page != null) {
    query = '$query&page=$page';
  }
  if (pageSize != null) {
    query = '$query&pageSize=$pageSize';
  }
  Map productsData = {};
  try {
    final accessToken = await getAccessToken();
    final products = await Dio().get(baseUrl + PRODUCTS_ENDPOINT_BASE + query,
        options: accessToken != null
            ? Options(headers: {'Authorization': 'Bearer $accessToken'})
            : null);
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
    return response.data;
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }
}

Future<List<Product>> fetchFavorites() async {
  List<Product> data = List.empty();
  try {
    final accessToken = await getAccessToken();
    final products = await Dio().get(baseUrl + FAVORITE_ENDPOINT,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
    data = productResponseMapping(products.data);
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }

  return data;
}

Future<dynamic> handleProductFavortie(dynamic payload) async {
  try {
    final response = await Dio().put(baseUrl + FAVORITE_ENDPOINT,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${(await getAccessToken())}'
        }),
        data: jsonEncode({
          "data": [payload]
        }));
    return response.data;
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }
}
