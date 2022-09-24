import 'package:flutter/material.dart';
import 'package:tmdt/services/cart.dart';
import 'package:tmdt/ui/cart/cart_item_card.dart';
import 'package:tmdt/ui/cart/cart_manager.dart';
import 'package:tmdt/ui/order/orders_screen.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<dynamic>> futureCart;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartManager();
    final TextTheme textTheme = Theme.of(context).textTheme;
    final IconThemeData iconTheme = Theme.of(context).iconTheme;

    return Scaffold(
      appBar: AppBar(
          iconTheme: iconTheme,
          leading: Builder(builder: (context) => buildBackIcon(context)),
          title: Text(
            'Your cart',
            style: textTheme.titleLarge,
          )),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: buildCartDetails(cart),
          )),
          const SizedBox(height: 10),
          buildCartSummary(textTheme, cart, context),
        ],
      ),
    );
  }

  Widget buildCartSummary(
      TextTheme textTheme, CartManager cart, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Total', style: TextStyle(fontSize: 20)),
            const Spacer(),
            Chip(
              label: Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                  style: textTheme.titleMedium),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const OrdersScreen()));
              },
              style: TextButton.styleFrom(textStyle: textTheme.titleSmall),
              child: const Text('ORDER NOW'),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCartDetails(CartManager cart) {
    return ListView(
      children: cart.productEntries
          .map((e) => CartItemCard(productId: e.key, cartItem: e.value))
          .toList(),
    );
  }
}
