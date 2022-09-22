import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

Widget backIcon(BuildContext context) {
  return IconButton(
    icon: const Icon(
      FluentIcons.arrow_left_28_regular,
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
}
