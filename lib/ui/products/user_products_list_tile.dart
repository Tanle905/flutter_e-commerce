import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/services/products.dart';
import 'package:tmdt/ui/products/user_products_add.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';
import 'package:tmdt/ui/shared/utils/dialog_util.dart';

class UserProductsListTile extends StatelessWidget {
  final Product product;
  final VoidCallback refreshProduct;

  const UserProductsListTile(
      {Key? key, required this.product, required this.refreshProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductManager productManager =
        Provider.of<ProductManager>(context, listen: false);
    final ThemeData themeData = Theme.of(context);

    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: themeData.textTheme.titleLarge,
            textAlign: TextAlign.start,
          ),
          Text(
            product.description,
            style: themeData.textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
      leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl)),
      trailing: SizedBox(
        width: 100,
        child: Row(children: <Widget>[
          buildEditButton(context),
          buildDeleteButton(context, product.productId, productManager)
        ]),
      ),
      onTap: () => handleEditProduct(context),
    );
  }

  Widget buildDeleteButton(
      BuildContext context, String productId, ProductManager productManager) {
    return IconButton(
      onPressed: () => showConfirmDialog(
          context: context,
          message: "Do you want to delete this product?",
          onOk: () {
            deleteProduct(List.filled(1, productId)).then((value) {
              refreshProduct();
              showSnackbar(
                  context: context, message: "Product removed successfully!");
            },
                onError: (error) =>
                    showSnackbar(context: context, message: error['message']));
            Navigator.of(context).pop();
          },
          onCancel: () => Navigator.of(context).pop()),
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
          ),
        ));
  }
}
