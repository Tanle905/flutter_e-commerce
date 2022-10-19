import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/services/cart.dart';
import 'package:tmdt/ui/cart/cart_item_card.dart';
import 'package:tmdt/ui/cart/cart_manager.dart';
import 'package:tmdt/ui/checkout/checkout_screen.dart';
import 'package:tmdt/ui/order/orders_screen.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartItem>> futureCart;

  @override
  void initState() {
    super.initState();
    futureCart = fetchCart();
    futureCart.then((value) {
      Provider.of<CartList>(context, listen: false).setCartList = value;
    },
        onError: (error) =>
            showSnackbar(context: context, message: error['message']));
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final IconThemeData iconTheme = Theme.of(context).iconTheme;

    return FutureBuilder(
      future: futureCart,
      builder: (context, snapshot) {
        List<CartItem> itemsList = List.empty();
        if (snapshot.hasData) {
          itemsList =
              List.castFrom<dynamic, CartItem>(snapshot.data as List<dynamic>);
        }
        return Scaffold(
          appBar: AppBar(
              titleTextStyle: textTheme.titleLarge,
              centerTitle: true,
              iconTheme: iconTheme,
              leading: Builder(builder: (context) => buildBackIcon(context)),
              title: const Text(
                'Your cart',
              )),
          body: snapshot.hasData
              ? Column(
                  children: <Widget>[
                    Expanded(
                      child: buildCartDetails(CartManager(CartList(itemsList))),
                    ),
                    Consumer<CartList>(
                      builder: (context, cartList, child) => buildCartSummary(
                          textTheme, CartManager(cartList), context),
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }

  Widget buildCartSummary(
      TextTheme textTheme, CartManager cart, BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: themeData.shadowColor, blurRadius: 2, spreadRadius: 0.0),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          color: themeData.backgroundColor),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
                width: double.infinity,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total (${cart.productCount}):',
                        style: textTheme.titleMedium),
                    Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: textTheme.titleMedium),
                  ],
                )),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CheckoutScreen.routeName);
                },
                child: const Text('Go to Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCartDetails(CartManager cart) {
    return ListView(
      children: cart.items.getCartList
          .map((item) => CartItemCard(cartItem: item))
          .toList(),
    );
  }
}
