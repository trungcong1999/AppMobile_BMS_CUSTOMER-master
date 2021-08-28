import 'package:flutter/material.dart';
import 'package:hosco/data/repositories/abstract/category_repository.dart';
import 'package:hosco/data/model/category.dart';
import 'package:hosco/data/error/exceptions.dart';
import 'package:hosco/data/woocommerce/models/product_category_model.dart';
import 'package:hosco/data/woocommerce/repositories/woocommerce_wrapper.dart';

class RemoteCategoryRepository extends CategoryRepository {
  final WoocommercWrapperAbstract woocommerce;

  RemoteCategoryRepository({@required this.woocommerce});

  @override
  Future<List<ProductCategory>> getCategories({String parentCategoryId = '0'}) async {
    try {
      List<dynamic> categoriesData = await woocommerce.getCategoryList(parentId: parentCategoryId);
      List<ProductCategory> categories = [];
      for (int i = 0; i < categoriesData.length; i++) {
        categories.add(ProductCategory.fromEntity(
            ProductCategoryModel.fromJson(categoriesData[i])));
      }
      return categories;
    } on HttpRequestException {
      throw RemoteServerException();
    }
  }

  @override
  Future<ProductCategory> getCategoryDetails(String categoryId) {
    // TODO: implement getCategoryDetails
    return null;
  }
}
