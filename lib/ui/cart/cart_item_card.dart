import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/services/cart.dart';
import 'package:tmdt/ui/products/products_detail_screen.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';
import 'package:tmdt/ui/shared/utils/debouncer.util.dart';
import 'package:tmdt/ui/shared/utils/dialog_util.dart';

class CartItemCard extends StatefulWidget {
  final CartItem cartItem;
  const CartItemCard({required this.cartItem, Key? key}) : super(key: key);

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  ValueNotifier<int> itemCount = ValueNotifier<int>(1);
  final Debouncer debouncer =
      Debouncer(delay: const Duration(milliseconds: 500));

  @override
  void initState() {
    itemCount.value = widget.cartItem.quantity;
    itemCount.addListener(() {
      debouncer(() => updateItemInCart(
          product: Product.fromCartitem(widget.cartItem),
          quantity: itemCount.value));
    });
    super.initState();
  }

  @override
  void dispose() {
    itemCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartList = Provider.of<CartList>(context, listen: false);
    return GestureDetector(
        child: Dismissible(
            key: ValueKey(widget.cartItem.productId),
            background: Container(
              color: Theme.of(context).errorColor,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: const Icon(
                FluentIcons.delete_20_regular,
                color: Colors.white,
              ),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) {
              return showConfirmDialog(
                  context: context,
                  title: MODAL_DELETE_CONFIRM_TITLE,
                  message: MODAL_DELETE_CONFIRM_MESSAGE,
                  onCancel: () {
                    Navigator.of(context).pop(false);
                  },
                  onOk: () {
                    deleteItemInCart(productId: widget.cartItem.productId).then(
                        (response) {
                      showSnackbar(
                          context: context, message: response['message']);
                      cartList.deleteItemInCartList(widget.cartItem);
                    },
                        onError: (error) => showSnackbar(
                            context: context, message: error['message']));
                    Navigator.of(context).pop(true);
                  });
            },
            child: buildItemCard(context: context, cartList: cartList)),
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                        Product.fromCartitem(widget.cartItem),
                      )),
            ));
  }

  Widget buildItemCard(
      {required BuildContext context, required CartList cartList}) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: ListTile(
          leading: CircleAvatar(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: SizedBox(
                width: 150,
                height: 150,
                child: Image.network(
                  widget.cartItem.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          title: Text(
            widget.cartItem.title,
            style: textTheme.titleMedium,
          ),
          subtitle: Text(
              'Total: \$${widget.cartItem.price * widget.cartItem.quantity}'),
          trailing: SizedBox(
            width: 100,
            child: buildQuantityInputIcon(
                value: itemCount.value,
                onSubtract: () => itemCount.value > 1
                    ? setState(() {
                        itemCount.value--;
                        widget.cartItem.quantity = itemCount.value;
                        cartList.updateCartList(widget.cartItem);
                      })
                    : null,
                onAdd: () {
                  widget.cartItem.productQuantity > itemCount.value
                      ? setState(() {
                          itemCount.value++;
                          widget.cartItem.quantity = itemCount.value;
                          cartList.updateCartList(widget.cartItem);
                        })
                      : null;
                }),
          ),
        ),
      ),
    );
  }
}
