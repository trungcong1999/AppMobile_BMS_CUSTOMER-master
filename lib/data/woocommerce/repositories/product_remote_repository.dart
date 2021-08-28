import 'package:flutter/material.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/data/model/api_result.dart';
import 'package:hosco/data/model/filter_rules.dart';
import 'package:hosco/data/model/product.dart';
import 'package:hosco/data/model/sort_rules.dart';
import 'package:hosco/data/repositories/abstract/product_repository.dart';
import 'package:hosco/data/error/exceptions.dart';
import 'package:hosco/data/woocommerce/models/my_product_model.dart';
import 'package:hosco/data/woocommerce/models/product_model.dart';
import 'package:hosco/data/woocommerce/repositories/woocommerce_wrapper.dart';
import 'package:hosco/domain/usecases/products/products_by_filter_params.dart';

class RemoteProductRepository extends ProductRepository {
  
  final WoocommercWrapperAbstract woocommerce;

  RemoteProductRepository({@required this.woocommerce});

  @override
  Future<Product> getProduct(String productId) async {
    try
    {
      var productsData = await woocommerce.getProduct(productId: productId);
      return Product.fromEntity(MyProductModel.fromJson(productsData));
    } on HttpRequestException {
      throw RemoteServerException();
    }
  }

  @override
  Future<List<Product>> getSimilarProducts(String categoryId,
      {int pageIndex = 0, int pageSize = AppConsts.page_size}) {
    // TODO: implement getSimilarProducts
    throw UnimplementedError();
  }

  @override
  Future<FilterRules> getPossibleFilterOptions(String categoryId) {
    // TODO: implement getPossibleFilterOptions
    return null;
  }

  @override
  Future<List<Product>> getProducts(
      {int pageIndex = 0,
      int pageSize = AppConsts.page_size,
      String categoryId = '0',
      bool isFavorite = false,
        bool Visible = true,
        String searchPattern = '',
      SortRules sortRules = const SortRules(),
      FilterRules filterRules}) async {
    try
    {
      var productsData = await woocommerce.getProductList(
        ProductsByFilterParams(
          categoryId: categoryId,
          sortBy: sortRules, 
          filterRules: filterRules,
          PageIndex: pageIndex,
          PageSize: pageSize,
          Visible: Visible,
          Instock: -1,
          ProductName: searchPattern,
        )
      );

      List<Product> products = [];
      for(int i = 0; i < productsData.data.length; i++){
        products.add(
            Product.fromEntity(MyProductModel.fromJson(productsData.data[i]))
        );
      }

      return products;
    } on HttpRequestException {
      throw RemoteServerException();
    }
  }

  @override
  Future<ApiResult> getRawProducts(
      {int pageIndex = 0,
        int pageSize = AppConsts.page_size,
        String categoryId = '',
        bool isFavorite = false,
        bool Visible = true,
        String searchPattern = '',
        SortRules sortRules = const SortRules(),
        FilterRules filterRules}) async {
    try
    {
      var productsData = await woocommerce.getProductList(
          ProductsByFilterParams(
            categoryId: categoryId,
            ProductGroup: categoryId,
            sortBy: sortRules,
            filterRules: filterRules,
            PageIndex: pageIndex,
            PageSize: pageSize,
            Visible: Visible,
            Instock: -1,
            ProductName: searchPattern ??= '',
          )
      );

      List<Product> products = [];
      for(int i = 0; i < productsData.data.length; i++){
        products.add(
            Product.fromEntity(MyProductModel.fromJson(productsData.data[i]))
        );
      }

      return ApiResult(data: products, meta: productsData.meta, paging: productsData.paging);
    } on HttpRequestException {
      throw RemoteServerException();
    }
  }
}
