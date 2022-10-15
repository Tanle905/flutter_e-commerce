import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/services/cart.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';
import 'package:tmdt/ui/user/login_screen.dart';
import 'package:tmdt/utils/storage.util.dart';

void handleAddToCart(
    {required Product product, required BuildContext context, int? quantity}) {
  getAccessToken().then((value) {
    if (value != null) {
      addToCart(product: product, quantity: quantity ?? 1).then((value) {
        fetchCart().then((itemsList) {
          Provider.of<CartList>(context, listen: false).setCartList = itemsList;
          showSnackbar(context: context, message: 'Product added to cart!');
        });
      });
    } else {
      Navigator.of(context).pushNamed(UserLoginScreen.routeName);
    }
  });
}
