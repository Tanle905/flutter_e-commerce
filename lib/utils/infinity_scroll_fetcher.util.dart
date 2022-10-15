import 'package:tmdt/services/products.dart';
import 'package:tmdt/services/user.dart';
import 'package:tmdt/utils/responseMapping.util.dart';

Future<void> fetchProductPage(
    {required int page,
    required int pageSize,
    required pagingController,
    String? sortBy,
    bool? isAsc}) async {
  try {
    String initalQuery = '';
    if (sortBy != null && isAsc != null) {
      initalQuery = 'sortBy=$sortBy&isAsc=$isAsc';
    }
    final productResponse = await fetchProducts(
        page: page, pageSize: pageSize, initalQuery: initalQuery);
    final newItems = productResponseMapping(productResponse);
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(newItems);
    } else {
      final nextPageKey = page + 1;
      pagingController.appendPage(newItems, nextPageKey);
    }
  } catch (error) {
    pagingController.error = error;
  }
}

Future<void> fetchUserPage(
    {required int page,
    required int pageSize,
    required pagingController}) async {
  final userResponse = await fetchUsersList(page: page, pageSize: pageSize);
  final newItems = userResponseMapping(userResponse);
  final isLastPage = newItems.length < pageSize;
  if (isLastPage) {
    pagingController.appendLastPage(newItems);
  } else {
    final nextPageKey = page + 1;
    pagingController.appendPage(newItems, nextPageKey);
  }
}
