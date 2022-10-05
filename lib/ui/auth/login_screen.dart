import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tmdt/services/auth.dart';
import 'package:tmdt/ui/shared/styles/input_styles.dart';
import 'package:tmdt/utils/validator.util.dart';

class UserLoginScreen extends StatelessWidget {
  static const routeName = '/user-login';
  UserLoginScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final Map loginFormData = {'username': null, 'password': null};
  final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                      children: loginInputList()
                          .map((widget) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: widget,
                              ))
                          .toList(),
                    ))
              ],
            )),
      ),
    );
  }

  List<Widget> loginInputList() {
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
      ElevatedButton(onPressed: handleSubmitForm, child: const Text('Login'))
    ];
  }

  void handleSubmitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final accessToken = (await login(loginFormData) as Map)['accessToken'];
      await storage.write(key: 'accessToken', value: accessToken);
    }
  }
}
