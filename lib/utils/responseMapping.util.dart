import 'package:tmdt/models/products.dart';
import 'package:tmdt/models/user.dart';

List<Product> productResponseMapping(dynamic response) {
  return List.castFrom<dynamic, Product>((response as dynamic)['data']
      .map((product) => Product.fromJson(product))
      .toList());
}

List<User> userResponseMapping(dynamic response) {
  return List.castFrom<dynamic, User>((response as dynamic)['data']
      .map((user) => User.fromJson(user))
      .toList());
}
