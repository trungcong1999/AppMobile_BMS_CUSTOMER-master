import 'dart:convert';

class OrderDetail {
    OrderDetail({
        this.id,
        this.orderId,
        this.productId,
        this.productName,
        this.productCode,
        this.unit,
        this.price,
        this.qty,
        this.fDiscount,
        this.mDiscount,
        this.description,
        this.fConvert,
        this.storeId,
    });

    final String id;
    final int orderId;
    final String productId;
    final String productName;
    final String productCode;
    final String unit;
    final double price;
    final double qty;
    final double fDiscount;
    final double mDiscount;
    final String description;
    final double fConvert;
    final double storeId;

    factory OrderDetail.fromRawJson(String str) => OrderDetail.fromJson(json.decode(str));


    factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json['Id'],
        orderId: json['OrderId'],
        productId: json['ProductId'],
        productName: json['ProductName'],
        productCode: json['ProductCode'],
        unit: json['Unit'],
        price: json['Price'],
        qty: json['Qty'],
        fDiscount: json['f_Discount'],
        mDiscount: json['m_Discount'],
        description: json['Description'],
        fConvert: json['f_Convert'],
        storeId: json['StoreId'],
    );

}
