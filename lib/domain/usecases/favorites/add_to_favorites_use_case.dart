/// # 5. Product Cart screen
/// 5.3. Add product cart item to favorites use-case: 
/// User clicks on top right icon of the product cart item and 
/// clicks “Add to Favorites” in the popup. 
/// The product is added to favorites with the same color 
/// and size as the cart item.
/// https://medium.com/@openflutterproject/open-flutter-project-e-commerce-app-use-cases-and-features-6b7414a6e708

import 'package:hosco/data/model/favorite_product.dart';
import 'package:hosco/data/repositories/product_repository_impl.dart';
import 'package:hosco/domain/usecases/base_use_case.dart';

abstract class AddToFavoritesUseCase
  implements BaseUseCase<AddToFavoriteResult, FavoriteProduct> {}

    
class AddToFavoritesUseCaseImpl implements AddToFavoritesUseCase {
  @override
  Future<AddToFavoriteResult> execute(FavoriteProduct item) async {
    try {
      List<FavoriteProduct> favPro = ProductRepositoryImpl.dataStorage.favProducts;
      if(favPro.isNotEmpty) {
        for (int i = 0; i < favPro.length; i++) {
          if (favPro[i].product.id != item.product.id) {
            ProductRepositoryImpl.dataStorage.favProducts.add(
                FavoriteProduct(
                    item.product,
                    item.favoriteForm
                )
            );
          }
        }
      } else {
        ProductRepositoryImpl.dataStorage.favProducts.add(
            FavoriteProduct(
                item.product,
                item.favoriteForm
            )
        );
      }
      return AddToFavoriteResult(result: true);
    } catch (e) {
      return AddToFavoriteResult(  
        result: false,
        exception: AddProductToCartException()
      );
    }
  }

}

class AddProductToCartException implements Exception {}

class AddToFavoriteResult extends UseCaseResult {
  AddToFavoriteResult({Exception exception, bool result}) 
    : super(exception: exception, result: result);
}