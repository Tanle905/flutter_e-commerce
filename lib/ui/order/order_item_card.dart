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
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: <Widget>[
        buildOrderSummary(),
        if (_expanded) buildOrderDetails()
      ]),
    );
  }

  Widget buildOrderDetails() {
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
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${e.quantity}x \$${e.price}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.grey),
                      )
                    ],
                  ))
              .toList()),
    );
  }

  Widget buildOrderSummary() {
    return ListTile(
      title: Text('\$${widget.order.totalPrice}'),
      subtitle:
          Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
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
