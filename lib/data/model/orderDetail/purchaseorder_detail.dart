import 'dart:convert';

import 'package:hosco/data/model/orderDetail/detail.dart';

class GetPurchaseOrderDetail {
    GetPurchaseOrderDetail({
        this.id,
        this.orderCode,
        this.employeeId,
        this.customerId,
        this.customerCode,
        this.employeeName,
        this.customerName,
        this.customerPhone,
        this.customerEmail,
        this.customerAddress,
        this.location,
        this.statusText,
        this.orderDate,
        this.status,
        this.billingAddress,
        this.shippingAddress,
        this.orderTotal,
        this.fVat,
        this.mVat,
        this.orderTotalDiscount,
        this.fDiscount,
        this.mDiscount,
        this.discription,
        this.orderDetail,
        this.createdBy,
        this.modifiedBy,
        this.createdDate,
        this.modifiedDate,
    });

    final String id;
    final String orderCode;
    final String employeeId;
    final String customerId;
    final dynamic customerCode;
    final String employeeName;
    final String customerName;
    final String customerPhone;
    final String customerEmail;
    final String customerAddress;
    final String location;
    final String statusText;
    final DateTime orderDate;
    final int status;
    final String billingAddress;
    final String shippingAddress;
    final double orderTotal;
    final double fVat;
    final double mVat;
    final double orderTotalDiscount;
    final double fDiscount;
    final double mDiscount;
    final String discription;
    final List<OrderDetail> orderDetail;
    final String createdBy;
    final String modifiedBy;
    final DateTime createdDate;
    final DateTime modifiedDate;


    factory GetPurchaseOrderDetail.fromJson(Map<String, dynamic> json) => GetPurchaseOrderDetail(
        id: json['Id'],
        orderCode: json['OrderCode'],
        employeeId: json['EmployeeId'],
        customerId: json['CustomerId'],
        customerCode: json['CustomerCode'],
        employeeName: json['EmployeeName'],
        customerName: json['CustomerName'],
        customerPhone: json['CustomerPhone'],
        customerEmail: json['CustomerEmail'],
        customerAddress: json['CustomerAddress'],
        location: json['Location'],
        statusText: json['StatusText'],
        orderDate: DateTime.parse(json['OrderDate']),
        status: json['Status'],
        billingAddress: json['BillingAddress'],
        shippingAddress: json['ShippingAddress'],
        orderTotal: json['OrderTotal'],
        fVat: json['f_Vat'],
        mVat: json['m_Vat'],
        orderTotalDiscount: json['OrderTotalDiscount'],
        fDiscount: json['f_Discount'],
        mDiscount: json['m_Discount'],
        discription: json['Discription'],
        orderDetail: List<OrderDetail>.from(json['OrderDetail'].map((x) => OrderDetail.fromJson(x))),
        createdBy: json['CreatedBy'],
        modifiedBy: json['ModifiedBy'],
        createdDate: DateTime.parse(json['CreatedDate']),
        modifiedDate: DateTime.parse(json['ModifiedDate']),
    );

}