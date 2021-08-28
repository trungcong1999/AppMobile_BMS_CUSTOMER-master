// Checkout Screen Bloc States
// Author: openflutterproject@gmail.com
// Date: 2020-02-17

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hosco/data/model/cart_item.dart';
import 'package:hosco/data/model/payment_method.dart';
import 'package:hosco/data/model/product.dart';
import 'package:hosco/data/model/shipping_address.dart';

@immutable
abstract class CheckoutState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class CheckoutInitialState extends CheckoutState {
  @override
  String toString() => 'CheckoutInitialState';
}

@immutable
class CheckoutProceedState extends CheckoutState {
  final List<CartItem> cartProducts;
  final List<ShippingAddressModel> shippingAddresses;
  final List<PaymentMethodModel> paymentMethods;
  final ShippingAddressModel currentShippingAddress;
  final PaymentMethodModel currentPaymentMethod;
  final double orderPrice;
  final double deliveryPrice;
  final double summaryPrice;
  final int cardId;
  final bool showAddNewCardForm;
  final bool isSentOrder;

  CheckoutProceedState(
      {@required this.cardId,
      this.shippingAddresses,
      this.paymentMethods,
      this.cartProducts,
      this.currentShippingAddress,
      this.currentPaymentMethod,
      @required this.orderPrice, 
      @required this.deliveryPrice, 
      @required this.summaryPrice, 
      this.showAddNewCardForm = false,
      this.isSentOrder = false});

  CheckoutProceedState copyWith(
      {List<Product> cartProducts, int cardId, bool showAddNewCardForm,
      double orderPrice, 
      double deliveryPrice, 
      double summaryPrice,
      bool isSentOrder}) {
    return CheckoutProceedState(
        cartProducts: cartProducts ?? this.cartProducts,
        showAddNewCardForm: showAddNewCardForm ?? this.showAddNewCardForm,
        cardId: cardId ?? this.cardId,
        orderPrice: orderPrice ?? this.orderPrice,
        deliveryPrice: deliveryPrice ?? this.deliveryPrice,
        summaryPrice: summaryPrice ?? this.summaryPrice,
        isSentOrder: isSentOrder ?? this.isSentOrder
    );
  }

  @override
  List<Object> get props => [cartProducts, cardId, showAddNewCardForm, isSentOrder];
}

@immutable
class CheckoutProceededState extends CheckoutState {
  final bool isSentOrder;

  CheckoutProceededState({
    this.isSentOrder = false
  });

  CheckoutProceededState copyWith({
    bool isSentOrder
  }) {
    return CheckoutProceededState (
      isSentOrder: isSentOrder ?? this.isSentOrder
    );
  }
}

@immutable
class CheckoutErrorState extends CheckoutState {}
