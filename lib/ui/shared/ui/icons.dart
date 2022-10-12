import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/shared/ui/badges.dart';

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

Widget loadingIcon({required String text}) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(text),
        const SizedBox(
          width: 5,
        ),
        const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 3,
          ),
        )
      ],
    ),
  );
}

Widget buildShoppingCartIcon(
    {required IconThemeData iconThemeData,
    required CartList cartList,
    required BuildContext context}) {
  final int cartQuantities = CartManager(cartList).productCount;

  return TopRightBadge(
    data: cartQuantities,
    child: IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(CartScreen.routeName);
      },
      icon: Icon(
        FluentIcons.cart_16_regular,
        color: iconThemeData.color,
        size: iconThemeData.size,
      ),
    ),
  );
}
