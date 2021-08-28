import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hosco/data/repositories/abstract/order_repository.dart';
import 'package:hosco/data/woocommerce/repositories/remote_user_repository.dart';
import 'package:hosco/domain/usecases/orders/orders_by_filter_params.dart';
import 'package:hosco/locator.dart';

import 'profile.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  @override
  ProfileBloc() : super(ProfileInitialState());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileMyOrdersEvent) {
      yield ProfileMyOrdersProcessingState();
      OrderRepository orderRepository = sl();
      var orders = await orderRepository.getMyOrders(OrdersByFilterParams(

      ));
      yield ProfileMyOrdersState(orderData: orders);
    } else if (event is ProfileMyOrderDetailsEvent) {
      yield ProfileMyOrdersProcessingState();
      OrderRepository orderRepository = sl();
      var order = await orderRepository.getOrderDetails(event.orderId);
      print(order);
      yield ProfileMyOrderDetailsState(orderData: order);
    } else if (event is ProfileStartEvent) {
      var repo = RemoteUserRepository();
      var user = repo.getUser();
      print(user.toString());
    }
  }
}
