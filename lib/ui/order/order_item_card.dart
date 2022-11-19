import 'dart:math';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:tmdt/models/order_item.dart';
import 'package:intl/intl.dart';

class OrderItemCard extends StatefulWidget {
  final OrderItem order;

  const OrderItemCard(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: <Widget>[
        buildOrderSummary(textTheme: textTheme),
        if (_expanded) buildOrderDetails(textTheme: textTheme)
      ]),
    );
  }

  Widget buildOrderDetails({required TextTheme textTheme}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      height: min(widget.order.productCount * 20.0 + 10, 100),
      child: ListView(
          children: widget.order.items
              .map((e) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        e.title,
                        style: textTheme.titleMedium,
                      ),
                      Text(
                        '${e.quantity}x \$${e.price}',
                        style: textTheme.titleSmall,
                      )
                    ],
                  ))
              .toList()),
    );
  }

  Widget buildOrderSummary({required TextTheme textTheme}) {
    return ListTile(
      title: Text('Total: \$${widget.order.totalPrice}'),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            Text('Status: ${widget.order.orderStatus}')
          ]
              .map((e) => Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: e,
                  ))
              .toList(),
        ),
      ),
      trailing: IconButton(
        icon: Icon(_expanded
            ? FluentIcons.panel_left_16_regular
            : FluentIcons.panel_left_expand_16_regular),
        onPressed: () {
          setState(() {
            _expanded = !_expanded;
          });
        },
      ),
    );
  }
}
