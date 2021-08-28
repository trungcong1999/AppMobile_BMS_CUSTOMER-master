import 'package:flutter/material.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/data/model/api_result.dart';
import 'package:hosco/data/model/user_order.dart';
import 'package:hosco/data/repositories/abstract/order_repository.dart';
import 'package:hosco/data/woocommerce/models/order_model.dart';
import 'package:hosco/data/woocommerce/repositories/woocommerce_wrapper.dart';
import 'package:hosco/domain/usecases/orders/orders_by_filter_params.dart';

class RemoteOrderRepository extends OrderRepository {
  final WoocommercWrapperAbstract woocommerce;

  RemoteOrderRepository({@required this.woocommerce});

  @override
  Future<UserOrder> getOrderDetails(String id) async {
    var orderDetail =  await woocommerce.getOrderDetails(id);
    orderDetail['TotalMoney'] = orderDetail['OrderTotal'];
    return UserOrder.fromEntity(OrderModel.fromJson(orderDetail));
  }

  @override
  Future<List<UserOrder>> getMyOrders(OrdersByFilterParams params) async {
    var orderList =  await woocommerce.getMyOrders(params);
    List<UserOrder> userOrders = [];
    if(orderList.data != null) {
      for (int i = 0; i < orderList.data.length; i++) {
        userOrders.add(
            UserOrder.fromEntity(OrderModel.fromJson(orderList.data[i]))
        );
      }
    }

    return userOrders;
  }

  @override
  Future<ApiResult> getRawMyOrders(OrdersByFilterParams params) async {
    var orderList =  await woocommerce.getMyOrders(params);
    List<UserOrder> userOrders = [];
    if(orderList.data != null) {
      for (int i = 0; i < orderList.data.length; i++) {
        userOrders.add(
            UserOrder.fromEntity(OrderModel.fromJson(orderList.data[i]))
        );
      }
    }
    return ApiResult(data: userOrders, meta: orderList.meta, paging: orderList.paging);
  }

  @override
  Future<dynamic> placeNewOrder(UserOrder order) async {
    int ret = await woocommerce.saveOrder(order);
    return ret;
  }

  @override
  Future updateOrder(UserOrder order) {
    // TODO: implement updateOrder
    throw UnimplementedError();
  }
  
}
