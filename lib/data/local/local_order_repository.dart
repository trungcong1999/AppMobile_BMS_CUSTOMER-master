import 'package:hosco/config/theme.dart';
import 'package:hosco/data/model/api_result.dart';
import 'package:hosco/data/model/user_order.dart';
import 'package:hosco/data/repositories/abstract/order_repository.dart';
import 'package:hosco/domain/usecases/orders/orders_by_filter_params.dart';

class LocalOrderRepository implements OrderRepository {
  @override
  Future<UserOrder> getOrderDetails(String id) {
    // TODO: implement getProduct
    throw UnimplementedError();
  }

  @override
  Future<List<UserOrder>> getMyOrders(OrdersByFilterParams params) {
    // TODO: implement getSimilarProducts
    throw UnimplementedError();
  }

  @override
  Future<ApiResult> getRawMyOrders(OrdersByFilterParams params) {
    // TODO: implement getSimilarProducts
    throw UnimplementedError();
  }

  @override
  Future placeNewOrder(UserOrder order) {
    // TODO: implement placeNewOrder
    throw UnimplementedError();
  }

  @override
  Future updateOrder(UserOrder order) {
    // TODO: implement updateOrder
    throw UnimplementedError();
  }
}
