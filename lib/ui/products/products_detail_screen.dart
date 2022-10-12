import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  const ProductDetailScreen(this.product, {super.key});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: themeData.backgroundColor,
      appBar: AppBar(
        iconTheme: themeData.iconTheme,
        titleTextStyle: themeData.textTheme.titleLarge,
        leading: buildBackIcon(context),
        title: const Text("Keyboards"),
        centerTitle: true,
        actions: <Widget>[
          Consumer<CartList>(
            builder: (context, cartList, child) => buildShoppingCartIcon(
                iconThemeData: themeData.iconTheme,
                cartList: cartList,
                context: context),
          )
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        child: Stack(children: [
          SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      child: Text(
                        product.title,
                        style: themeData.textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Text(
                      product.description,
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  )
                ]
                    .map((widget) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: widget,
                        ))
                    .toList()
                    .cast<Widget>(),
              )),
          Positioned(
            bottom: 0,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                decoration:
                    BoxDecoration(color: themeData.colorScheme.secondary),
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Price",
                            style: themeData.textTheme.titleLarge,
                          ),
                          Text('\$${product.price}'),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white, alignment: Alignment.center),
                        child: const SizedBox(
                          width: 100,
                          height: 50,
                          child: Text(
                            "Add to cart",
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
