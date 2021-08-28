import 'package:hosco/config/theme.dart';
import 'package:hosco/data/model/api_result.dart';
import 'package:hosco/data/model/filter_rules.dart';
import 'package:hosco/data/model/product.dart';
import 'package:hosco/data/model/sort_rules.dart';
import 'package:hosco/data/repositories/abstract/product_repository.dart';

class LocalProductRepository implements ProductRepository {
  @override
  Future<Product> getProduct(String id) {
    // TODO: implement getProduct
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getSimilarProducts(String categoryId,
      {int pageIndex = 0, int pageSize = AppConsts.page_size}) {
    // TODO: implement getSimilarProducts
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProducts(
      {int pageIndex = 0,
      int pageSize = AppConsts.page_size,
      String categoryId = '0',
      bool isFavorite = false,
        bool Visible = true,
        String searchPattern = '',
      SortRules sortRules = const SortRules(),
      FilterRules filterRules}) {
    // TODO: implement getProducts
    return null;
  }

  @override
  Future<ApiResult> getRawProducts(
      {int pageIndex = 0,
        int pageSize = AppConsts.page_size,
        String categoryId = '0',
        bool isFavorite = false,
        bool Visible = true,
        String searchPattern = '',
        SortRules sortRules = const SortRules(),
        FilterRules filterRules}) {
    // TODO: implement getProducts
    return null;
  }

  @override
  Future<FilterRules> getPossibleFilterOptions(String categoryId) {
    // TODO: implement getPossibleFilterOptions
    return null;
  }
}
