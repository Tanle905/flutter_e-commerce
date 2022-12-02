import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/ui/products/utils/product.utils.dart';
import 'package:tmdt/ui/products/widgets/product_review.dart';
import 'package:tmdt/ui/shared/ui/expandable_text.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/ui/user/user_manager.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routename = '/product-details-screen';
  const ProductDetailScreen({super.key});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _viewTransformationController = TransformationController();
  int _itemCount = 1;
  double _imageHeight = 200;

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)?.settings.arguments as Product;
    final ThemeData themeData = Theme.of(context);
    final User? user = Provider.of<UserManager>(context).getUser;

    return Scaffold(
      backgroundColor: themeData.backgroundColor,
      appBar: AppBar(
        iconTheme: themeData.iconTheme,
        titleTextStyle: themeData.textTheme.titleLarge,
        leading: buildBackIcon(context),
        title: const Text("Keyboards"),
        centerTitle: true,
        actions: <Widget>[
          Consumer<CartList>(
            builder: (context, cartList, child) => buildShoppingCartIcon(
                iconThemeData: themeData.iconTheme,
                cartList: cartList,
                context: context),
          )
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        child: Stack(children: [
          SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      height: _imageHeight,
                      curve: Curves.fastOutSlowIn,
                      child: InteractiveViewer(
                          minScale: 1,
                          transformationController:
                              _viewTransformationController,
                          onInteractionStart: (details) {
                            setState(() {
                              _imageHeight = 400;
                            });
                          },
                          onInteractionEnd: (details) => setState(() {
                                _imageHeight = 200;
                                _viewTransformationController.value =
                                    Matrix4.identity();
                              }),
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        decoration: BoxDecoration(
                            color: COLOR_BUTTON_AND_LINK_TEXT,
                            borderRadius: BorderRadius.circular(5)),
                        child: const Text(
                          'Free shipping',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        child: AddToFavoriteIcon(product: product),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      child: Text(
                        product.title,
                        style: themeData.textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300)),
                    child: ExpandableText(
                      text: product.description,
                      trimLines: 7,
                      textStyle: themeData.textTheme.bodyMedium,
                    ),
                  ),
                  ProductReview(
                    reviews: product.reviews,
                    productId: product.productId,
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 100))
                ]
                    .map((widget) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: widget,
                        ))
                    .toList()
                    .cast<Widget>(),
              )),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: themeData.shadowColor,
                        blurRadius: 2,
                        spreadRadius: 0.0),
                  ],
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  color: themeData.backgroundColor),
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        product.productQuantity == 0
                            ? const Text(
                                'Out of Stock!',
                                style: TextStyle(color: Colors.red),
                              )
                            : product.productQuantity == _itemCount
                                ? const Text(
                                    'Items exceeds product quantity!',
                                    style: TextStyle(color: Colors.red),
                                  )
                                : const SizedBox.shrink(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Price",
                                  style: themeData.textTheme.titleMedium,
                                ),
                                Text(
                                  '\$${product.price * _itemCount}',
                                  style: themeData.textTheme.titleLarge,
                                ),
                              ]
                                  .map((widget) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: widget,
                                      ))
                                  .toList(),
                            ),
                            buildQuantityInputIcon(
                                value: _itemCount,
                                onSubtract: () => _itemCount > 1
                                    ? setState(() => _itemCount--)
                                    : null,
                                onAdd: () => setState(() =>
                                    product.productQuantity > _itemCount
                                        ? _itemCount++
                                        : null)),
                            SizedBox(
                              width: 150,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: product.productQuantity == 0
                                    ? null
                                    : () => handleAddToCart(
                                        product: product,
                                        context: context,
                                        quantity: _itemCount,
                                        user: user),
                                style: themeData.elevatedButtonTheme.style,
                                child: const Text(
                                  "Add to cart",
                                ),
                              ),
                            )
                          ],
                        ),
                      ])),
            ),
          ),
        ]),
      ),
    );
  }
}
