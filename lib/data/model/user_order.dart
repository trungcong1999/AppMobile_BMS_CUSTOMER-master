import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:hosco/data/error/exceptions.dart';
import 'package:hosco/data/model/promo.dart';
import 'package:hosco/data/woocommerce/models/order_model.dart';
import 'package:hosco/domain/entities/entity.dart';

import 'cart_item.dart';
import 'shipping_address.dart';

enum UserOrderStatus { InProgress, New, Paid, Sent, Delivered }

class UserOrder extends Equatable {
  final String id;
  final List<CartItem> products;
  final String orderNumber;
  final UserOrderStatus orderStatus;
  final String statusText;
  final ShippingAddressModel shippingAddress;

  //TODO: extend further on
  final String paymentMethod;

  //TODO: extend further on
  final String deliveryMethod;
  final Promo promo;
  final String trackingNumber;
  final DateTime orderDate;
  final double totalMoney;
  final String description;

  double get totalPrice =>
      products.fold(
          0,
          (previousValue, element) =>
              previousValue += /*element.productQuantity.quantity */ element.price) -
          ((promo != null? promo.discount??0.0 : 0.0)/100 * products.fold(
              0,
                  (previousValue, element) =>
              previousValue += /*element.productQuantity.quantity */ element.price));

  int get totalQuantity => products.fold(
      0, (previousValue, element) => previousValue += element.productQuantity.quantity);

  UserOrder({
    this.id,
    List<CartItem> products,
    this.orderNumber,
    this.orderStatus = UserOrderStatus.InProgress,
    this.shippingAddress,
    this.paymentMethod,
    this.deliveryMethod,
    this.trackingNumber,
    this.promo,
    this.statusText,
    this.totalMoney,
    this.description,
    DateTime orderCreated,
  })  : products = products ?? [],
        orderDate = orderCreated ?? DateTime.now();

  @override
  List<Object> get props => [
        id,
        products,
        orderNumber,
        orderStatus,
        shippingAddress,
        paymentMethod,
        deliveryMethod,
        trackingNumber,
        promo,
        orderDate,
        totalMoney,
        statusText,
        description,
      ];

  @override
  factory UserOrder.fromEntity(Entity entity) {

    if ( entity is OrderModel ) {
      return UserOrder(
          id: entity.orderNumber,
        orderNumber: entity.trackingNumber,
        orderCreated: DateFormat('yyyy-MM-dd').parse(entity.orderDate.substring(0, 10)),
        orderStatus: UserOrderStatus.Delivered, //entity.orderStatus
        trackingNumber: entity.trackingNumber,
        totalMoney: entity.totalAmount,
        statusText: entity.statusText??entity.orderStatus,
        products: entity.products
      );
    } else {
      throw EntityModelMapperException(message: 'Entity should be of type OrderModel');
    }
  }
}
