import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:tmdt/models/product_details_reviews_details_screen_arguments.dart';
import 'package:tmdt/models/review.dart';
import 'package:tmdt/services/review.dart';
import 'package:tmdt/ui/products/widgets/product_review.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';

import '../../models/product_details_reviews_details_screen_arguments.dart';

class ProductDetailsReviewsDetailsScreen extends StatefulWidget {
  static const routename = "/user-details-reviews-details-screen";
  const ProductDetailsReviewsDetailsScreen({super.key});

  @override
  State<ProductDetailsReviewsDetailsScreen> createState() =>
      _ProductDetailsReviewsDetailsScreenState();
}

class _ProductDetailsReviewsDetailsScreenState
    extends State<ProductDetailsReviewsDetailsScreen> {
  Future<List<ReviewDetails>> reviewDetailsFuture = Future.value(List.empty());

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final String productId = (ModalRoute.of(context)?.settings.arguments
            as ProductDetailsReviewsDetailsScreenArguments)
        .productId;
    reviewDetailsFuture = ReviewService().fetchReviews(productId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("All User Reviews"),
        iconTheme: themeData.iconTheme,
        titleTextStyle: themeData.textTheme.titleLarge,
        leading: buildBackIcon(context),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<ReviewDetails>>(
          future: reviewDetailsFuture,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null
                ? Column(
                    children: snapshot.data!
                        .map((review) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey.shade300)),
                              child: ReviewDetailsWidget(
                                themeData: themeData,
                                review: review,
                                border: false,
                              ),
                            ))
                        .toList(),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}
