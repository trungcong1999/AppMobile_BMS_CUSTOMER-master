// Category list Bloc Events
// Author: openflutterproject@gmail.com
// Date: 2020-02-06
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CategoryEvent extends Equatable {
  final String parentCategoryId;
  CategoryEvent(this.parentCategoryId) : super();

  @override
  List<Object> get props => [parentCategoryId];
}

@immutable
class CategoryShowListEvent extends CategoryEvent {
  CategoryShowListEvent(String parentCategoryId) : super(parentCategoryId);
}

@immutable
class CategoryShowTilesEvent extends CategoryEvent {
  CategoryShowTilesEvent(String parentCategoryId) : super(parentCategoryId);
}

class ChangeCategoryParent extends CategoryEvent {
  ChangeCategoryParent(String parentCategoryId) : super(parentCategoryId);
}
