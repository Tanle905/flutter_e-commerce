import 'package:flutter/material.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/ui/products/user_products_add_form.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';

class UserProductsAddScreen extends StatelessWidget {
  final Product? initalData;
  static const routeName = '/user-product-add';
  const UserProductsAddScreen({Key? key, this.initalData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final IconThemeData iconThemeData = Theme.of(context).iconTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a product'),
        titleTextStyle: textTheme.titleLarge,
        iconTheme: iconThemeData,
        leading: Builder(
          builder: (context) => buildBackIcon(context),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
              child: UserProductAddForm(
            initalData: initalData,
          ))),
    );
  }
}
