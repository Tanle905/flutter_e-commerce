import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:tmdt/constants/constants.dart';
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

Widget buildQuantityInputIcon(
    {VoidCallback? onSubtract, VoidCallback? onAdd, required int value}) {
  return Row(
    children: [
      Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              border: Border.all(color: COLOR_SHADOW),
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(5))),
          alignment: Alignment.center,
          child: IconButton(
            padding: const EdgeInsets.all(0),
            alignment: Alignment.center,
            icon: const Icon(
              FluentIcons.subtract_16_regular,
              size: 15,
            ),
            onPressed: onSubtract,
          )),
      Container(
          width: 35,
          height: 25,
          decoration: const BoxDecoration(
              border: Border.symmetric(
                  horizontal: BorderSide(color: COLOR_SHADOW))),
          alignment: Alignment.center,
          child: Text(value.toString())),
      Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              border: Border.all(color: COLOR_SHADOW),
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(5))),
          alignment: Alignment.center,
          child: IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(
                FluentIcons.add_16_regular,
                size: 15,
              ),
              onPressed: onAdd))
    ],
  );
}
