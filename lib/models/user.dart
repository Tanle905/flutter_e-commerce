import 'package:flutter/material.dart';
import 'package:tmdt/constants/constants.dart';

class User {
  final String userId;
  final String username;
  final String email;
  final List<String>? roles;
  final String? password;
  final String? address;
  final String? imageUrl;

  final String? phoneNumber;
  final String? paymemt;

  User(
      {required this.userId,
      required this.username,
      required this.email,
      this.roles,
      this.password,
      this.address,
      this.imageUrl,
      this.phoneNumber,
      this.paymemt});

  User copyWith(
      {String? userId,
      String? username,
      String? email,
      List<String>? roles,
      String? address,
      String? imageUrl,
      String? phoneNumber,
      String? paymemt}) {
    return User(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        email: email ?? this.email,
        roles: roles ?? [ROLE_USER],
        imageUrl: imageUrl ?? this.imageUrl,
        address: address,
        paymemt: paymemt,
        phoneNumber: phoneNumber);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json['userId'],
        username: json['username'],
        email: json['email'] ?? '',
        roles: List.castFrom<dynamic, String>(json['roles']),
        address: json['address'],
        imageUrl: json['imageUrl'],
        paymemt: json['payment'],
        phoneNumber: json['phoneNumber']);
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'email': email,
        'roles': roles,
        'address': address,
        'imageUrl': imageUrl,
        'phoneNumber': phoneNumber,
        'paymemt': paymemt
      };
}

class UserModel extends ChangeNotifier {
  User? _user;

  User? get getUser {
    return _user;
  }

  set setUser(User? value) {
    _user = value;
    notifyListeners();
  }
}
