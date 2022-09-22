import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:tmdt/ui/constants.dart';
import 'package:tmdt/ui/products/products_manager.dart';
import 'package:tmdt/ui/products/user_products_list_tile.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsManager = ProductManager();
    final textTheme = Theme.of(context).textTheme;
    final IconThemeData iconThemeData = Theme.of(context).iconTheme;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: ((context) => backIcon(context))),
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
