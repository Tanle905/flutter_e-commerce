import 'package:flutter/material.dart';
import 'package:tmdt/ui/appbar/Appbar.dart';
import 'package:tmdt/ui/products/products_detail_screen.dart';
import 'package:tmdt/ui/products/products_manager.dart';
import 'package:tmdt/ui/products/products_overview_screen.dart';
import 'package:tmdt/ui/products/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
                .copyWith(secondary: Colors.deepOrange)),
        home: const SafeArea(child: ProductsOverviewScreen()));
  }
}
