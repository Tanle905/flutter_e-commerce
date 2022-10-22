import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/address.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/checkout.dart';
import 'package:tmdt/ui/address/user_address_card.dart';
import 'package:tmdt/ui/cart/cart_manager.dart';

class ReviewStep extends StatefulWidget {
  final Future<dynamic> Function() onStepContinue;

  const ReviewStep({Key? key, required this.onStepContinue}) : super(key: key);

  @override
  State<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends State<ReviewStep> {
  bool _expanded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CheckoutDetails checkoutDetails =
        Provider.of<CheckoutDetails>(context);
    final CartList cartList = Provider.of<CartList>(context);
    final ThemeData themeData = Theme.of(context);
    final CartManager cartManager = CartManager(cartList);

    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        InkWell(
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Product Summary",
                    style: themeData.textTheme.titleMedium,
                  ),
                  Text(
                    'Tap to ${_expanded ? 'hide' : 'show'}',
                    style: themeData.textTheme.titleSmall,
                  ),
                  Text(
                    "${cartManager.totalAmount}",
                    style: themeData.textTheme.titleLarge,
                  )
                ],
              ),
            ),
          ),
        ),
        _expanded
            ? SizedBox(
                height:
                    min(cartManager.items.getCartList.length * 70.0 + 10, 1000),
                child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: cartManager.items.getCartList
                        .map((e) => buildCartList(e))
                        .toList()))
            : const SizedBox.shrink(),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
            child: Text(
              "Review Shipping Address",
              style: themeData.textTheme.titleMedium,
            ),
          ),
        ),
        UserAddressCard(userAddress: checkoutDetails.address as Address),
        const Padding(padding: EdgeInsets.only(top: 10)),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
              onPressed: () => widget.onStepContinue(),
              child: const Text('Continue to Payment')),
        )
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
