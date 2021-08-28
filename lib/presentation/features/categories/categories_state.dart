// Category list Bloc States
// Author: openflutterproject@gmail.com
// Date: 2020-02-06

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hosco/data/model/category.dart';

@immutable
abstract class CategoryState extends Equatable {
  final String parentCategoryId;
  final int cartTotal;

  CategoryState({this.parentCategoryId = '0', this.cartTotal = 0});

  @override
  List<Object> get props => [parentCategoryId];
}

@immutable
class CategoryLoadingState extends CategoryState {
  @override
  String toString() => 'CategoryInitialState';
}

@immutable
abstract class CategoryViewState extends CategoryState {
  final List<ProductCategory> categories;

  CategoryViewState({String parentCategoryId, this.categories, int cartTotal})
      : super(parentCategoryId: parentCategoryId, cartTotal: cartTotal);

  @override
  List<Object> get props => [categories, parentCategoryId, cartTotal];
}

@immutable
class CategoryListViewState extends CategoryViewState {
  CategoryListViewState({String parentCategoryId, List<ProductCategory> categories, int cartTotal})
      : super(parentCategoryId: parentCategoryId, categories: categories, cartTotal: cartTotal);

  @override
  String toString() => 'CategoryListViewState';
}

@immutable
class CategoryTileViewState extends CategoryViewState {
  CategoryTileViewState({
    String parentCategoryId,
    List<ProductCategory> categories,
    int cartTotal
  }) : super(
          parentCategoryId: parentCategoryId,
          categories: categories,
          cartTotal: cartTotal
        );

  @override
  String toString() => 'CategoryTileViewState';
}

@immutable
class CategoryErrorState extends CategoryState {
  @override
  String toString() => 'CategoryErrorState';
}
