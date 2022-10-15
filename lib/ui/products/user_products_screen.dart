import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/ui/drawer/drawer.dart';
import 'package:tmdt/ui/products/user_products_list_tile.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/shared/ui/404.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/utils/infinity_scroll_fetcher.util.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  static const _pageSize = 8;
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      fetchProductPage(
          page: pageKey,
          pageSize: _pageSize,
          pagingController: _pagingController);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final IconThemeData iconThemeData = Theme.of(context).iconTheme;

    return Scaffold(
      backgroundColor: themeData.backgroundColor,
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        leading: Builder(builder: ((context) => buildDrawerIcon(context))),
        title: Text(
          'Your products',
          style: textTheme.titleLarge,
        ),
        actions: <Widget>[buildAddButton(iconThemeData, context)],
        iconTheme: iconThemeData,
      ),
      body: buildUserProductListView(pagingController: _pagingController),
    );
  }

  Widget buildUserProductListView(
      {required PagingController<int, Product> pagingController}) {
    return RefreshIndicator(
        onRefresh: () => Future.sync(() => pagingController.refresh()),
        child: PagedListView<int, Product>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate(
                noItemsFoundIndicatorBuilder: (context) => const NotFoundPage(),
                itemBuilder: (ctx, product, index) => Column(
                      children: [
                        UserProductsListTile(
                          product: product,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Divider(),
                        )
                      ],
                    ))));
  }

  Widget buildAddButton(IconThemeData iconThemeData, BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed(UserProductsAddScreen.routeName);
        },
        icon: const Icon(
          FluentIcons.add_16_regular,
        ));
  }
}
