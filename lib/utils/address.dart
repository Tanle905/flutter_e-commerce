import 'package:tmdt/models/address.dart';

String getFullAddress(Address address) {
  return '${address.address}, ${address.city}, ${address.country}';
}
