import 'package:flutter/material.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/ui/products/products_grid_tile.dart';
import 'package:tmdt/ui/products/products_manager.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;
  final List<Product> productsData;
  const ProductsGrid(this.showFavorites, this.productsData, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsManager = ProductManager(productsData);
    final products =
        showFavorites ? productsManager.favoriteItems : productsManager.items;
    final ThemeData themeData = Theme.of(context);

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      itemBuilder: (ctx, i) {
        if (i == 0) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Find Your Styles.',
                style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.w900,
                    color: themeData.textTheme.headlineLarge?.color),
                textAlign: TextAlign.end,
              )
            ],
          );
        } else {
          return ProductGridTile(products[i - 1]);
        }
      },
      padding: const EdgeInsets.all(10),
      itemCount: products.length + 1,
    );
  }
}
