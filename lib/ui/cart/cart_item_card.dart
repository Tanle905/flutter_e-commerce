import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/ui/shared/utils/dialog_util.dart';

class CartItemCard extends StatelessWidget {
  final String productId;
  final CartItem cartItem;
  const CartItemCard(
      {required this.productId, required this.cartItem, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(cartItem.productId),
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
          return showConfirmDialog(context, MODAL_DELETE_CONFIRM_TITLE,
              MODAL_DELETE_CONFIRM_MESSAGE);
        },
        onDismissed: (direction) {
          print('Cart item di');
        },
        child: buildItemCard());
  }

  Widget buildItemCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: ListTile(
          leading: CircleAvatar(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: Image.network(cartItem.imageUrl),
            ),
          ),
          title: Text(cartItem.title),
          subtitle: Text('Total: \$${cartItem.price * cartItem.quantity}'),
          trailing: Text('${cartItem.quantity} x'),
        ),
      ),
    );
  }
}
