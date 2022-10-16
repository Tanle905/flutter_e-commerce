import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/services/cart.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';
import 'package:tmdt/ui/user/login_screen.dart';
import 'package:tmdt/utils/storage.util.dart';

Future<void> handleAddToCart(
    {required Product product,
    required BuildContext context,
    int? quantity}) async {
  getAccessToken().then((value) async {
    if (value != null) {
      await addToCart(product: product, quantity: quantity ?? 1);
      Future.delayed(
          const Duration(milliseconds: 500),
          () => fetchCart().then((itemsList) {
                Provider.of<CartList>(context, listen: false).setCartList =
                    itemsList;
                showSnackbar(
                    context: context, message: 'Product added to cart!');
              }));
    } else {
      Navigator.of(context).pushNamed(UserLoginScreen.routeName);
    }
  });
}
