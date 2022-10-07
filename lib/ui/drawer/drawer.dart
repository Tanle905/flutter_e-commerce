import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';

class NavigationDrawer extends StatelessWidget {
  final User? userInfo;
  const NavigationDrawer({Key? key, this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Drawer(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 260,
              child: DrawerHeader(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox(
                        width: 100,
                        height: 100,
                        child: userInfo?.imageUrl != null
                            ? Image.network(userInfo?.imageUrl as String)
                            : const Image(image: placeholderImage)),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  userInfo != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              userInfo?.username as String,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  const storage = FlutterSecureStorage();
                                  storage.delete(key: KEY_ACCESS_TOKEN);
                                  storage.delete(key: KEY_USER_INFO);
                                  Provider.of<UserModel>(context, listen: false)
                                      .setUser = null;
                                  showSnackbar(
                                      context: context,
                                      message: "Log out completed!");
                                },
                                child: const Text('Log out'))
                          ],
                        )
                      : ElevatedButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(UserLoginScreen.routeName),
                          child: const Text('Login'))
                ],
              )),
            ),
            ListTile(
              leading: const Icon(
                FluentIcons.shopping_bag_16_regular,
              ),
              title: const Text('Shop'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OverviewScreen.routeName);
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
            userInfo != null && userInfo!.roles!.contains(ROLE_ADMIN)
                ? ListTile(
                    leading: const Icon(
                      FluentIcons.edit_16_regular,
                    ),
                    title: const Text('Manage Products'),
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(UserProductsScreen.routeName);
                    },
                  )
                : const SizedBox.shrink()
          ],
        )),
      ),
    );
  }
}
