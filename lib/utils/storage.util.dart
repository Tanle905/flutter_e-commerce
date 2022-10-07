import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tmdt/constants/constants.dart';

Future<String?> getAccessToken() async {
  const storage = FlutterSecureStorage();
  return storage.read(key: KEY_ACCESS_TOKEN);
}
