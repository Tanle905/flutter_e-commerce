import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:tmdt/ui/cart/cart_screen.dart';
import 'package:tmdt/ui/drawer/drawer.dart';
import 'package:tmdt/ui/products/products_grid.dart';
import 'package:tmdt/ui/products/user_products_screen.dart';

enum FilterOptions { favorite, all }

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconThemeData = Theme.of(context).iconTheme;
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
            builder: ((context) => buildDrawerIcon(iconThemeData, context))),
        centerTitle: true,
        title: buildSearchBar(),
        actions: <Widget>[buildShoppingCartIcon(iconThemeData)],
      ),
      body: ProductsGrid(_showOnlyFavorites),
      drawer: const NavigationDrawer(),
      backgroundColor: themeData.backgroundColor,
    );
  }

  // Widget buildProductFilterMenu() {
  //   return PopupMenuButton(
  //     itemBuilder: (ctx) => [
  //       const PopupMenuItem(
  //         value: FilterOptions.favorite,
  //         child: Text('Only Favorite'),
  //       ),
  //       const PopupMenuItem(
  //         value: FilterOptions.all,
  //         child: Text('Show all'),
  //       )
  //     ],
  //     onSelected: (FilterOptions selectedValue) {
  //       setState(() {
  //         if (selectedValue == FilterOptions.favorite) {
  //           _showOnlyFavorites = true;
  //         }
  //         if (selectedValue == FilterOptions.all) _showOnlyFavorites = false;
  //       });
  //     },
  //     icon: const Icon(Icons.more_vert),
  //   );
  // }

  Widget buildSearchBar() {
    final InputDecorationTheme inputDecorationTheme =
        Theme.of(context).inputDecorationTheme;

    return Container(
      height: 40,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 1,
            spreadRadius: 1,
            offset: const Offset(1, 1))
      ]),
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            fillColor: inputDecorationTheme.fillColor,
            prefixIcon: const Icon(FluentIcons.search_32_regular),
            border: InputBorder.none,
            hintText: 'Search'),
      ),
    );
  }

  Widget buildDrawerIcon(IconThemeData iconThemeData, BuildContext context) {
    return IconButton(
      onPressed: (() => Scaffold.of(context).openDrawer()),
      icon: Icon(
        FluentIcons.list_28_regular,
        color: iconThemeData.color,
        size: iconThemeData.size,
      ),
    );
  }

  Widget buildShoppingCartIcon(IconThemeData iconThemeData) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const CartScreen(),
        ));
      },
      icon: Icon(
        FluentIcons.cart_16_regular,
        color: iconThemeData.color,
        size: iconThemeData.size,
      ),
    );
  }
}
