import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/services/products.dart';
import 'package:tmdt/services/user.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/theme_manager.dart';
import 'package:tmdt/utils/error_handling.util.dart';
import 'package:tmdt/utils/responseMapping.util.dart';

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
  final storage = const FlutterSecureStorage();
  late Future<Map> futureProductResponse;

  @override
  void initState() {
    super.initState();
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(
        isLightMode ? myLightSystemTheme : myDarkSystemTheme);
    try {
      futureProductResponse = fetchProducts();
      fetchUserProfile().then((value) {
        user.setUser = value;
      });
    } catch (error) {
      restApiErrorHandling(error, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>.value(value: user),
        ChangeNotifierProvider<CartList>.value(value: cartList)
      ],
      child: FutureBuilder(
        future: futureProductResponse,
        builder: (context, snapshot) {
          List<Product> productData = List.empty();
          if (snapshot.hasData) {
            productData = productResponseMapping(snapshot);
          }

          return MaterialApp(
            title: 'My Shop',
            debugShowCheckedModeBanner: false,
            theme: lightTheme(),
            darkTheme: darkTheme(),
            themeMode: themeMode(),
            home: snapshot.hasData
                ? OverviewScreen(
                    futureProductResponse: futureProductResponse,
                    reloadProducts: reloadProducts,
                  )
                : const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
            routes: {
              CartScreen.routeName: (context) => const CartScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              UserProductsScreen.routeName: (context) => UserProductsScreen(
                    futureProductResponse: futureProductResponse,
                    reloadProducts: reloadProducts,
                  ),
              UserProductsAddScreen.routeName: ((context) =>
                  UserProductsAddScreen(
                    reloadProducts: reloadProducts,
                  )),
              UserLoginScreen.routeName: (context) => const UserLoginScreen(),
              UserSignUpScreen.routeName: (context) => const UserSignUpScreen(),
              UserSettingsScreen.routeName: (context) =>
                  const UserSettingsScreen()
            },
            onGenerateRoute: (settings) {
              if (settings.name == ProductDetailScreen.routeName) {
                final productId = settings.arguments as String;
                return MaterialPageRoute(builder: (context) {
                  return ProductDetailScreen(
                      ProductManager(productData).findById(productId));
                });
              }
              return null;
            },
          );
        },
      ),
    );
  }

  Future<void> reloadProducts() async => setState(() {
        futureProductResponse = fetchProducts();
      });
}
