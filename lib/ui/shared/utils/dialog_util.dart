import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(
    {required BuildContext context,
    String? title,
    required String message,
    required VoidCallback onOk,
    required VoidCallback onCancel}) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: title != null ? Text(title) : null,
            content: Text(message),
            actions: <Widget>[
              TextButton(onPressed: onCancel, child: const Text('No')),
              TextButton(onPressed: onOk, child: const Text('Yes')),
            ],
          ));
}

Future<bool?> showAlertDialog(
    BuildContext context, String title, String message) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok')),
            ],
          ));
}
