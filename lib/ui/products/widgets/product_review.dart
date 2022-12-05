import 'package:flutter/material.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/product_details_reviews_details_screen_arguments.dart';
import 'package:tmdt/models/review.dart';
import 'package:tmdt/ui/products/product_details_reviews_details_screen.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/ui/shared/ui/image_hero.dart';

class ProductReview extends StatefulWidget {
  final List<ReviewDetails> reviews;
  final String productId;
  const ProductReview(
      {super.key, required this.reviews, required this.productId});

  @override
  State<ProductReview> createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300)),
      child: widget.reviews.isNotEmpty
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "User Reviews",
                      style: themeData.textTheme.titleLarge,
                    ),
                    TextButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                            ProductDetailsReviewsDetailsScreen.routename,
                            arguments:
                                ProductDetailsReviewsDetailsScreenArguments(
                                    widget.productId)),
                        child: Text(
                          "View all",
                          style: themeData.textTheme.titleSmall,
                        ))
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                ...widget.reviews
                    .map((review) => ReviewDetailsWidget(
                          themeData: themeData,
                          review: review,
                          border: true,
                        ))
                    .toList()
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "User Reviews",
                    style: themeData.textTheme.titleLarge,
                  ),
                ),
                const Image(image: IMAGE_EMPTY_REVIEW_STAR, width: 90),
                Text(
                  'No User Review',
                  style: themeData.textTheme.titleMedium,
                )
              ],
            ),
    );
  }
}

class ReviewDetailsWidget extends StatelessWidget {
  final ReviewDetails review;
  final bool border;
  const ReviewDetailsWidget(
      {Key? key,
      required this.themeData,
      required this.review,
      required this.border})
      : super(key: key);

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              review.username,
              style: themeData.textTheme.titleMedium,
            ),
            StarRating(rating: review.stars)
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Text(
          review.description,
          textAlign: TextAlign.start,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: review.imageUrl
                .map((e) => GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed(ImageHero.routename, arguments: e),
                      child: Hero(
                          tag: 'imageHero',
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child: Image.network(
                                  e,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )),
                    ))
                .toList(),
          ),
        ),
        border ? const Divider() : const SizedBox.shrink()
      ],
    );
  }
}
