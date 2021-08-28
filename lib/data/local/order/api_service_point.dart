import 'dart:convert';

import 'package:hosco/config/storage.dart';
import 'package:hosco/data/model/orderDetail/purchaseorder_detail.dart';
import 'package:hosco/data/model/purchase_order.dart';
import 'package:http/http.dart' as http;

class ApiServicePoint {
  // final url =
  //     'http://api.phanmembanhang.com/api/PurchaseOrder/GetPurchaseOrderDetail/bd548f75-5279-4d93-a680-2c863093918c';
  // Future<PurchaseOrderList> getDataDetail() async {
  //   var response = await http.get(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer ' + Storage().token
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     var body = json.decode(response.body)['data'];
  //         return PurchaseOrderList.fromJson(body);
  //   } else {
  //     throw ("Can't get the Detail");
  //   }
  // }
}
