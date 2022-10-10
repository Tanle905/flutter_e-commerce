import 'package:flutter/material.dart';
import 'package:tmdt/constants/constants.dart';

void showSnackbar({required BuildContext context, required String message}) {
  SnackBar snackBar = SnackBar(
      backgroundColor: COLOR_BUTTON_AND_LINK_TEXT,
      content: Text(
        message,
        style: TextStyle(color: COLOR_TEXT_AND_ICON_DARK),
      ));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
