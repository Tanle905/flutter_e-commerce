import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/ui/products/products_detail_screen.dart';

class ProductGridTile extends StatelessWidget {
  const ProductGridTile(this.product, {super.key});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(2, 2))
          ]),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: GridTile(
            footer: buildGridFooterBar(context),
            child: GestureDetector(
              onTap: (() {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product)));
              }),
              child: Container(
                padding: const EdgeInsets.all(0.5),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )),
    );
  }

  Widget buildGridFooterBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade300.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 2,
                spreadRadius: 1,
                offset: const Offset(0, -1))
          ]),
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                product.title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: (() {
                  print('Add item to favorite');
                }),
                style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                child: Icon(
                  FluentIcons.heart_16_filled,
                  color:
                      product.isFavorite ? Colors.red.shade400 : Colors.white,
                ),
              ),
              Text('\$${product.price.toString()}',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              ElevatedButton(
                onPressed: (() {
                  print('Add item to cart');
                }),
                style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                child: const Icon(FluentIcons.cart_16_filled),
              ),
            ],
          )
        ],
      ),
    );
  }
}
