import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/ui/drawer/drawer.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/shared/ui/404.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/ui/user/user_management_list_tile.dart';
import 'package:tmdt/utils/infinity_scroll_fetcher.util.dart';

class UsersManagementScreen extends StatefulWidget {
  static const routeName = '/user-management';

  const UsersManagementScreen({Key? key}) : super(key: key);

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  static const _pageSize = 10;
  final PagingController<int, User> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      fetchUserPage(
          page: pageKey,
          pageSize: _pageSize,
          pagingController: _pagingController);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final IconThemeData iconThemeData = Theme.of(context).iconTheme;

    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        leading: Builder(builder: ((context) => buildDrawerIcon(context))),
        title: Text(
          'Users Management',
          style: textTheme.titleLarge,
        ),
        iconTheme: iconThemeData,
      ),
      body: buildUsersListView(pagingController: _pagingController),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Widget buildUsersListView(
      {required PagingController<int, User> pagingController}) {
    return RefreshIndicator(
        onRefresh: () => Future.sync(() => pagingController.refresh()),
        child: PagedListView<int, User>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate(
                noItemsFoundIndicatorBuilder: (context) => const NotFoundPage(),
                itemBuilder: (ctx, user, index) => Column(
                      children: [
                        UserManagementListTile(user: user),
                        const Divider()
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
