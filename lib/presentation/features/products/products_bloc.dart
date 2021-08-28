// Product List Bloc
// Author: openflutterproject@gmail.com
// Date: 2020-02-06

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hosco/data/model/category.dart';
import 'package:hosco/data/model/favorite_product.dart';
import 'package:hosco/data/model/product.dart';
import 'package:hosco/data/model/sort_rules.dart';
import 'package:hosco/domain/usecases/favorites/add_to_favorites_use_case.dart';
import 'package:hosco/domain/usecases/favorites/get_favorite_products_use_case.dart';
import 'package:hosco/domain/usecases/favorites/remove_from_favorites_use_case.dart';
import 'package:hosco/domain/usecases/products/find_products_by_filter_use_case.dart';
import 'package:hosco/domain/usecases/products/products_by_filter_params.dart';
import 'package:hosco/domain/usecases/products/products_by_filter_result.dart';
import 'package:hosco/locator.dart';
import 'package:hosco/presentation/features/products/products.dart';
import 'bloc_list_data.dart';

class ProductsBloc extends Bloc<ProductsListEvent, ProductsState> {
  final FindProductsByFilterUseCase findProductsByFilterUseCase;

  final GetFavoriteProductsUseCase getFavoriteProductsUseCase;
  final RemoveFromFavoritesUseCase removeFromFavoritesUseCase;
  final AddToFavoritesUseCase addToFavoritesUseCase;
  
  final ProductCategory category;
  final int pageIndex;

  ProductsBloc({
    @required this.category,
    @required this.pageIndex
  }) : findProductsByFilterUseCase = sl(),
    getFavoriteProductsUseCase = sl(),
    removeFromFavoritesUseCase = sl(),
    addToFavoritesUseCase = sl(),super(ProductsListViewState());


  @override
  Stream<ProductsState> mapEventToState(ProductsListEvent event) async* {
    if (event is ScreenLoadedEvent) {
      ProductListData data = await getInitialStateData(category, pageIndex);
      yield ProductsListViewState(
          sortBy: SortRules(),
          data: data,
          filterRules: data.filterRules);
    } else if (event is ProductsChangeViewEvent) {
      if (state is ProductsListViewState) {
        yield (state as ProductsListViewState).getTiles();
      } else {
        yield (state as ProductsTileViewState).getList();
      }
    } else if (event is ProductChangeSortRulesEvent) {
      yield state.getLoading();
      ProductsByFilterResult productResults = await findProductsByFilterUseCase.execute(
        ProductsByFilterParams(
          categoryId: category.id,
          filterRules: state.filterRules,
          sortBy: event.sortBy
        ));
      final List<Product> filteredData = productResults.products;
      yield state.copyWith(
        sortBy: event.sortBy,
        data: state.data.copyWith(filteredData),
      );
    }  else if (event is ProductChangeHashTagEvent) {
      yield state.getLoading();
      state.filterRules.selectedHashTags[event.hashTag] = event.isSelected;
      ProductsByFilterResult productResults = await findProductsByFilterUseCase.execute(
        ProductsByFilterParams(
          categoryId: category.id,
          filterRules: state.filterRules,
          sortBy: state.sortBy
        ));
      final List<Product> filteredData = productResults.products;
      yield state.copyWith(
        data: state.data.copyWith(filteredData),
        sortBy: state.sortBy,
      );
    } else if (event is ProductChangeFilterRulesEvent) {
      yield state.getLoading();
      ProductsByFilterResult productResults = await findProductsByFilterUseCase.execute(
        ProductsByFilterParams(
          categoryId: category.id,
          filterRules: event.filterRules,
          sortBy: state.sortBy
        ));
      final List<Product> filteredData = productResults.products;
      yield state.copyWith(
          filterRules: event.filterRules,
          data: state.data.copyWith(filteredData));
    } else if (event is ProductMakeFavoriteEvent) {
      if (event.isFavorite) {
        await addToFavoritesUseCase.execute(FavoriteProduct(
          event.product,
          event.favoriteAttributes
          )
        );
      } else {
        await removeFromFavoritesUseCase.execute(
          RemoveFromFavoritesParams(FavoriteProduct(
            event.product,
            event.favoriteAttributes
            )
          )
        );
      }
      final List<Product> data = state.data.products;
      yield state.copyWith(
          data: state.data.copyWith(data.map((item) {
        if (event.product.id == item.id) {
          return item.favorite(event.isFavorite);
        } else {
          return item;
        }
      }).toList(growable: false)));
    } else if(event is ProductInfinityLoadEvent) {
      ProductListData data = await getInfinityStateData(category);
      yield ProductsListViewState(
          sortBy: SortRules(),
          data: data,
          filterRules: data.filterRules);
    }
  }

  Future<ProductListData> getInitialStateData(ProductCategory category, [int pageIndex = 0]) async {
    ProductsByFilterResult productResults = await findProductsByFilterUseCase.execute(
      ProductsByFilterParams(
        categoryId: category.id,
        PageIndex: pageIndex
      )
    );
    return ProductListData(
        productResults.products,
        category,
        productResults.filterRules);
  }

  Future<ProductListData> getInfinityStateData(ProductCategory category) async {
    ProductsByFilterResult productResults = await findProductsByFilterUseCase.execute(
        ProductsByFilterParams(
            categoryId: category.id
        )
    );
    return ProductListData(
        productResults.products,
        category,
        productResults.filterRules);
  }
}
