import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:tmdt/ui/address/user_address_add_screen.dart';

Widget buildUserAddAddress(
    {required BuildContext context, required ThemeData themeData}) {
  return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () =>
          Navigator.of(context).pushNamed(UserAddressAddScreen.routeName),
      child: SizedBox(
        width: double.infinity,
        height: 125,
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          color: themeData.shadowColor,
          dashPattern: const [6, 3],
          strokeWidth: 1,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "+ Add Address",
              style: themeData.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ));
}
