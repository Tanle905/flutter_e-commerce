import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/services/products.dart';
import 'package:tmdt/ui/drawer/drawer.dart';
import 'package:tmdt/ui/products/products_grid.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/shared/ui/badges.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/ui/shared/utils/debouncer.util.dart';

enum FilterOptions { favorite, all }

class OverviewScreen extends StatefulWidget {
  final List productData;
  final Future<void> Function() reloadProducts;
  const OverviewScreen(
      {required this.productData, required this.reloadProducts, Key? key})
      : super(key: key);

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final _showOnlyFavorites = false;
  late Future<dynamic> futureSearchResponse = Future.value();
  late Future<List<dynamic>> futureProductData;
  final FocusNode _searchFocusNode = FocusNode();
  bool isSearching = false;
  Debouncer handleSeachDebounce =
      Debouncer(delay: const Duration(milliseconds: 800));

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(handleChangeFocus);
  }

  @override
  void dispose() {
    super.dispose();
    _searchFocusNode.removeListener(handleChangeFocus);
  }

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconThemeData = Theme.of(context).iconTheme;
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: ((context) => buildDrawerIcon(context))),
        centerTitle: true,
        title: buildSearchBar(
            onSearch: (value) => handleSeachDebounce(() {
                  setState(() {
                    futureSearchResponse =
                        fetchProducts(initalQuery: '?title=$value');
                  });
                }),
            focusNode: _searchFocusNode),
        actions: <Widget>[buildShoppingCartIcon(iconThemeData)],
      ),
      body: isSearching
          ? FutureBuilder(
              future: futureSearchResponse,
              builder: (context, snapshot) {
                List productData = List.empty();
                if (snapshot.hasData) {
                  productData = (snapshot.data as dynamic)['data']
                      .map((product) => Product.fromJson(product))
                      .toList();
                }
                return snapshot.hasData
                    ? ListView(
                        padding: const EdgeInsets.all(10),
                        children: productData
                            .map((item) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide.none),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            ProductDetailScreen.routeName,
                                            arguments: item.productId);
                                      },
                                      child: GestureDetector(
                                        onTap: () {
                                          _searchFocusNode.unfocus();
                                        },
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 10),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: SizedBox(
                                                  height: 80,
                                                  width: 100,
                                                  child: Image.network(
                                                    item.imageUrl,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.all(5)),
                                            Text(
                                              item.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            )
                                          ],
                                        ),
                                      )),
                                ))
                            .toList(),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              },
            )
          : widget.productData.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: widget.reloadProducts,
                  child: ProductsGrid(_showOnlyFavorites, widget.productData))
              : const Center(child: CircularProgressIndicator()),
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

  Widget buildSearchBar(
      {Function(String)? onSearch, required FocusNode focusNode}) {
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
        focusNode: focusNode,
        onChanged: onSearch,
        decoration: InputDecoration(
            filled: true,
            fillColor: inputDecorationTheme.fillColor,
            prefixIcon: const Icon(FluentIcons.search_32_regular),
            border: InputBorder.none,
            hintText: 'Search'),
      ),
    );
  }

  Widget buildShoppingCartIcon(IconThemeData iconThemeData) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return TopRightBadge(
          data: CartManager().productCount,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
            icon: Icon(
              FluentIcons.cart_16_regular,
              color: iconThemeData.color,
              size: iconThemeData.size,
            ),
          ),
        );
      },
    );
  }

  void handleChangeFocus() {
    setState(() {
      isSearching = _searchFocusNode.hasFocus;
    });
    print(isSearching);
  }
}
