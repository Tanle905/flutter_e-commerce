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
  final String? accessToken;
  final bool? isDeactivated;

  final int? phoneNumber;
  final String? payment;

  User(
      {required this.userId,
      required this.username,
      required this.email,
      this.roles,
      this.password,
      this.address,
      this.imageUrl,
      this.phoneNumber,
      this.payment,
      this.accessToken,
      this.isDeactivated});

  User copyWith(
      {String? userId,
      String? username,
      String? email,
      List<String>? roles,
      String? address,
      String? imageUrl,
      int? phoneNumber,
      String? payment,
      String? accessToken,
      bool? isDeactivated}) {
    return User(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        email: email ?? this.email,
        roles: roles ?? [ROLE_USER],
        imageUrl: imageUrl ?? this.imageUrl,
        address: address ?? this.address,
        payment: payment ?? this.payment,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        accessToken: accessToken ?? this.accessToken,
        isDeactivated: isDeactivated ?? false);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json['userId'] ?? json['_id'] ?? json['id'],
        username: json['username'],
        email: json['email'],
        roles: json['roles'] != null
            ? List.castFrom<dynamic, String>(json['roles'])
            : null,
        address: json['address'],
        imageUrl: json['imageUrl'],
        payment: json['payment'],
        phoneNumber: json['phoneNumber'],
        accessToken: json['accessToken'],
        isDeactivated: json['isDeactivated'] ?? false);
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'email': email,
        'roles': roles,
        'address': address,
        'imageUrl': imageUrl,
        'phoneNumber': phoneNumber,
        'payment': payment,
        'accessToken': accessToken,
        'isDeactivated': isDeactivated
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
