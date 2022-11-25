import 'package:flutter/material.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/review.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';

class ProductReview extends StatefulWidget {
  final List<ReviewDetails> reviews;
  const ProductReview({super.key, required this.reviews});

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
                    Text(
                      "View all",
                      style: themeData.textTheme.titleSmall,
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                ...widget.reviews
                    .map((review) => Column(
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                review.description,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Row(
                              children: review.imageUrl
                                  .map((e) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: SizedBox(
                                            width: 70,
                                            height: 70,
                                            child: Image.network(e),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const Divider()
                          ],
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
