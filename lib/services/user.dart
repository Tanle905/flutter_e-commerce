import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tmdt/constants/endpoints.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/utils/storage.util.dart';

Future<User?> fetchUserProfile() async {
  try {
    final authResponse = await Dio().get(
      baseUrl + PROFILE_ENDPOINT,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${(await getAccessToken())}'
      }),
    );
    final User data = User.fromJson(authResponse.data);
    return data;
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }
  return null;
}

Future<User?> updateUserProfile(payload) async {
  try {
    final authResponse = await Dio().put(baseUrl + PROFILE_ENDPOINT,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${(await getAccessToken())}'
        }),
        data: jsonEncode(payload));
    final User data = User.fromJson(authResponse.data);
    return data;
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }
  return null;
}
