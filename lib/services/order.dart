import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tmdt/constants/endpoints.dart';
import 'package:tmdt/models/order_item.dart';
import 'package:tmdt/ui/checkout/checkout_manager.dart';
import 'package:tmdt/utils/responseMapping.util.dart';
import 'package:tmdt/utils/storage.util.dart';

Future<List<OrderItem>> fetchOrders() async {
  List<OrderItem> orderItemsList = List.empty(growable: true);

  try {
    orderItemsList = orderResponseMapping((await Dio().get(
            baseUrl + ORDER_MANAGEMENT_ENDPOINT,
            options: Options(headers: {
              'Authorization': 'Bearer ${(await getAccessToken())}'
            })))
        .data);
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }

  return orderItemsList;
}

Future<dynamic> addUserOrder(CheckoutManager checkoutDetails) async {
  final order = jsonEncode({
    'order': {
      'userId': checkoutDetails.user?.userId,
      'orderStatus': checkoutDetails.orderStatus,
      'currency': checkoutDetails.currency,
      'items': checkoutDetails.cartList?.getCartList.map((item) {
        return {
          ...item.toJson(),
          "quantity": item.quantity,
          "_id": item.productId
        };
      }).toList(),
      'address': checkoutDetails.address?.toJson(),
      "paymentStatus": checkoutDetails.paymentStatus,
      'totalPrice': checkoutDetails.totalPrice
    }
  });
  try {
    return await Dio().put(baseUrl + USER_PROFILE_ENDPOINT,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${(await getAccessToken())}'
        }),
        data: order);
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }
}
