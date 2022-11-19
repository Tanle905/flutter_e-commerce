import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/ui/products/products_grid_tile.dart';
import 'package:tmdt/ui/shared/ui/404.dart';

class ProductsGrid extends StatelessWidget {
  final PagingController<int, Product> pagingController;
  const ProductsGrid({Key? key, required this.pagingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagedGridView<int, Product>(
      pagingController: pagingController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (ctx, product, index) {
          return ProductGridTile(product);
        },
        noItemsFoundIndicatorBuilder: (context) => const NotFoundPage(),
      ),
      padding: const EdgeInsets.all(10),
    );
  }
}
