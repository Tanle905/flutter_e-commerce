import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tmdt/constants/endpoints.dart';
import 'package:tmdt/models/review.dart';
import 'package:tmdt/utils/responseMapping.util.dart';
import 'package:tmdt/utils/storage.util.dart';

class ReviewService {
  Future<List<ReviewDetails>> fetchReviews(String productId) async {
    List<ReviewDetails> reviewDetailsList = List.empty();
    try {
      reviewDetailsList = reviewDetailsResponseMapping(
          (await Dio().get('$baseUrl$PRODUCT_REVIEW_ENDPOINT/$productId'))
              .data);
    } on DioError catch (error) {
      if (error.response != null) {
        throw error.response!.data;
      }
    }
    return reviewDetailsList;
  }

  Future<void> postReview(dynamic payload) async {
    try {
      await Dio().post(baseUrl + REVIEW_ENDPOINT,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${(await getAccessToken())}'
          }),
          data: jsonEncode(payload));
    } on DioError catch (error) {
      if (error.response != null) {
        throw error.response!.data;
      }
    }
  }
}
