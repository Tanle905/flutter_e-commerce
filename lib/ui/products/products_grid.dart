import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tmdt/ui/products/products_grid_tile.dart';
import 'package:tmdt/ui/products/products_manager.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;

  const ProductsGrid(this.showFavorites, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsManager = ProductManager();
    final products =
        showFavorites ? productsManager.favoriteItems : productsManager.items;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, i) => ProductGridTile(products[i]),
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
    );
  }
}
