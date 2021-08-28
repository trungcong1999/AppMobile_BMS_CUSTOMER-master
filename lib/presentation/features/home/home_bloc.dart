// Home Screen Bloc
// Author: openflutterproject@gmail.com
// Date: 2020-02-06

import 'package:bloc/bloc.dart';
import 'package:hosco/data/model/favorite_product.dart';
import 'package:hosco/domain/usecases/cart/get_cart_products_use_case.dart';
import 'package:hosco/domain/usecases/favorites/add_to_favorites_use_case.dart';
import 'package:hosco/domain/usecases/favorites/remove_from_favorites_use_case.dart';
import 'package:hosco/domain/usecases/products/get_home_products_use_case.dart';
import 'package:hosco/locator.dart';

import 'home.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AddToFavoritesUseCase addToFavoritesUseCase;
  final RemoveFromFavoritesUseCase removeFromFavoritesUseCase;
  final GetHomePageProductsUseCase getHomePageProductsUseCase;
  final GetCartProductsUseCase getCartProductsUseCase;
  
  HomeBloc() : 
    addToFavoritesUseCase = sl(), 
    removeFromFavoritesUseCase = sl(),
    getHomePageProductsUseCase = sl(),
        getCartProductsUseCase = sl(),
        super(HomeInitialState());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeLoadEvent) {
      if (state is HomeInitialState) {

        final cartResults = await getCartProductsUseCase.execute(GetCartProductParams());
        HomeProductsResult results = await getHomePageProductsUseCase.execute(HomeProductParams());
        int total = 0;
        for(int i = 0; i < cartResults.cartItems.length; i++) {
          total += cartResults.cartItems[i].productQuantity.quantity;
        }

        yield HomeLoadedState(
          salesProducts: results.salesProducts,
          newProducts: results.newProducts,
          cartNum: total
        );
      } else if (state is HomeLoadedState) {
        yield state;
      }
    } else if (event is HomeAddToFavoriteEvent) {
      if (event.isFavorite) {
        await addToFavoritesUseCase.execute(
          FavoriteProduct(event.product, null)
        );
      } else {
        await removeFromFavoritesUseCase.execute(
          RemoveFromFavoritesParams(
            FavoriteProduct(event.product, null)
          )
        );
      }

      final cartResults = await getCartProductsUseCase.execute(GetCartProductParams());
      int total = 0;
      for(int i = 0; i < cartResults.cartItems.length; i++) {
        total += cartResults.cartItems[i].productQuantity.quantity;
      }

      HomeProductsResult results = await getHomePageProductsUseCase.execute(HomeProductParams());
      yield HomeLoadedState(
        salesProducts: results.salesProducts,
        newProducts: results.newProducts,
        cartNum: total
      );
    }
  }
}
