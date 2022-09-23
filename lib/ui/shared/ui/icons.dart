import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

Widget buildBackIcon(BuildContext context) {
  return IconButton(
    icon: const Icon(
      FluentIcons.arrow_left_28_regular,
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
}

Widget buildDrawerIcon(BuildContext context) {
  final IconThemeData iconThemeData = Theme.of(context).iconTheme;
  return IconButton(
    onPressed: (() => Scaffold.of(context).openDrawer()),
    icon: Icon(
      FluentIcons.list_28_regular,
      color: iconThemeData.color,
      size: iconThemeData.size,
    ),
  );
}
