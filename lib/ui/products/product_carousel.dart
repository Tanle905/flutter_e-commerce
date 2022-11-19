import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/services/products.dart';
import 'package:tmdt/ui/products/products_detail_screen.dart';
import 'package:tmdt/utils/responseMapping.util.dart';

class ProductCarousel extends StatefulWidget {
  final ThemeData themeData;
  const ProductCarousel({super.key, required this.themeData});
  @override
  State<ProductCarousel> createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  int current = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FutureBuilder(
          builder: (context, snapshot) {
            List<Product> productsList = List.empty();
            if (snapshot.hasData) {
              productsList = productResponseMapping(snapshot.data);
            }

            return snapshot.hasData
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
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailScreen(productsList[i]),
                                    ));
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              productsList[i].title,
                                              style: widget.themeData.textTheme
                                                  .titleSmall,
                                            ),
                                            Text(
                                              productsList[i].price.toString(),
                                            )
                                          ],
                                        ),
                                        Text(
                                          productsList[i].description,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        )
                                      ]
                                          .map((widget) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2),
                                                child: widget,
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                )),
                                i < productsList.length - 1
                                    ? Expanded(
                                        child: InkWell(
                                        onTap: (() {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailScreen(
                                                    productsList[i + 1]),
                                          ));
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
                                                      productsList[i + 1]
                                                          .imageUrl,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    productsList[i + 1].title,
                                                    style: widget.themeData
                                                        .textTheme.titleSmall,
                                                  ),
                                                  Text(
                                                    productsList[i + 1]
                                                        .price
                                                        .toString(),
                                                  )
                                                ],
                                              ),
                                              Text(
                                                productsList[i + 1].description,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                              )
                                            ]
                                                .map((widget) => Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 2),
                                                      child: widget,
                                                    ))
                                                .toList(),
                                          ),
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
          future: fetchProducts(
              initalQuery: 'sortBy=numberSold&isAsc=-1', pageSize: 6)),
    );
  }
}
