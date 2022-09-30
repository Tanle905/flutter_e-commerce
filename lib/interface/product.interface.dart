import 'dart:ffi';

abstract class IsProductResponse {
  late Int count;
  late Int page;
  late Int pageSize;
  late List data;
}
