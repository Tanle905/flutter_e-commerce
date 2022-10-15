import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/services/user.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/theme_manager.dart';
import 'package:tmdt/ui/user/users_management_screen.dart';
import 'package:tmdt/utils/error_handling.util.dart';
import 'package:tmdt/utils/storage.util.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final UserModel user = UserModel();
  final CartList cartList = CartList(List.empty());

  @override
  void initState() {
    final window = WidgetsBinding.instance.window;
    bool isLightMode = window.platformBrightness == Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(
        isLightMode ? myLightSystemTheme : myDarkSystemTheme);
    //On Platform Brightness Change Event
    window.onPlatformBrightnessChanged = () {
      WidgetsBinding.instance.handlePlatformBrightnessChanged();
      isLightMode = window.platformBrightness == Brightness.light;
      SystemChrome.setSystemUIOverlayStyle(
          isLightMode ? myLightSystemTheme : myDarkSystemTheme);
    };
    getAccessToken().then((token) => {
          if (token != null)
            {
              fetchUserProfile().then((value) {
                user.setUser = value;
              }, onError: (error) {
                restApiErrorHandling(error, context);
              })
            }
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>.value(value: user),
        ChangeNotifierProvider<CartList>.value(value: cartList),
      ],
      child: MaterialApp(
        title: 'My Shop',
        debugShowCheckedModeBanner: false,
        theme: lightTheme(),
        darkTheme: darkTheme(),
        themeMode: themeMode(),
        home: const OverviewScreen(),
        routes: {
          CartScreen.routeName: (context) => const CartScreen(),
          OrdersScreen.routeName: (context) => const OrdersScreen(),
          UserProductsScreen.routeName: (context) => const UserProductsScreen(),
          UserProductsAddScreen.routeName: ((context) =>
              const UserProductsAddScreen()),
          UserLoginScreen.routeName: (context) => const UserLoginScreen(),
          UserSignUpScreen.routeName: (context) => const UserSignUpScreen(),
          UserSettingsScreen.routeName: (context) => const UserSettingsScreen(),
          UsersManagementScreen.routeName: (context) =>
              const UsersManagementScreen()
        },
      ),
    );
  }
}
