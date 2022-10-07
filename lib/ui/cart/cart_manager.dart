import 'package:tmdt/models/cart.dart';

class CartManager {
  final CartList _items;
  CartManager(this._items);

  int get productCount {
    int totalQuantity = 0;
    for (var item in _items.getCartList) {
      totalQuantity += item.quantity;
    }
    return totalQuantity;
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
