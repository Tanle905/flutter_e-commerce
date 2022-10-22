import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/ui/cart/cart_manager.dart';

class ReviewStep extends StatefulWidget {
  final Future<dynamic> Function() onStepContinue;

  const ReviewStep({Key? key, required this.onStepContinue}) : super(key: key);

  @override
  State<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends State<ReviewStep> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _expanded = false;
    final ThemeData themeData = Theme.of(context);
    final CartList cartList = Provider.of<CartList>(context);
    final CartManager cartManager = CartManager(cartList);

    return SingleChildScrollView(
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              "Review Product",
              style: themeData.textTheme.titleLarge,
            ),
          ),
        ),
        SizedBox(
            height: min(cartManager.items.getCartList.length * 50.0 + 50, 1000),
            child: ListView.builder(
              itemCount: cartManager.items.getCartList.length,
              itemBuilder: (context, index) =>
                  buildCartList(cartManager.items.getCartList[index]),
            ))
      ]),
    );
  }

  Widget buildCartList(CartItem cartItem) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(cartItem.imageUrl, fit: BoxFit.contain),
      ),
      title: Text(cartItem.title),
      subtitle: Text('x${cartItem.quantity.toString()}'),
      trailing: Text((cartItem.quantity * cartItem.price).toString()),
    );
  }
}
