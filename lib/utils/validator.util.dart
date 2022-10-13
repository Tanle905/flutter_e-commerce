import 'package:flutter/services.dart';

String? requiredValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required!';
  }
  return null;
}

String? emailValidator(String? value) {
  bool emailValid = value != null
      ? RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value)
      : false;

  if (value == null || value.isEmpty || (!emailValid)) {
    return 'A valid email is required!';
  }
  return null;
}

final FilteringTextInputFormatter numberFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
