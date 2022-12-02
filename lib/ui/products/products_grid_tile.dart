import 'dart:ui';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/ui/products/utils/product.utils.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/ui/user/user_manager.dart';

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
                Navigator.of(context).pushNamed(ProductDetailScreen.routename,
                    arguments: product);
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
    final TextTheme textTheme = Theme.of(context).textTheme;
    final User? user = Provider.of<UserManager>(context).getUser;

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
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      product.title,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 17,
                          color: textTheme.titleLarge?.color,
                          fontWeight: textTheme.titleLarge?.fontWeight,
                          overflow: TextOverflow.ellipsis),
                    ),
                  )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AddToFavoriteIcon(product: product),
                  Flexible(
                      child: Text('\$${product.price.toString()}',
                          style: TextStyle(
                              fontSize: 15,
                              color: textTheme.titleLarge?.color,
                              fontWeight: textTheme.titleLarge?.fontWeight,
                              overflow: TextOverflow.ellipsis))),
                  AddToCartIcon(product: product, user: user),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
