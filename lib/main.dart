import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tmdt/models/products.dart';
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
  late Future<dynamic> futureProductResponse;
  late Future<List<dynamic>> futureProductData;

  @override
  void initState() {
    super.initState();
    futureProductResponse = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                const UserProductsAddScreen())
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
    );
  }
}
