import 'dart:collection';

import 'package:hosco/config/theme.dart';
import 'package:hosco/data/model/api_result.dart';
import 'package:hosco/data/repositories/abstract/favorites_repository.dart';
import 'package:hosco/data/model/favorite_product.dart';
import 'package:hosco/data/model/filter_rules.dart';
import 'package:hosco/data/model/hashtag.dart';
import 'package:hosco/data/model/product.dart';
import 'package:hosco/data/model/product_attribute.dart';
import 'package:hosco/data/model/sort_rules.dart';
import 'package:hosco/data/repositories/abstract/product_repository.dart';
import 'package:hosco/data/error/exceptions.dart';
import 'package:hosco/data/local/local_product_repository.dart';
import 'package:hosco/data/network/network_status.dart';
import 'package:hosco/data/woocommerce/repositories/product_remote_repository.dart';
import 'package:hosco/locator.dart';

//Uses remote or local data depending on NetworkStatus
class ProductRepositoryImpl extends ProductRepository with FavoritesRepository {

  static ProductDataStorage dataStorage = ProductDataStorage();
  
  @override
  Future<Product> getProduct(String id) async {
    try
    {
      NetworkStatus networkStatus = sl();
      ProductRepository productRepository;
      if ( networkStatus.isConnected != null ) {
        productRepository = RemoteProductRepository(woocommerce: sl());
      } else {
        productRepository = LocalProductRepository();
      }

      Product product = await productRepository.getProduct(id);
      return product;
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
  Future<FilterRules> getPossibleFilterOptions(String categoryId) async {
    HashMap<ProductAttribute, List<String>> result = HashMap();
    //TODO: init categories from list of products fetched from server
    return FilterRules(
        categories: HashMap(),
        hashTags: [],
        selectedHashTags: HashMap<HashTag, bool>(),
        selectableAttributes: result,
        selectedPriceRange: PriceRange(10, 100));
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
    // TODO: implement getProducts
    try
    {
      NetworkStatus networkStatus = sl();
      ProductRepository productRepository;
      if ( networkStatus.isConnected != null ) {
        productRepository = RemoteProductRepository(woocommerce: sl());
      } else {
        productRepository = LocalProductRepository();
      }

      var products = await productRepository.getProducts(pageSize: pageSize,
          pageIndex: pageIndex, Visible: Visible, filterRules: filterRules,
          categoryId: categoryId, sortRules: sortRules, searchPattern: searchPattern
      );

      //check favorites
      dataStorage.products = [];
      products.forEach( (product) =>{
        dataStorage.products.add(
          product.favorite(
            checkFavorite(product.id)
          )
        )
      }); 

      return dataStorage.products;
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
    // TODO: implement getProducts
    try
    {
      NetworkStatus networkStatus = sl();
      ProductRepository productRepository;
      if ( networkStatus.isConnected != null ) {
        productRepository = RemoteProductRepository(woocommerce: sl());
      } else {
        productRepository = LocalProductRepository();
      }

      var products = await productRepository.getRawProducts(pageSize: pageSize,
          pageIndex: pageIndex, Visible: Visible, filterRules: filterRules,
          categoryId: categoryId, sortRules: sortRules, searchPattern: searchPattern
      );

      //check favorites
      dataStorage.products = [];
      products.data.forEach( (product) =>{
        dataStorage.products.add(
            product.favorite(
                checkFavorite(product.id)
            )
        )
      });

      return ApiResult(data: dataStorage.products, meta: products.meta, paging: products.paging);
    } on HttpRequestException {
      throw RemoteServerException();
    }
  }

  @override
  Future addToFavorites(Product product, HashMap<ProductAttribute, String> selectedAttributes) async {
    dataStorage.favProducts.add(FavoriteProduct(product, selectedAttributes));
  }

  @override
  Future<List<FavoriteProduct>> getFavoriteProducts({int pageIndex = 0, int pageSize = AppConsts.page_size, 
      SortRules sortRules = const SortRules(), FilterRules filterRules}) async {
    //TODO: remove when favorite feature will be implemented
    /*_dataStorage.products = await getProducts();
    _dataStorage.products.forEach((product) => 
      _dataStorage.favProducts.add(FavoriteProduct(product, HashMap())));*/
    return dataStorage.favProducts;
  }

  @override
  Future<FilterRules> getFavoritesFilterOptions() async {
    //TODO: remove when favorite feature will be implemented
    return FilterRules.getSelectableAttributes(dataStorage.products);
  }

  @override
  Future<List<FavoriteProduct>> removeFromFavorites(String productId, HashMap<ProductAttribute, String> selectedAttributes) async {
    //TODO: remove from database in the future
    dataStorage.favProducts.removeWhere((product) => product.product.id == productId && 
      (selectedAttributes == null || product.favoriteForm == selectedAttributes)
    );
    return dataStorage.favProducts;
  }

  @override
  bool checkFavorite(String productId) {
    // TODO: implement checkFavorite
    bool isFavorite = false;
    for( int i = 0; i < dataStorage.favProducts.length; i++) {
      if ( dataStorage.favProducts[i].product.id == productId) {
        isFavorite = true;
        break;
      }
    }
    return isFavorite;
  }
}

class ProductDataStorage {
  List<Product> products = [];
  List<FavoriteProduct> favProducts = [];
}