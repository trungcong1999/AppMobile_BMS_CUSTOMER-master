import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hosco/config/server_addresses.dart';
import 'package:hosco/config/storage.dart';
import 'package:hosco/data/error/exceptions.dart';
import 'package:hosco/data/model/api_result.dart';
import 'package:hosco/data/model/user_order.dart';
import 'package:hosco/domain/usecases/orders/orders_by_filter_params.dart';
import 'package:hosco/domain/usecases/products/products_by_filter_params.dart';

abstract class WoocommercWrapperAbstract {
  Future<List<dynamic>> getCategoryList({String parentId = '0'});
  Future<dynamic> getProduct({String productId});
  Future<ApiResult> getProductList(ProductsByFilterParams params);
  Future<List<dynamic>> getPromoList({int userId = 0});
  Future<int> saveOrder(UserOrder order);
  Future<ApiResult> getMyOrders(OrdersByFilterParams params);
  Future<dynamic> getOrderDetails(String orderId);
  Future<dynamic> getConfigs();
}

class WoocommerceWrapper implements WoocommercWrapperAbstract {
  final http.Client client;

  WoocommerceWrapper({@required this.client});

  @override
  Future<ApiResult> getProductList(ProductsByFilterParams params) {
    //TODO: make remote request using all paramaters
    return _postApiRequest(ServerAddresses.products, params.toJson());
    //return _getApiRequest(ServerAddresses.products);
  }

  @override
  Future<dynamic> getConfigs() async {
    final response = await client.get(
      ServerAddresses.getConfig,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + Storage().token
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      return null;
      //throw HttpRequestException();
    }
    //return _getApiRequest(ServerAddresses.getConfig);
  }

  @override
  Future<List<dynamic>> getCategoryList({String parentId = '0'}) {
    return _getApiRequest(ServerAddresses.productCategories);
  }

  @override
  Future<dynamic> getProduct({String productId}) async {
    final response = await client.get(
      ServerAddresses.productDetailUrl + '/' + productId,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + Storage().token
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw HttpRequestException();
    }
  }

  @override
  Future<ApiResult> getMyOrders(OrdersByFilterParams params) async {
    return _postApiRequest(ServerAddresses.myOrderUrl, params.toJson());
  }

  @override
  Future<dynamic> getOrderDetails(String orderId) async {
    final response = await client.get(
      ServerAddresses.orderDetailUrl + '/' + orderId,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + Storage().token
      },
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return json['data'];
    } else {
      throw HttpRequestException();
    }
  }

  @override
  Future<List> getPromoList({int userId = 0}) {
    var json = [
      {
        'id': '101',
        'code': 'ten_percent',
        'amount': '10.00',
        'discount_type': 'percent',
        'description': 'Ten Percent Discount',
        'date_expires': '2022-05-24T00:00:00'
      }
    ];
    return Future.value(json);
    //return _getApiRequest(ServerAddresses.promos);
  }

  @override
  Future<int> saveOrder(UserOrder order) async {
    var data = <String, dynamic>{
      'EmployeeId': Storage().account.id,
      'f_Discount': order.promo?.discount ?? 0.0,
      'OrderTotalDiscount': order.totalPrice,
      'OrderTotal': order.totalPrice,
      'ShippingAddress': order.shippingAddress?.address ?? '',
      'BillingAddress': order.shippingAddress?.address ?? '',
      'Description': order.description ?? '',
      'Location_Id': ''
    };

    List d = [];
    for (var i = 0; i < order.products.length; i++) {
      var prod = order.products[i].product;
      d.add(<String, dynamic>{
        'ProductId': prod.id,
        'ProductName': prod.title,
        //'ProductCode': prod.id,
        'Price': prod.price, //order.products[i].price,
        'Qty': order.products[i].productQuantity.quantity,
        'Unit': prod.unit,
        'f_Convert': prod.fConvert,
        'Description': '',
        'StoreId': ''
      });
    }
    data['OrderDetail'] = d;

    final response = await client.get(
      ServerAddresses.genOrderIdUrl + '/""',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + Storage().token
      },
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body)['data'];
      data['OrderCode'] = json['NewCode'];
      //print(jsonEncode(data));
      final resp = await client.post(ServerAddresses.orderUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ' + Storage().token
          },
          body: jsonEncode(data));

      if (resp.statusCode == 200) {
        //print(jsonDecode(resp.body));
        return jsonDecode(resp.body)['meta']['status_code'] as int;
      }
    }
    return 1;
  }

  Future<List<dynamic>> _getApiRequest(String url) async {
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + Storage().token
      },
    );
    if (response.statusCode == 200) {
      //print(jsonDecode(response.body)['data']);
      return jsonDecode(response.body)['data'];
    } else {
      return null;
      //throw HttpRequestException();
    }
  }

  Future<ApiResult> _postApiRequest(String url,
      [dynamic params = const {}]) async {

    final response = await client.post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + Storage().token
        },
        body: jsonEncode(params));
    if (response.statusCode == 200) {
      return ApiResult.fromJson(jsonDecode(response.body));
    } else {
      //throw HttpRequestException();
      return ApiResult();
    }
  }
}
