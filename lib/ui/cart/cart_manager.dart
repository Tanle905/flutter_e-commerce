import 'package:tmdt/models/cart_items.dart';

class CartManager {
  final CartList _items;
  CartManager(this._items);

  int get productCount {
    return _items.getCartList.length;
  }

  CartList get items {
    return _items;
  }

  double get totalAmount {
    var total = 0.0;
    for (var item in _items.getCartList) {
      total += item.price * item.quantity;
    }

    return total;
  }
}
