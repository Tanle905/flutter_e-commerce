import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/shared/styles/input_styles.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/utils/auth.util.dart';
import 'package:tmdt/utils/validator.util.dart';

class UserLoginScreen extends StatefulWidget {
  static const routeName = '/user-login';
  const UserLoginScreen({Key? key}) : super(key: key);

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map loginFormData = {'username': null, 'password': null};
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
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
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 600,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 250,
                    child: Text(
                      'Login To Your Account',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: loginInputList(context: context)
                            .map((widget) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7),
                                  child: widget,
                                ))
                            .toList(),
                      )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Don\'t have an Account?'),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2)),
                      TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(UserSignUpScreen.routeName),
                          child: Text(
                            'Sign up now!',
                            style: textTheme.labelLarge,
                          ))
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  List<Widget> loginInputList({required BuildContext context}) {
    return [
      TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: inputStyle(
            context: context,
            label: 'Username',
            icon: const Icon(FluentIcons.person_16_regular)),
        onSaved: (newValue) => loginFormData['username'] = newValue,
        validator: requiredValidator,
      ),
      TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: true,
        decoration: inputStyle(
            context: context,
            label: 'Password',
            icon: const Icon(FluentIcons.lock_closed_16_regular)),
        onSaved: (newValue) => loginFormData['password'] = newValue,
        validator: requiredValidator,
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
      SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      handleSubmitForm(context);
                    }
                  },
            child: isLoading
                ? loadingIcon(text: "Logging in...")
                : const Text('Login')),
      )
    ];
  }

  void handleSubmitForm(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    await handleLogin(
        formKey: _formKey, formData: loginFormData, context: context);
    setState(() {
      isLoading = false;
    });
  }
}
