import 'package:flutter_lv2_course/common/model/cursor_pagination_model.dart';
import 'package:flutter_lv2_course/common/provider/pagination_provider.dart';
import 'package:flutter_lv2_course/product/model/product_model.dart';
import 'package:flutter_lv2_course/product/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider =
    StateNotifierProvider<ProductStateNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(ProductRepositoryProvider);

  return ProductStateNotifier(repository: repo);
});

class ProductStateNotifier
    extends PaginationProvider<ProductModel, ProductRepository> {
  ProductStateNotifier({
    required super.repository,
  });
}
