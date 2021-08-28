// Category list Bloc
// Author: openflutterproject@gmail.com
// Date: 2020-02-06
import 'package:bloc/bloc.dart';
import 'package:hosco/data/model/category.dart';
import 'package:hosco/domain/usecases/cart/get_cart_products_use_case.dart';
import 'package:hosco/domain/usecases/categories/categories_by_filter_params.dart';
import 'package:hosco/domain/usecases/categories/find_categories_by_filter_use_case.dart';
import 'package:hosco/locator.dart';

import 'categories.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final FindCategoriesByFilterUseCase findCategoriesByFilterUseCase;
  final GetCartProductsUseCase getCartProductsUseCase;

  CategoryBloc(): findCategoriesByFilterUseCase = sl(),
        getCartProductsUseCase = sl(),
        super(CategoryLoadingState());

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    final cartResults = await getCartProductsUseCase.execute(GetCartProductParams());
    int total = 0;
    for(int i = 0; i < cartResults.cartItems.length; i++) {
      total += cartResults.cartItems[i].productQuantity.quantity;
    }

    if (event is CategoryShowListEvent) {
      if (state is CategoryListViewState) {
        if (state.parentCategoryId != event.parentCategoryId) {
          yield CategoryLoadingState();
          List<ProductCategory> categories = await _getCategoriesByFilter(event.parentCategoryId);
          yield CategoryListViewState(
              categories: categories, parentCategoryId: event.parentCategoryId, cartTotal: total);
        }
      } else {
        yield CategoryLoadingState();
        List<ProductCategory> categories = await _getCategoriesByFilter(event.parentCategoryId);
        yield CategoryListViewState(
            parentCategoryId: event.parentCategoryId, categories: categories, cartTotal: total);
      }
    } else if (event is CategoryShowTilesEvent) {
      if (state is CategoryTileViewState) {
        if (state.parentCategoryId != event.parentCategoryId) {
          yield CategoryLoadingState();
          List<ProductCategory> categories = await _getCategoriesByFilter(event.parentCategoryId);
          yield CategoryTileViewState(
              categories: categories, parentCategoryId: event.parentCategoryId, cartTotal: total);
        }
      } else {
        yield CategoryLoadingState();
        List<ProductCategory> categories = await _getCategoriesByFilter(event.parentCategoryId);
        yield CategoryTileViewState(
          parentCategoryId: event.parentCategoryId, categories: categories, cartTotal: total);
      }
    } else if (event is ChangeCategoryParent) {
      yield CategoryLoadingState();
      List<ProductCategory> categories = await _getCategoriesByFilter(event.parentCategoryId);
      if (state is CategoryTileViewState) {
        yield CategoryTileViewState(
            parentCategoryId: event.parentCategoryId, categories: categories, cartTotal: total);
      } else {
        yield CategoryListViewState(
            parentCategoryId: event.parentCategoryId, categories: categories, cartTotal: total);
      }
    }
  }
  Future<List<ProductCategory>> _getCategoriesByFilter(String categoryId) async{
    final categoriesData = await findCategoriesByFilterUseCase.execute(
      CategoriesByFilterParams(
        categoryId: categoryId
      )
    );
    return categoriesData.categories;
  }
}
