import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/ui/drawer/drawer.dart';
import 'package:tmdt/ui/order/order_item_card.dart';
import 'package:tmdt/ui/order/order_manager.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderManager = Provider.of<OrderManager>(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final IconThemeData iconTheme = Theme.of(context).iconTheme;

    return Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          iconTheme: iconTheme,
          leading: Builder(builder: ((context) => buildDrawerIcon(context))),
          title: Text(
            'Your orders',
            style: textTheme.titleLarge,
          ),
        ),
        body: ListView.builder(
          itemBuilder: ((context, index) =>
              OrderItemCard(orderManager.orders[index])),
          itemCount: orderManager.orderCount,
        ));
  }
}
