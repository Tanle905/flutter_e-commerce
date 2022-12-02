import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/services/products.dart';
import 'package:tmdt/ui/products/products_detail_screen.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/ui/user/user_manager.dart';

class UserFavoriteProductsScreen extends StatefulWidget {
  static const routeName = 'user-favorite-products-list';
  const UserFavoriteProductsScreen({Key? key}) : super(key: key);

  @override
  State<UserFavoriteProductsScreen> createState() =>
      _UserFavoriteProductsScreenState();
}

class _UserFavoriteProductsScreenState
    extends State<UserFavoriteProductsScreen> {
  late Future<List<Product>> futureFavoriteProductsList;

  @override
  void initState() {
    futureFavoriteProductsList = fetchFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final User? user = Provider.of<UserManager>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        leading: buildBackIcon(context),
        title: const Text('Favorite Lists'),
        centerTitle: true,
        titleTextStyle: themeData.textTheme.titleLarge,
        iconTheme: themeData.iconTheme,
      ),
      body: FutureBuilder<List<Product>>(
        future: futureFavoriteProductsList,
        builder: (context, snapshot) => snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) => InkWell(
                      onTap: () => Navigator.of(context).pushNamed(
                          ProductDetailScreen.routename,
                          arguments: snapshot.data?[index] as Product),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                              width: 100,
                              child: Image.network(
                                snapshot.data?[index].imageUrl as String,
                                fit: BoxFit.cover,
                              )),
                        ),
                        title: Text(snapshot.data?[index].title as String),
                        subtitle: Text(
                          snapshot.data?[index].description as String,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: AddToCartIcon(
                            product: snapshot.data![index], user: user),
                      ),
                    ))
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
