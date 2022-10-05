import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:tmdt/ui/screens.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).padding.top, 0, 0),
      child: Drawer(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListTile(
              leading: const Icon(
                FluentIcons.door_16_regular,
              ),
              title: const Text('Login'),
              onTap: () {
                Navigator.of(context).pushNamed(UserLoginScreen.routeName);
              },
            ),
            ListTile(
              leading: const Icon(
                FluentIcons.shopping_bag_16_regular,
              ),
              title: const Text('Shop'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            ListTile(
              leading: const Icon(
                FluentIcons.payment_16_regular,
              ),
              title: const Text('Orders'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              },
            ),
            ListTile(
              leading: const Icon(
                FluentIcons.edit_16_regular,
              ),
              title: const Text('Manage Products'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              },
            )
          ],
        )),
      ),
    );
  }
}
