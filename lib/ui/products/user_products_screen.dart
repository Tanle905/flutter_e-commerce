import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/main.dart';
import 'package:tmdt/ui/drawer/drawer.dart';
import 'package:tmdt/ui/products/user_products_list_tile.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/utils/responseMapping.util.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  final Future<Map> futureProductResponse;
  final Future<void> Function() reloadProducts;

  const UserProductsScreen(
      {Key? key,
      required this.reloadProducts,
      required this.futureProductResponse})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final IconThemeData iconThemeData = Theme.of(context).iconTheme;

    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        leading: Builder(builder: ((context) => buildDrawerIcon(context))),
        title: Text(
          'Your products',
          style: textTheme.titleLarge,
        ),
        actions: <Widget>[buildAddButton(iconThemeData, context)],
        iconTheme: iconThemeData,
      ),
      body: FutureBuilder(
        future: futureProductResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final productsManager =
                ProductManager(productResponseMapping(snapshot));
            return RefreshIndicator(
              onRefresh: reloadProducts,
              child: buildUserProductListView(productsManager),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget buildUserProductListView(ProductManager productManager) {
    return ListView.builder(
        itemCount: productManager.itemCount,
        itemBuilder: (ctx, i) => Column(
              children: [
                UserProductsListTile(
                  product: productManager.items[i],
                  reloadProducts: reloadProducts,
                ),
                const Divider()
              ],
            ));
  }

  Widget buildAddButton(IconThemeData iconThemeData, BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed(UserProductsAddScreen.routeName);
        },
        icon: const Icon(
          FluentIcons.add_16_regular,
        ));
  }
}
