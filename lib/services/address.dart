import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tmdt/constants/endpoints.dart';
import 'package:tmdt/models/address.dart';
import 'package:tmdt/utils/responseMapping.util.dart';
import 'package:tmdt/utils/storage.util.dart';

Future<List<Address>> fetchUserAddress() async {
  List<Address> data = List.empty();

  try {
    final response = await Dio().get(
      baseUrl + USER_ADDRESS_ENDPOINT,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${(await getAccessToken())}'
      }),
    );
    data = addressResponseMapping(response.data);
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }

  return data;
}

Future<List<dynamic>> fetchCities({int? depth}) async {
  List<dynamic> data = List.empty();

  try {
    final response = await Dio().get(VietnamProvinceBaseUrl);
    data = citiesListResponseMapping(response.data);
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }

  return data;
}

Future<dynamic> addUserAddress(dynamic payload) async {
  try {
    final response = await Dio().put(baseUrl + USER_PROFILE_ENDPOINT,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${(await getAccessToken())}'
        }),
        data: jsonEncode({
          'address': [payload]
        }));
    return response.data;
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }
}
