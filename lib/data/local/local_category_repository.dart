import 'package:hosco/data/repositories/abstract/category_repository.dart';
import 'package:hosco/data/model/category.dart';

class LocalCategoryRepository extends CategoryRepository{
  @override
  Future<List<ProductCategory>> getCategories({String parentCategoryId = '0'}) async {
    // TODO: implement getCategories
    return null;
  }

  @override
  Future<ProductCategory> getCategoryDetails(String categoryId) {
    // TODO: implement getCategoryDetails
    return null;
  }

}