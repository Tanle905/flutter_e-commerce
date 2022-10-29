import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/services/auth.dart';
import 'package:tmdt/services/cart.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';
import 'package:tmdt/ui/user/user_manager.dart';
import 'package:tmdt/utils/error_handling.util.dart';

Future<void> handleLogin(
    {required GlobalKey<FormState> formKey,
    required Map formData,
    required BuildContext context}) async {
  try {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    formKey.currentState!.save();
    final user = await login(formData);
    if (user != null) {
      final accessToken = user.accessToken;
      await storage
          .write(key: KEY_ACCESS_TOKEN, value: accessToken)
          .then((value) async {
        Provider.of<UserManager>(context, listen: false).setUser = user;
        await fetchCart().then((itemsList) {
          Provider.of<CartList>(context, listen: false).setCartList = itemsList;
          showSnackbar(
              context: context, message: 'Welcome back, ${user.username}');
          Navigator.of(context).pushReplacementNamed(OverviewScreen.routeName);
        });
      });
    }
  } catch (error) {
    restApiErrorHandling(error, context);
  }
}
