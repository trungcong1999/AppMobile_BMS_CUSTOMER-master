// Checkout Screen Bloc
// Author: openflutterproject@gmail.com
// Date: 2020-02-17

import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:hosco/data/model/shipping_address.dart';
import 'package:hosco/data/model/user_order.dart';
import 'package:hosco/data/repositories/abstract/order_repository.dart';
import 'package:hosco/domain/usecases/cart/get_cart_products_use_case.dart';
import 'package:hosco/domain/usecases/checkout/checkout_start_use_case.dart';
import 'package:hosco/locator.dart';

import 'checkout.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutStartUseCase checkoutStartUseCase;
  
  CheckoutBloc(): checkoutStartUseCase = sl(), super(CheckoutInitialState());
  @override
  Stream<CheckoutState> mapEventToState(CheckoutEvent event) async* {
    if (event is CheckoutStartEvent) {
      if (state is CheckoutInitialState) {
        CheckoutStartResult results = await checkoutStartUseCase.execute(CheckoutStartParams());
        yield CheckoutProceedState(
          cardId: 1, 
          cartProducts: results.cartItems,
          shippingAddresses: results.shippingAddress,
          paymentMethods: results.paymentMethods,
          currentPaymentMethod: results.currentPaymentMethod,
          currentShippingAddress: results.currentShippingAddress,
          orderPrice: results.totalCalculatedPrice,
          deliveryPrice: results.deliveryPrice,
          summaryPrice: results.summaryPrice
        );
      } else if (state is CheckoutProceedState) {
        yield state;
      }
    } else if (event is CheckoutSetDefaultCardEvent) {
      if (state is CheckoutProceedState) {
        yield (state as CheckoutProceedState).copyWith(cardId: event.cardId);
      }
    } else if (event is CheckoutShowAddNewCardEvent) {
      if (state is CheckoutProceedState) {
        yield (state as CheckoutProceedState)
            .copyWith(showAddNewCardForm: true);
      }
    } else if (event is CheckoutAddNewCardEvent) {
      if (state is CheckoutProceedState) {
        //TODO: add new card
        yield (state as CheckoutProceedState)
            .copyWith(showAddNewCardForm: false);
      }
    } else if (event is SendOrderCardEvent) {
      OrderRepository orderRepository = sl();
      GetCartProductsUseCase getCartProductsUseCase = sl();
      final cartResults = await getCartProductsUseCase.execute(GetCartProductParams());
      var order = UserOrder(id: Random().nextInt(100).toString(),
          products: cartResults.cartItems,
          promo: cartResults.appliedPromo,
          shippingAddress: ShippingAddressModel(id: 1, address: event.address, fullName: event.fullname),
          description: event.description
      );
      int ret = await orderRepository.placeNewOrder(order);
      bool isTrue = ret == 0 ? true : false;
      yield CheckoutProceededState(isSentOrder: isTrue);
    }
  }
}
