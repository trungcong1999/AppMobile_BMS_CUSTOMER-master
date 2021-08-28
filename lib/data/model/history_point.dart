// To parse this JSON data, do
//
//     final getPointHistory = getPointHistoryFromJson(jsonString);

import 'dart:convert';

class GetPointHistory {
    GetPointHistory({
        this.createdAt,
        this.customerId,
        this.customerCode,
        this.customerName,
        this.point,
        this.note,
    });

    final DateTime createdAt;
    final String customerId;
    final String customerCode;
    final String customerName;
    final int point;
    final String note;

    factory GetPointHistory.fromJson(Map<String, dynamic> json) => GetPointHistory(
        createdAt: DateTime.parse(json['CreatedAt']),
        customerId: json['CustomerId'],
        customerCode: json['CustomerCode'],
        customerName: json['CustomerName'],
        point: json['Point'],
        note: json['Note'],
    );

}
