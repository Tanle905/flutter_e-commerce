import 'package:flutter/material.dart';

PreferredSizeWidget myAppbar() {
  return AppBar(
    actions: <Widget>[
      TextButton(
        onPressed: () {},
        child: const Text('Action 1'),
      ),
      TextButton(
        onPressed: () {},
        child: const Text('Action 2'),
      ),
    ],
  );
}
