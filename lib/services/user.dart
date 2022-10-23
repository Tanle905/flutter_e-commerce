import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tmdt/constants/endpoints.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/utils/storage.util.dart';

Future<User?> fetchUserProfile() async {
  try {
    final authResponse = await Dio().get(
      baseUrl + USER_PROFILE_ENDPOINT,
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
    final authResponse = await Dio().put(baseUrl + USER_PROFILE_ENDPOINT,
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

Future<Map> fetchUsersList(
    {String? initalQuery, int? page, int? pageSize}) async {
  String query = initalQuery ?? '?page=1&pageSize=1000';
  if (page != null && pageSize != null) {
    query = '?page=$page&pageSize=$pageSize';
  }
  Map user = {};
  try {
    final authResponse = await Dio().get(
      baseUrl + USER_MANAGEMENT_ENDPOINT + query,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${(await getAccessToken())}'
      }),
    );
    user = authResponse.data;
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }

  return user;
}

Future<Map<dynamic, dynamic>?> setUserStatus(String userId, bool value) async {
  try {
    return (await Dio().put('$baseUrl$USER_MANAGEMENT_ENDPOINT/$userId',
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${(await getAccessToken())}'
            }),
            data: jsonEncode({'isDeactivated': value})))
        .data;
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }
  return null;
}
