import 'package:dio/dio.dart';
import 'package:tmdt/constants/endpoints.dart';
import 'package:tmdt/models/review.dart';
import 'package:tmdt/utils/responseMapping.util.dart';

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
}
