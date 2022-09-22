class CartItem {
  final String id;
  final String title;
  final String imageUrl;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.price,
      required this.quantity,
      required this.imageUrl,
      required this.title});
  CartItem copyWith(
      {String? id,
      String? title,
      int? quantity,
      double? price,
      String? imageUrl}) {
    return CartItem(
        id: id ?? this.id,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        title: title ?? this.title,
        imageUrl: imageUrl ?? this.imageUrl);
  }
}
