import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/services/auth.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/shared/styles/input_styles.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';
import 'package:tmdt/utils/validator.util.dart';

class UserLoginScreen extends StatelessWidget {
  static const routeName = '/user-login';
  UserLoginScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final Map loginFormData = {'username': null, 'password': null};
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final IconThemeData iconThemeData = Theme.of(context).iconTheme;

    return Scaffold(
      backgroundColor: themeData.backgroundColor,
      appBar: AppBar(
        iconTheme: iconThemeData,
        leading: Builder(
          builder: (context) => buildBackIcon(context),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 200,
                  child: Text(
                    'Login To Your Account',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Form(
                    key: _formKey,
                    child: Column(
                      children: loginInputList(context: context)
                          .map((widget) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: widget,
                              ))
                          .toList(),
                    ))
              ],
            )),
      )),
    );
  }

  List<Widget> loginInputList({required BuildContext context}) {
    return [
      TextFormField(
        decoration: inputStyle(label: 'Username'),
        onSaved: (newValue) => loginFormData['username'] = newValue,
        validator: requiredValidator,
      ),
      TextFormField(
        decoration: inputStyle(label: 'Password'),
        onSaved: (newValue) => loginFormData['password'] = newValue,
        validator: requiredValidator,
      ),
      ElevatedButton(
          onPressed: () {
            handleSubmitForm(context);
          },
          child: const Text('Login'))
    ];
  }

  void handleSubmitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      login(loginFormData).then((value) {
        final authResponse = value;
        final accessToken = authResponse['accessToken'];
        storage.write(key: 'accessToken', value: accessToken).then((value) {
          final User user = User(
              userId: authResponse['id'],
              username: authResponse['username'],
              email: authResponse['email'],
              roles: (authResponse['roles'] as List<dynamic>).cast<String>());
          storage.write(key: KEY_USER_INFO, value: jsonEncode(user));
          Provider.of<UserModel>(context, listen: false).setUser = user;
          showSnackbar(
              context: context,
              message: 'Welcome back, ${authResponse['username']}');
          Navigator.of(context).pushReplacementNamed(OverviewScreen.routeName);
        });
      });
    }
  }
}
