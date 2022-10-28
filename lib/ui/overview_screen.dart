import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/services/products.dart';
import 'package:tmdt/ui/drawer/drawer.dart';
import 'package:tmdt/ui/products/products_grid.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/shared/ui/404.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/ui/shared/utils/debouncer.util.dart';
import 'package:tmdt/utils/infinity_scroll_fetcher.util.dart';
import 'package:tmdt/utils/responseMapping.util.dart';

class OverviewScreen extends StatefulWidget {
  static String routeName = '/';
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  static const _pageSize = 8;
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 1);
  late Future<dynamic> futureSearchResponse = Future.value();
  final FocusNode _searchFocusNode = FocusNode();
  String sortBy = '';
  bool isSearching = false;
  Debouncer handleSeachDebounce =
      Debouncer(delay: const Duration(milliseconds: 300));

  @override
  void initState() {
    final ProductManager productManager =
        Provider.of<ProductManager>(context, listen: false);
    productManager.setInitialProductsList = List.empty();
    _pagingController.addPageRequestListener((pageKey) async {
      await fetchProductPage(
          page: pageKey,
          pageSize: _pageSize,
          pagingController: _pagingController,
          sortBy: sortBy,
          isAsc: true);
    });
    _pagingController.addListener(() {
      productManager.setInitialProductsList =
          _pagingController.itemList ?? List.empty();
    });
    _searchFocusNode.addListener(handleChangeFocus);
    super.initState();
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(handleChangeFocus);
    _pagingController.dispose();
    super.dispose();
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
                        fetchProducts(initalQuery: 'title=$value');
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
                  productData = productResponseMapping(snapshot.data);
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
          : RefreshIndicator(
              onRefresh: () => Future.sync(() => _pagingController.refresh()),
              child: Column(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Products',
                        style: themeData.textTheme.titleLarge,
                      ),
                      buildProductFilterMenu()
                    ],
                  ),
                ),
                Expanded(child: Consumer<ProductManager>(
                  builder: (context, productManager, child) {
                    if (productManager.productsList.isNotEmpty) {
                      _pagingController.itemList = productManager.productsList;
                    }

                    return ProductsGrid(
                      pagingController: _pagingController,
                    );
                  },
                ))
              ])),
      drawer: const NavigationDrawer(),
      backgroundColor: themeData.backgroundColor,
    );
  }

  Widget buildProductFilterMenu() {
    return PopupMenuButton(
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: 'title',
          child: Text('Sort by Title'),
        ),
        const PopupMenuItem(
          value: 'price',
          child: Text('Sort by Price'),
        ),
        const PopupMenuItem(
          value: 'createdAt',
          child: Text('Sort by Latest'),
        )
      ],
      onSelected: (String value) {
        setState(() {
          sortBy = value;
        });
        Future.sync(() => _pagingController.refresh());
      },
      icon: const Icon(FluentIcons.more_horizontal_48_regular),
    );
  }

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
          .map((product) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: BorderSide.none),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(product),
                    ));
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1, vertical: 2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: SizedBox(
                            height: 70,
                            width: 100,
                            child: Image.network(
                              product.imageUrl,
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
                            product.title,
                            style: textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            product.price.toString(),
                            style: textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            product.description,
                            style: textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
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
