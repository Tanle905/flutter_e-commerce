import 'package:flutter/material.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/address.dart';
import 'package:tmdt/models/order_item.dart';

class User {
  final String userId;
  final String username;
  final String email;
  final List<String> roles;
  final String? password;
  final List<Address> address;
  final String? imageUrl;
  final String? accessToken;
  final bool? isDeactivated;
  final List<OrderItem> order;

  final int? phoneNumber;
  final String? payment;

  User(
      {required this.userId,
      required this.username,
      required this.email,
      required this.order,
      required this.address,
      required this.roles,
      this.password,
      this.imageUrl,
      this.phoneNumber,
      this.payment,
      this.accessToken,
      this.isDeactivated});

  User copyWith(
      {String? userId,
      String? username,
      String? email,
      List<OrderItem>? order,
      List<String>? roles,
      List<Address>? address,
      String? imageUrl,
      int? phoneNumber,
      String? payment,
      String? accessToken,
      bool? isDeactivated}) {
    return User(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        email: email ?? this.email,
        order: order ?? this.order,
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
        order: json['order'] != null
            ? List.castFrom<dynamic, OrderItem>(json['order']
                .map((order) => OrderItem.fromJson(order))
                .toList())
            : List.empty(),
        roles: json['roles'] != null
            ? List.castFrom<dynamic, String>(json['roles'])
            : List.empty(),
        address: json['address'] != null
            ? List.castFrom<dynamic, Address>(json['address'])
            : List.empty(),
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
        'order': order,
        'imageUrl': imageUrl,
        'phoneNumber': phoneNumber,
        'payment': payment,
        'accessToken': accessToken,
        'isDeactivated': isDeactivated
      };
}
