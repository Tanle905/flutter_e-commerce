import 'package:flutter/material.dart';
import 'package:tmdt/models/order_item.dart';
import 'package:tmdt/services/order.dart';
import 'package:tmdt/ui/drawer/drawer.dart';
import 'package:tmdt/ui/order/user_order_management_card.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';

class UserOrderManagementScreen extends StatefulWidget {
  static const routename = '/user-order-management-screen';
  const UserOrderManagementScreen({super.key});

  @override
  State<UserOrderManagementScreen> createState() =>
      _UserOrderManagementScreenState();
}

class _UserOrderManagementScreenState extends State<UserOrderManagementScreen> {
  Future<List<OrderItem>> futureOrderItemsList = fetchOrders();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => buildDrawerIcon(context),
        ),
        iconTheme: themeData.iconTheme,
        title: const Text("Order Management"),
        centerTitle: true,
        titleTextStyle: themeData.textTheme.titleLarge,
      ),
      body: RefreshIndicator(
          onRefresh: () => futureOrderItemsList = fetchOrders(),
          child: FutureBuilder<List<OrderItem>>(
            future: futureOrderItemsList,
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done
                  ? ListView.builder(
                      itemBuilder: (context, index) => UserOrderManagementCard(
                        order: snapshot.data![index],
                      ),
                      itemCount: snapshot.data?.length,
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            },
          )),
      drawer: const NavigationDrawer(),
    );
  }
}
