import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/order_item.dart';
import 'package:tmdt/ui/products/product_review_add_screen.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const routename = '/order-details-screen';
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final OrderItem orderItem =
        ModalRoute.of(context)?.settings.arguments as OrderItem;
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: buildBackIcon(context),
        title: const Text('Order Details'),
        titleTextStyle: themeData.textTheme.titleLarge,
        centerTitle: true,
        iconTheme: themeData.iconTheme,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration:
            BoxDecoration(color: themeData.shadowColor.withOpacity(0.5)),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: themeData.backgroundColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Id: ${orderItem.id}',
                        style: themeData.textTheme.titleMedium,
                      ),
                      Text(
                        'Checkout date: ${DateFormat('dd/MM/yyyy hh:mm').format(orderItem.dateTime)}',
                      ),
                      Text(
                        'Status: ${orderItem.orderStatus}',
                        style: themeData.textTheme.titleMedium,
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: themeData.backgroundColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address Details',
                        style: themeData.textTheme.titleLarge,
                      ),
                      Text(
                        orderItem.address.fullName,
                        style: themeData.textTheme.titleMedium,
                      ),
                      Text(orderItem.address.phoneNumber.toString()),
                      Text(
                        '${orderItem.address.address}, ${orderItem.address.city}, ${orderItem.address.country}',
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: themeData.backgroundColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Items (${orderItem.items.length})',
                        style: themeData.textTheme.titleLarge,
                      ),
                      ...orderItem.items
                          .map((item) => Column(
                                children: [
                                  const Divider(),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: AspectRatio(
                                          aspectRatio: 1.4 / 1,
                                          child: Image.network(
                                            item.imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        item.title,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('x ${item.quantity}'),
                                                Text(item.price.toString())
                                              ],
                                            ),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5)),
                                            orderItem.orderStatus == DONE
                                                ? ElevatedButton(
                                                    onPressed: () => Navigator
                                                            .of(context)
                                                        .pushNamed(
                                                            ProductReviewAddScreen
                                                                .routename,
                                                            arguments: item),
                                                    child: const Text(
                                                        "Write review"),
                                                  )
                                                : const SizedBox.shrink()
                                          ]),
                                    ),
                                  ),
                                ],
                              ))
                          .toList()
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: themeData.backgroundColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: themeData.textTheme.titleMedium,
                          ),
                          Text(
                            orderItem.totalPrice.toString(),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Shipping',
                            style: themeData.textTheme.titleMedium,
                          ),
                          const Text('\$0')
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: themeData.textTheme.titleLarge,
                          ),
                          Text(
                            orderItem.totalPrice.toString(),
                            style: themeData.textTheme.titleMedium,
                          )
                        ],
                      ),
                    ]
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: e,
                            ))
                        .toList(),
                  ),
                )
              ]
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: e,
                      ))
                  .toList()),
        ),
      ),
    );
  }
}
