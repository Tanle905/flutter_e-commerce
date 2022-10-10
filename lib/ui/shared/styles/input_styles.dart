import 'package:flutter/material.dart';

InputDecoration inputStyle(
    {required BuildContext context, String? label, Icon? icon}) {
  return InputDecoration(
      iconColor: Theme.of(context).iconTheme.color,
      labelText: label,
      prefixIcon: icon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));
}
