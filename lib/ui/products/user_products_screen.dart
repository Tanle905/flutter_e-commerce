import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tmdt/ui/products/products_manager.dart';
import 'package:tmdt/ui/products/user_products_list_tile.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsManager = ProductManager();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: <Widget>[buildAddButton()],
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

  Widget buildAddButton() {
    return IconButton(
        onPressed: () {
          print('Go to edit product screen');
        },
        icon: const Icon(Icons.add));
  }
}
