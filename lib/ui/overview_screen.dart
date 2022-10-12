import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/services/cart.dart';
import 'package:tmdt/services/products.dart';
import 'package:tmdt/ui/drawer/drawer.dart';
import 'package:tmdt/ui/products/products_grid.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/shared/ui/404.dart';
import 'package:tmdt/ui/shared/ui/badges.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/ui/shared/utils/debouncer.util.dart';
import 'package:tmdt/utils/responseMapping.util.dart';

enum FilterOptions { favorite, all }

class OverviewScreen extends StatefulWidget {
  static String routeName = '/';
  final Future<Map> futureProductResponse;
  final Future<void> Function() reloadProducts;
  const OverviewScreen(
      {required this.futureProductResponse,
      required this.reloadProducts,
      Key? key})
      : super(key: key);

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final _showOnlyFavorites = false;
  late Future<dynamic> futureSearchResponse = Future.value();
  final FocusNode _searchFocusNode = FocusNode();
  bool isSearching = false;
  Debouncer handleSeachDebounce =
      Debouncer(delay: const Duration(milliseconds: 300));

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(handleChangeFocus);
    fetchCart().then((itemsList) =>
        Provider.of<CartList>(context, listen: false).setCartList = itemsList);
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
        leading: isSearching
            ? buildSearchBackIcon()
            : Builder(builder: ((context) => buildDrawerIcon(context))),
        centerTitle: true,
        title: buildSearchBar(
            onSearch: (value) => handleSeachDebounce(() {
                  setState(() {
                    futureSearchResponse =
                        fetchProducts(initalQuery: '?title=$value');
                  });
                }),
            focusNode: _searchFocusNode),
        actions: <Widget>[
          Consumer<CartList>(
            builder: (context, value, child) => buildShoppingCartIcon(
                iconThemeData: iconThemeData,
                cartList: value,
                context: context),
          )
        ],
      ),
      body: isSearching
          ? FutureBuilder(
              future: futureSearchResponse,
              builder: (context, snapshot) {
                List<Product> productData = List.empty();
                if (snapshot.hasData) {
                  productData = productResponseMapping(snapshot);
                }
                return snapshot.hasData
                    ? productData.isNotEmpty
                        ? buildSearchResultList(productData: productData)
                        : const NotFoundPage()
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              },
            )
          : FutureBuilder(
              future: widget.futureProductResponse,
              builder: (context, snapshot) {
                List<Product> productData = List.empty();
                if (snapshot.hasData) {
                  productData = productResponseMapping(snapshot);
                }

                return snapshot.hasData
                    ? RefreshIndicator(
                        onRefresh: widget.reloadProducts,
                        child: productData.isNotEmpty
                            ? ProductsGrid(_showOnlyFavorites, productData)
                            : ListView(
                                children: const [NotFoundPage()],
                              ))
                    : const Center(child: CircularProgressIndicator());
              }),
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

  Widget buildSearchResultList({required List<Product> productData}) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(10),
      children: productData
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: BorderSide.none),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        ProductDetailScreen.routeName,
                        arguments: item.productId);
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: SizedBox(
                            height: 70,
                            width: 100,
                            child: Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(5)),
                      Flexible(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item.title,
                            style: textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.description,
                            style: textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget buildSearchBackIcon() {
    return IconButton(
        onPressed: () {
          _searchFocusNode.unfocus();
          setState(() {
            isSearching = false;
          });
        },
        icon: Icon(
          FluentIcons.arrow_left_16_regular,
          color: Theme.of(context).iconTheme.color,
          size: Theme.of(context).iconTheme.size,
        ));
  }

  void handleChangeFocus() {
    if (_searchFocusNode.hasFocus) {
      setState(() {
        isSearching = true;
      });
    }
  }
}
