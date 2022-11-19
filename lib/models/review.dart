class ReviewDetails {
  String userId;
  String productId;
  List<String> imageUrl;
  String description;
  double stars;
  DateTime createdAt;
  DateTime updatedAt;

  ReviewDetails(
      {required this.userId,
      required this.productId,
      required this.description,
      required this.stars,
      this.imageUrl = const [],
      required this.createdAt,
      required this.updatedAt});
}
