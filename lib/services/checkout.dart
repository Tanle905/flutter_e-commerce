import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tmdt/constants/endpoints.dart';
import 'package:tmdt/ui/checkout/checkout_manager.dart';

Future<dynamic> createPaymentIntents(
    {required bool useStripeSDK,
    required String paymentMethodId,
    required String currency,
    required CheckoutManager checkoutDetails}) async {
  try {
    final data = await Dio().post(baseUrl + CHECKOUT_STRIPE_PAYMENT_INTENTS,
        data: jsonEncode({
          "useStripeSDK": useStripeSDK,
          "paymentMethodId": paymentMethodId,
          "currency": currency,
          "totalPrice": checkoutDetails.totalPrice
        }));
    return data.data;
  } on DioError catch (error) {
    if (error.response != null) {
      throw error.response!.data;
    }
  }
}
