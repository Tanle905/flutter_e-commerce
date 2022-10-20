import 'package:flutter/material.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';

class UserAddressAddScreen extends StatefulWidget {
  static const routeName = '/user-address-add';

  const UserAddressAddScreen({Key? key}) : super(key: key);

  @override
  State<UserAddressAddScreen> createState() => _UserAddressAddScreenState();
}

class _UserAddressAddScreenState extends State<UserAddressAddScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
          iconTheme: themeData.iconTheme,
          leading: buildBackIcon(context),
          title: const Text("Add Shipping Address"),
          centerTitle: true,
          titleTextStyle: themeData.textTheme.titleLarge),
    );
  }
}
