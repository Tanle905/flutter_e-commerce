import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/services/products.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/shared/ui/badges.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';
import 'package:tmdt/ui/user/user_manager.dart';
import 'package:tmdt/utils/storage.util.dart';

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
  final User? user = Provider.of<UserManager>(context).getUser;

  return TopRightBadge(
    data: cartQuantities,
    child: IconButton(
      onPressed: () => {
        Navigator.of(context).pushNamed(
            user != null ? CartScreen.routeName : UserLoginScreen.routeName)
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

class AddToFavoriteIcon extends StatefulWidget {
  final Product product;
  const AddToFavoriteIcon({Key? key, required this.product}) : super(key: key);

  @override
  State<AddToFavoriteIcon> createState() => _AddToFavoriteIconState();
}

class _AddToFavoriteIconState extends State<AddToFavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    final ProductManager productManager =
        Provider.of<ProductManager>(context, listen: false);
    final User? user = Provider.of<UserManager>(context).getUser;

    return ElevatedButton(
      onPressed: (() {
        if (user != null) {
          handleProductFavortie(widget.product.productId).then((response) {
            showSnackbar(context: context, message: response['message']);
            setState(() {
              widget.product.isFavorite = !widget.product.isFavorite;
            });
            productManager.updateProduct(widget.product);
          });
        } else {
          Navigator.of(context).pushNamed(UserLoginScreen.routeName);
        }
      }),
      style: ElevatedButton.styleFrom(shape: const CircleBorder()),
      child: Icon(
        widget.product.isFavorite
            ? FluentIcons.heart_48_filled
            : FluentIcons.heart_16_regular,
        color: widget.product.isFavorite
            ? HSLColor.fromColor(Colors.red).withLightness(0.6).toColor()
            : Colors.white,
      ),
    );
  }
}
