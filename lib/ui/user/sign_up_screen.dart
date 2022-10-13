import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/services/auth.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/shared/styles/input_styles.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';
import 'package:tmdt/utils/auth.util.dart';
import 'package:tmdt/utils/error_handling.util.dart';
import 'package:tmdt/utils/validator.util.dart';

class UserSignUpScreen extends StatefulWidget {
  static const routeName = '/user-signUp';
  const UserSignUpScreen({Key? key}) : super(key: key);

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map signUpFormData = {
    'username': null,
    'email': null,
    'password': null
  };
  final FlutterSecureStorage storage = const FlutterSecureStorage();
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
                      'Create An Account',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: signUpInputList(context: context)
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
                      const Text('Join us before?'),
                      TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(UserLoginScreen.routeName),
                          child: Text(
                            'Log in!',
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

  List<Widget> signUpInputList({required BuildContext context}) {
    return [
      TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: inputStyle(
            context: context,
            label: 'Username',
            icon: const Icon(FluentIcons.person_16_regular)),
        onSaved: (newValue) => signUpFormData['username'] = newValue,
        validator: requiredValidator,
      ),
      TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: inputStyle(
            context: context,
            label: 'Email',
            icon: const Icon(FluentIcons.mail_16_regular)),
        onSaved: (newValue) => signUpFormData['email'] = newValue,
        validator: emailValidator,
      ),
      TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: true,
        decoration: inputStyle(
            context: context,
            label: 'Password',
            icon: const Icon(FluentIcons.lock_closed_16_regular)),
        onSaved: (newValue) => signUpFormData['password'] = newValue,
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
                ? loadingIcon(text: "Creating Account...")
                : const Text('Create Account')),
      )
    ];
  }

  void handleSubmitForm(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      _formKey.currentState!.save();
      await signUp(signUpFormData);
      await handleLogin(
          formKey: _formKey, formData: signUpFormData, context: context);
    } catch (error) {
      restApiErrorHandling(error, context);
    }
    setState(() {
      isLoading = false;
    });
  }
}
