import 'dart:convert';

import 'package:http/http.dart' as http;
import '../constants/endpoints.dart';

Future<dynamic> login(payload) async {
  try {
    final authResponse = await http.post(Uri.parse(baseUrl + LOGIN_ENDPOINT),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload));
    return jsonDecode(authResponse.body);
  } catch (error, stackTrace) {
    throw ('$error\n$stackTrace');
  }
}
