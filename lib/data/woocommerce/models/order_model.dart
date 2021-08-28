import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hosco/data/model/cart_item.dart';
import 'package:hosco/data/model/product.dart';
import 'package:hosco/data/model/product_attribute.dart';
import 'package:hosco/data/woocommerce/models/my_product_model.dart';
import 'package:hosco/domain/entities/order/user_order_entity.dart';

class OrderModel extends UserOrderEntity {

  OrderModel(
    {@required orderNumber,
    @required trackingNumber,
    productCount,
      products,
    promoCodeId,
    discountPercent,
    discountTitle,
    shippingAddressId,
    @required orderStatus,
    @required totalAmount,
      orderDate,
      customerName,
      employeeName,
      statusText,
      deliveryMethodId,
      deliveryPrice}) : super(
      orderNumber: orderNumber,
    trackingNumber: trackingNumber,
    productCount: productCount,
    promoCodeId: promoCodeId,
    discountPercent: discountPercent,
    discountTitle: discountTitle,
    shippingAddressId: shippingAddressId,
    orderStatus: orderStatus,
    statusText: statusText,
    totalAmount: totalAmount,
    deliveryMethodId: deliveryMethodId,
    deliveryPrice: deliveryPrice,
      orderDate: orderDate,
      customerName: customerName,
      employeeName: employeeName,
    products: products
    );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<CartItem> products = [];
    if(json['OrderDetail'] != null) {
      for (int i = 0; i < json['OrderDetail'].length; i++) {
        var tmp = json['OrderDetail'][i];
        tmp['Name'] = tmp['ProductName'];
        tmp['InStock'] = 0;
        products.add(CartItem(
          product: Product.fromEntity(MyProductModel.fromJson(tmp)),
          productQuantity: ProductQuantity(tmp['Qty'].round()),
          selectedAttributes: HashMap<ProductAttribute, String>(),
        ));
      }
    }

    return OrderModel(
      orderNumber: json['Id'],
      trackingNumber: json['OrderCode'],
      productCount: products.length,
      products: products,
      promoCodeId: 0,
      discountPercent: json['Discount'],
      discountTitle: '',
      shippingAddressId: 0,
      orderStatus: json['OrderStatus'],
      statusText: json['StatusText'],
      totalAmount: json['TotalMoney'],
      deliveryMethodId: 0,
      deliveryPrice: 0.0,
        orderDate: json['OrderDate'],
        customerName: json['CustomerName'],
        employeeName: json['EmployeeName']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
  static String stripTags(String htmlText) {
    RegExp exp = RegExp(
        r'<[^>]*>',
        multiLine: true,
        caseSensitive: true
      );
    return htmlText.replaceAll(exp, '');
  }
}
