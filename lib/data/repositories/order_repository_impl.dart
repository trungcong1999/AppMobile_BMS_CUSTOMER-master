import 'package:flutter/cupertino.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/data/local/local_order_repository.dart';
import 'package:hosco/data/model/api_result.dart';
import 'package:hosco/data/model/user_order.dart';
import 'package:hosco/data/repositories/abstract/order_repository.dart';
import 'package:hosco/data/error/exceptions.dart';
import 'package:hosco/data/network/network_status.dart';
import 'package:hosco/data/woocommerce/repositories/order_remote_repository.dart';
import 'package:hosco/domain/usecases/orders/orders_by_filter_params.dart';
import 'package:hosco/locator.dart';

//Uses remote or local data depending on NetworkStatus
class OrderRepositoryImpl extends OrderRepository {

  @override
  Future<UserOrder> getOrderDetails(String id) {
    RemoteOrderRepository remoteOrderRepository = RemoteOrderRepository(woocommerce: sl());
    return remoteOrderRepository.getOrderDetails(id);
  }

  @override
  Future<List<UserOrder>> getMyOrders(OrdersByFilterParams params) {
    RemoteOrderRepository remoteOrderRepository = RemoteOrderRepository(woocommerce: sl());
    return remoteOrderRepository.getMyOrders(params);
  }

  @override
  Future<ApiResult> getRawMyOrders(OrdersByFilterParams params) {
    RemoteOrderRepository remoteOrderRepository = RemoteOrderRepository(woocommerce: sl());
    return remoteOrderRepository.getRawMyOrders(params);
  }

  @override
  Future placeNewOrder(UserOrder order) async {
    RemoteOrderRepository remoteOrderRepository = RemoteOrderRepository(woocommerce: sl());
    return remoteOrderRepository.placeNewOrder(order);
  }

  @override
  Future updateOrder(UserOrder order) async {
    //dataStorage.favProducts.add(FavoriteProduct(product, selectedAttributes));
  }
}