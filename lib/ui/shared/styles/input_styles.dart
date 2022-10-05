import 'package:flutter/material.dart';

InputDecoration inputStyle({String? label}) {
  return InputDecoration(
      labelText: label,
      enabledBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      fillColor: Colors.grey.shade300);
}
