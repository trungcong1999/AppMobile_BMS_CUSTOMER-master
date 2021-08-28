
import 'package:hosco/data/repositories/abstract/category_repository.dart';
import 'package:hosco/data/model/category.dart';
import 'package:hosco/data/error/exceptions.dart';
import 'package:hosco/data/local/local_category_repository.dart';
import 'package:hosco/data/network/network_status.dart';
import 'package:hosco/data/woocommerce/repositories/category_remote_repository.dart';
import 'package:hosco/locator.dart';

//Uses remote or local data depending on NetworkStatus
class CategoryRepositoryImpl extends CategoryRepository {

  @override
  Future<List<ProductCategory>> getCategories({String parentCategoryId = '0'}) async {
    try
    {
      NetworkStatus networkStatus = sl();
      CategoryRepository categoryRepository;
      if ( networkStatus.isConnected != null ) {
        categoryRepository = RemoteCategoryRepository(woocommerce: sl());
      } else {
        categoryRepository = LocalCategoryRepository();
      }

      return await categoryRepository.getCategories(parentCategoryId: parentCategoryId);
    } on HttpRequestException {
      return null;
      //throw RemoteServerException();
    }
  }

  @override
  Future<ProductCategory> getCategoryDetails(String categoryId) async {
    // TODO: implement getCategoryDetails
    List<ProductCategory> categories = await getCategories();
    return categories.isNotEmpty ? categories[0] : null;
  }
}
