import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/services/products.dart';
import 'package:tmdt/ui/products/user_products_add.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';

class UserProductsListTile extends StatelessWidget {
  final Product product;
  final Future<void> Function() reloadProducts;

  const UserProductsListTile(
      {Key? key, required this.product, required this.reloadProducts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl)),
      trailing: SizedBox(
        width: 100,
        child: Row(children: <Widget>[
          buildEditButton(context),
          buildDeleteButton(context, product.productId)
        ]),
      ),
      onTap: () => handleEditProduct(context),
    );
  }

  Widget buildDeleteButton(BuildContext context, String productId) {
    return IconButton(
      onPressed: () async {
        try {
          await deleteProduct(List.filled(1, productId));
          reloadProducts();
          showSnackbar(
              context: context, message: "Product removed successfully!");
        } catch (error) {
          rethrow;
        }
      },
      icon: const Icon(FluentIcons.delete_16_regular),
      color: Theme.of(context).errorColor,
    );
  }

  Widget buildEditButton(BuildContext context) {
    return IconButton(
      onPressed: (() => handleEditProduct(context)),
      icon: const Icon(FluentIcons.edit_16_regular),
    );
  }

  void handleEditProduct(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProductsAddScreen(
            initalData: product,
            reloadProducts: reloadProducts,
          ),
        ));
  }
}
