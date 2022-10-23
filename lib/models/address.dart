class Address {
  final String addressId;
  final String address;
  final String city;
  final String country;
  final String fullName;
  final int phoneNumber;

  Address(
      {required this.address,
      required this.addressId,
      required this.city,
      required this.country,
      required this.fullName,
      required this.phoneNumber});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        addressId: json['_id'],
        country: json['country'],
        city: json['city'],
        fullName: json['fullName'] ?? '',
        address: json['address'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '');
  }

  Map<String, dynamic> toJson() => {
        'addressId': addressId,
        'country': country,
        'city': city,
        'fullName': fullName,
        'address': address,
        'phoneNumber': phoneNumber,
      };
}
