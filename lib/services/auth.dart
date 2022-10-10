import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tmdt/models/user.dart';
import '../constants/endpoints.dart';

Future<User?> login(payload) async {
  try {
    final authResponse = await Dio().post(baseUrl + LOGIN_ENDPOINT,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode(payload));
    final Map data = authResponse.data;
    return User.fromJson(data.cast());
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }
  return null;
}

Future<Map<String, String>?> signUp(payload) async {
  try {
    final authResponse = await Dio().post(baseUrl + SIGNUP_ENDPOINT,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode(payload));
    final Map data = authResponse.data;
    return data.cast();
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }
  return null;
}
