import 'package:hosco/config/theme.dart';
import 'package:hosco/data/model/api_result.dart';
import 'package:hosco/domain/usecases/orders/orders_by_filter_params.dart';

import '../../model/user_order.dart';

abstract class OrderRepository {
  ///returns orders which were made by this user or with this device
  ///(depending on concrete realization). It divides the result to chunks with
  ///pagination settings: [pageIndex] and [pageSize]
  Future<List<UserOrder>> getMyOrders(OrdersByFilterParams params);

  Future<ApiResult> getRawMyOrders(OrdersByFilterParams params);

  ///returns order details for order with [orderId]
  Future<UserOrder> getOrderDetails(String orderId);

  ///adds new order
  Future placeNewOrder(UserOrder order);

  /// it is used to update order status by backend (in case delivery status
  /// changed or any items are out of stock or something similar). [order.id]
  /// should remain the same as in the original order
  Future updateOrder(UserOrder order);
}
