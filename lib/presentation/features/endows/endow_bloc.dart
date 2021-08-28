import 'package:bloc/bloc.dart';
import 'package:hosco/domain/usecases/cart/get_cart_products_use_case.dart';
import 'package:hosco/domain/usecases/favorites/add_to_favorites_use_case.dart';
import 'package:hosco/domain/usecases/favorites/remove_from_favorites_use_case.dart';
import 'package:hosco/domain/usecases/products/get_home_products_use_case.dart';
import 'package:hosco/locator.dart';

import 'endow.dart';
class EndowBloc extends Bloc<EndowEvent, EndowState> {
  final AddToFavoritesUseCase addToFavoritesUseCase;
  final RemoveFromFavoritesUseCase removeFromFavoritesUseCase;
  final GetHomePageProductsUseCase getHomePageProductsUseCase;
  final GetCartProductsUseCase getCartProductsUseCase;
  
  EndowBloc() : 
    addToFavoritesUseCase = sl(), 
    removeFromFavoritesUseCase = sl(),
    getHomePageProductsUseCase = sl(),
        getCartProductsUseCase = sl(),
        super(EndowInitialState());
        @override
  Stream<EndowState> mapEventToState(EndowEvent event) async* {
    if (event is EndowLoadEvent) {
      
    } 
  }
}