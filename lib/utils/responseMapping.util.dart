import 'package:tmdt/models/products.dart';

List<Product> productResponseMapping(dynamic snapshot) {
  return List.castFrom<dynamic, Product>((snapshot.data as dynamic)['data']
      .map((product) => Product.fromJson(product))
      .toList());
}
