import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/services/products.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/theme_manager.dart';

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
  final storage = const FlutterSecureStorage();
  late Future<dynamic> futureProductResponse;

  @override
  void initState() {
    super.initState();
    futureProductResponse = fetchProducts();
    storage
        .read(key: KEY_ACCESS_TOKEN)
        .then((value) => storage.read(key: KEY_USER_INFO).then((storedUser) {
              if (storedUser != null) {
                user.setUser = User.fromJson(jsonDecode(storedUser));
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModel>.value(
      value: user,
      child: FutureBuilder(
        future: futureProductResponse,
        builder: (context, snapshot) {
          List productData = List.empty();

          if (snapshot.hasData) {
            productData = (snapshot.data as dynamic)['data']
                .map((product) => Product.fromJson(product))
                .toList();
          }

          return MaterialApp(
            title: 'My Shop',
            debugShowCheckedModeBanner: false,
            theme: lightTheme(),
            darkTheme: darkTheme(),
            themeMode: themeMode(),
            home: snapshot.hasData
                ? OverviewScreen(
                    productData: productData,
                    reloadProducts: reloadProducts,
                  )
                : const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
            routes: {
              CartScreen.routeName: (context) => const CartScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              UserProductsScreen.routeName: (context) => UserProductsScreen(
                  (snapshot.data as dynamic)['data']
                      .map((product) => Product.fromJson(product))
                      .toList()),
              UserProductsAddScreen.routeName: ((context) =>
                  const UserProductsAddScreen()),
              UserLoginScreen.routeName: (context) => UserLoginScreen()
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
