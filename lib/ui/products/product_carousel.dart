import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/services/products.dart';
import 'package:tmdt/ui/products/products_detail_screen.dart';
import 'package:tmdt/utils/responseMapping.util.dart';

class ProductCarousel extends StatefulWidget {
  final ValueNotifier refreshNotifier;
  const ProductCarousel({super.key, required this.refreshNotifier});
  @override
  State<ProductCarousel> createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  Future futureMostSaleProduct =
      fetchProducts(initalQuery: 'sortBy=numberSold&isAsc=-1', pageSize: 6);
  final CarouselController _carouselController = CarouselController();
  int current = 0;

  @override
  void initState() {
    widget.refreshNotifier.addListener(() {
      setState(() {
        futureMostSaleProduct = fetchProducts(
            initalQuery: 'sortBy=numberSold&isAsc=-1', pageSize: 6);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return SizedBox(
      child: FutureBuilder(
          builder: (context, snapshot) {
            List<Product> productsList = List.empty();
            if (snapshot.hasData) {
              productsList = productResponseMapping(snapshot.data);
            }

            return snapshot.connectionState == ConnectionState.done
                ? Column(children: [
                    CarouselSlider(
                        carouselController: _carouselController,
                        items: [
                          for (var i = 0; i < productsList.length; i += 2)
                            Row(
                              children: [
                                Expanded(
                                    child: InkWell(
                                  onTap: (() {
                                    Navigator.of(context).pushNamed(
                                        ProductDetailScreen.routename,
                                        arguments: productsList[i]);
                                  }),
                                  child: Container(
                                    height: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.network(
                                                productsList[i].imageUrl,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              productsList[i].title,
                                              style: themeData
                                                  .textTheme.titleSmall,
                                            ),
                                            Text(
                                              productsList[i].price.toString(),
                                            )
                                          ],
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2)),
                                        Expanded(
                                            child: Text(
                                          productsList[i].description,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ))
                                      ],
                                    ),
                                  ),
                                )),
                                i < productsList.length - 1
                                    ? Expanded(
                                        child: InkWell(
                                        onTap: (() {
                                          Navigator.of(context).pushNamed(
                                              ProductDetailScreen.routename,
                                              arguments: productsList[i + 1]);
                                        }),
                                        child: Container(
                                          height: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7),
                                          child: Column(children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: AspectRatio(
                                                aspectRatio: 1,
                                                child: Image.network(
                                                    productsList[i + 1]
                                                        .imageUrl,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2)),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  productsList[i + 1].title,
                                                  style: themeData
                                                      .textTheme.titleSmall,
                                                ),
                                                Text(
                                                  productsList[i + 1]
                                                      .price
                                                      .toString(),
                                                )
                                              ],
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2)),
                                            Expanded(
                                                child: Text(
                                              productsList[i + 1].description,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ))
                                          ]),
                                        ),
                                      ))
                                    : const Spacer()
                              ],
                            )
                        ],
                        options: CarouselOptions(
                          onPageChanged: (index, reason) => setState(() {
                            current = index;
                          }),
                          enlargeCenterPage: false,
                          enableInfiniteScroll: false,
                          viewportFraction: 1,
                          height: 270,
                          aspectRatio: 1 / 1,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0;
                            i < (productsList.length / 2).round();
                            i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Container(
                                height: 5,
                                width: 5,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: i == current
                                        ? Colors.black
                                        : Colors.grey)),
                          )
                      ],
                    )
                  ])
                : const SizedBox(
                    height: 270,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
          },
          future: futureMostSaleProduct),
    );
  }
}
