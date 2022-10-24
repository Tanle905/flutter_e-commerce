import 'package:flutter/material.dart';
import 'package:tmdt/models/products.dart';

class ProductManager extends ChangeNotifier {
  List<Product> _productsList = List.empty();

  set setProductsList(List<Product> productsList) {
    _productsList = productsList;
    notifyListeners();
  }

  set setInitialProductsList(List<Product> productsList) {
    _productsList = productsList;
  }

  int get productsListCount {
    return _productsList.length;
  }

  List<Product> get productsList {
    return [..._productsList];
  }

  List<Product> get favoriteProducts {
    return _productsList.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _productsList.firstWhere((element) => element.productId == id);
  }

  void addProduct(Product product) {
    _productsList.insert(0, product);
    notifyListeners();
  }

  void updateProduct(Product product) {
    _productsList[_productsList
        .indexWhere((item) => item.productId == product.productId)] = product;
    notifyListeners();
  }

  void deleteProduct(Product product) {
    _productsList.removeAt(_productsList
        .indexWhere((item) => item.productId == product.productId));
    notifyListeners();
  }
}
