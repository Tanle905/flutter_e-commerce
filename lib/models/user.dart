class User {
  final String userId;
  final String username;
  final String email;
  final String? password;
  final String? address;
  final String? phoneNumber;
  final String? paymemt;

  User(
      {required this.userId,
      required this.username,
      required this.email,
      this.password,
      this.address,
      this.phoneNumber,
      this.paymemt});

  User copyWith(
      {String? userId,
      String? username,
      String? email,
      String? password,
      String? address,
      String? phoneNumber,
      String? paymemt}) {
    return User(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password,
        address: address,
        paymemt: paymemt,
        phoneNumber: phoneNumber);
  }
}
