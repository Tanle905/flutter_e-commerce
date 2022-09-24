import 'package:flutter/material.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/ui/drawer/drawer.dart';
import 'package:tmdt/ui/products/products_manager.dart';
import 'package:tmdt/ui/products/user_products_list_tile.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  final productsData;

  const UserProductsScreen(this.productsData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsManager = ProductManager(productsData);
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
        actions: <Widget>[buildAddButton(iconThemeData)],
        iconTheme: iconThemeData,
      ),
      body: RefreshIndicator(
        onRefresh: () async => print('Refresh Product'),
        child: buildUserProductListView(productsManager),
      ),
    );
  }

  Widget buildUserProductListView(ProductManager productManager) {
    return ListView.builder(
        itemCount: productManager.itemCount,
        itemBuilder: (ctx, i) => Column(
              children: [
                UserProductsListTile(productManager.items[i]),
                const Divider()
              ],
            ));
  }

  Widget buildAddButton(IconThemeData iconThemeData) {
    return IconButton(
        onPressed: () {
          print('Go to edit product screen');
        },
        icon: const Icon(
          Icons.add,
        ));
  }
}
