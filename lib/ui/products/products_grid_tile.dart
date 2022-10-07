import 'dart:ui';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/services/cart.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';

class ProductGridTile extends StatelessWidget {
  const ProductGridTile(this.product, {super.key});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final Color shadowColor = Theme.of(context).shadowColor;

    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: shadowColor.withOpacity(0.3),
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(2, 2))
          ]),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: GridTile(
            footer: buildGridFooterBar(context),
            child: GestureDetector(
              onTap: (() {
                Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                    arguments: product.productId);
              }),
              child: Container(
                padding: const EdgeInsets.all(0.5),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )),
    );
  }

  Widget buildGridFooterBar(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final ColorScheme accentColor = Theme.of(context).colorScheme;

    return ClipRRect(
      child: Container(
        decoration:
            BoxDecoration(color: primaryColor.withOpacity(0.6), boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 2,
              spreadRadius: 1,
              offset: const Offset(0, -1))
        ]),
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: (() {
                      print('Add item to favorite');
                    }),
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        primary: accentColor.secondary),
                    child: Icon(
                      FluentIcons.heart_16_filled,
                      color: product.isFavorite
                          ? Colors.red.shade400
                          : primaryColor,
                    ),
                  ),
                  Text('\$${product.price.toString()}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  ElevatedButton(
                    onPressed: (() async {
                      await addToCart(product: product, quantity: 1);
                      await fetchCart().then((itemsList) =>
                          Provider.of<CartList>(context, listen: false)
                              .setCartList = itemsList);
                      showSnackbar(
                          context: context, message: 'Product added to cart!');
                    }),
                    style:
                        ElevatedButton.styleFrom(shape: const CircleBorder()),
                    child: Icon(
                      FluentIcons.cart_16_filled,
                      color: primaryColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
