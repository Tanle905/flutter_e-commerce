import 'package:tmdt/models/address.dart';
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

List<Address> addressResponseMapping(dynamic response) {
  return List.castFrom<dynamic, Address>((response as dynamic)['data']
      .map((address) => Address.fromJson(address))
      .toList());
}

List<String> citiesListResponseMapping(dynamic response) {
  return List.castFrom<dynamic, String>(
      response.map((city) => city['name']).toList());
}
