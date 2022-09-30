import 'package:flutter/material.dart';
import 'package:tmdt/services/products.dart';
import 'package:tmdt/ui/appbar/Appbar.dart';
import 'package:tmdt/ui/products/products_detail_screen.dart';
import 'package:tmdt/ui/products/products_manager.dart';
import 'package:tmdt/ui/overview_screen.dart';
import 'package:tmdt/ui/products/user_products_screen.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/theme_manager.dart';

void main() {
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
  late Future<List<dynamic>> futureProduct;

  @override
  void initState() {
    super.initState();
    futureProduct = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureProduct,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'My Shop',
          debugShowCheckedModeBanner: false,
          theme: lightTheme(),
          darkTheme: darkTheme(),
          themeMode: themeMode(),
          home: snapshot.hasData
              ? const OverviewScreen()
              : const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
          routes: {
            CartScreen.routeName: (context) => const CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            UserProductsScreen.routeName: (context) =>
                UserProductsScreen(snapshot.data)
          },
          onGenerateRoute: (settings) {
            if (settings.name == ProductDetailScreen.routeName) {
              final productId = settings.arguments as String;
              return MaterialPageRoute(builder: (context) {
                return ProductDetailScreen(
                    ProductManager(snapshot.data).findById(productId));
              });
            }
            return null;
          },
        );
      },
    );
  }
}
