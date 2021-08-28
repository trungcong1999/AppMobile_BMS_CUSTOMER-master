// To parse this JSON data, do
//
//     final purchaseOrderList = purchaseOrderListFromJson(jsonString);

import 'dart:convert';

class PurchaseOrderList {
    PurchaseOrderList({
        this.id,
        this.orderCode,
        this.orderDate,
        this.customerName,
        this.employeeName,
        this.orderStatus,
        this.discount,
        this.totalMoney,
    });

    final String id;
    final String orderCode;
    final DateTime orderDate;
    final String customerName;
    final String employeeName;
    final String orderStatus;
    final double discount;
    final double totalMoney;

    factory PurchaseOrderList.fromJson(Map<String, dynamic> json) => PurchaseOrderList(
        id: json['Id'],
        orderCode: json['OrderCode'],
        orderDate: DateTime.parse(json['OrderDate']),
        customerName: json['CustomerName'],
        employeeName: json['EmployeeName'],
        orderStatus: json['OrderStatus'],
        discount: json['Discount'],
        totalMoney: json['TotalMoney'],
    );
}
