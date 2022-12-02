import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/services/cart.dart';
import 'package:tmdt/services/user.dart';
import 'package:tmdt/ui/address/user_address_add_screen.dart';
import 'package:tmdt/ui/address/user_address_screen.dart';
import 'package:tmdt/ui/checkout/checkout_screen.dart';
import 'package:tmdt/ui/products/product_details_reviews_details_screen.dart';
import 'package:tmdt/ui/products/user_favorite_products_list.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/theme_manager.dart';
import 'package:tmdt/ui/user/user_manager.dart';
import 'package:tmdt/utils/storage.util.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey = STRIPE_PUBLIC_KEY;
  await Stripe.instance.applySettings();
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
  final UserManager userManager = UserManager();
  final ProductManager productManager = ProductManager();
  final OrderManager orderManager = OrderManager();
  final CartList cartList = CartList(List.empty());

  @override
  void initState() {
    final window = WidgetsBinding.instance.window;
    bool isLightMode = window.platformBrightness == Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(
        isLightMode ? myLightSystemTheme : myDarkSystemTheme);

    //On Device Theme Mode Change Event
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
                userManager.setUser = value;
                orderManager.setOrder = userManager.getUser?.order;
              }),
              fetchCart().then((itemsList) => cartList.setCartList = itemsList)
            }
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserManager>.value(value: userManager),
        ChangeNotifierProvider<ProductManager>.value(value: productManager),
        ChangeNotifierProvider<OrderManager>.value(value: orderManager),
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
              const UsersManagementScreen(),
          UserAddressScreen.routeName: (context) => const UserAddressScreen(),
          CheckoutScreen.routeName: (context) => const CheckoutScreen(),
          UserAddressAddScreen.routeName: (context) =>
              const UserAddressAddScreen(),
          UserFavoriteProductsScreen.routeName: (context) =>
              const UserFavoriteProductsScreen(),
          ProductDetailsReviewsDetailsScreen.routename: (context) =>
              const ProductDetailsReviewsDetailsScreen(),
          ProductDetailScreen.routename: (context) =>
              const ProductDetailScreen()
        },
      ),
    );
  }
}
