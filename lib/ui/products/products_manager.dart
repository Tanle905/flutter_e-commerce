import 'package:tmdt/models/products.dart';

class ProductManager {
  final List<Product> _items;

  ProductManager(this._items);

  int get itemCount {
    return _items.length;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.productId == id);
  }
}
