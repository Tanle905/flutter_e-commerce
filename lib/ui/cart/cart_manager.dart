import 'package:tmdt/models/cart_items.dart';

class CartManager {
  final Map<String, CartItem> _items = {
    'p1': CartItem(
      productId: '1',
      price: 69.96,
      quantity: 2,
      title: 'Red Shirt',
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    'p2': CartItem(
      productId: '1',
      price: 69.96,
      quantity: 2,
      title: 'Red Shirt',
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    )
  };

  int get productCount {
    return _items.length;
  }

  List<CartItem> get products {
    return _items.values.toList();
  }

  Iterable<MapEntry<String, CartItem>> get productEntries {
    return {..._items}.entries;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }
}
