import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tmdt/constants/endpoints.dart';
import 'package:tmdt/ui/checkout/checkout_manager.dart';
import 'package:tmdt/utils/storage.util.dart';

Future<dynamic> addUserOrder(CheckoutManager checkoutDetails) async {
  final order = jsonEncode({
    'order': {
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
