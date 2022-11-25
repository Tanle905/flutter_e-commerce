class ReviewDetails {
  String id;
  String userId;
  String productId;
  String username;
  List<String> imageUrl;
  String description;
  double stars;
  DateTime createdAt;
  DateTime updatedAt;

  ReviewDetails(
      {required this.id,
      required this.userId,
      required this.productId,
      required this.username,
      required this.description,
      required this.stars,
      this.imageUrl = const [],
      required this.createdAt,
      required this.updatedAt});

  factory ReviewDetails.fromJson(Map json) {
    return ReviewDetails(
        id: json['_id'],
        userId: json['userId'],
        productId: json['productId'],
        username: json['username'],
        imageUrl: List.castFrom<dynamic, String>(json['imageUrl']),
        description: json['description'],
        stars: double.parse(json['stars'].toString()),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']));
  }
}
