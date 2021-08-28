import 'package:hosco/data/model/cart_item.dart';
import 'package:hosco/domain/entities/entity.dart';

class UserOrderEntity extends Entity<String> {
  final String orderNumber;
  final String trackingNumber;
  final int productCount;
  final int promoCodeId;
  final double discountPercent;
  final String discountTitle;
  final int shippingAddressId;
  final String orderStatus;
  final String statusText;
  final double totalAmount;
  final int deliveryMethodId;
  final double deliveryPrice;
  final String orderDate;
  final String customerName;
  final String employeeName;
  final List<CartItem> products;

  UserOrderEntity(
      {String id,
      this.orderNumber,
      this.trackingNumber,
      this.productCount,
      this.promoCodeId,
      this.discountPercent,
      this.discountTitle,
      this.shippingAddressId,
      this.orderStatus,
        this.statusText,
      this.totalAmount,
      this.deliveryMethodId,
      this.deliveryPrice,
      this.orderDate,
        this.products,
      this.customerName,
      this.employeeName}) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'trackingNumber': trackingNumber,
      'productCount': productCount,
      'promoCodeId': promoCodeId,
      'discountPercent': discountPercent,
      'discountTitle': discountTitle,
      'shippingAddressId': shippingAddressId,
      'orderStatus': orderStatus,
      'statusText': statusText,
      'totalAmount': totalAmount,
      'deliveryMethodId': deliveryMethodId,
      'deliveryPrice': deliveryPrice,
      'orderDate': orderDate,
      'customerName': customerName,
      'employeeName': employeeName,
      'products': products
    };
  }

  @override
  List<Object> get props => [
        id,
        orderNumber,
        trackingNumber,
        productCount,
        promoCodeId,
        discountPercent,
        discountTitle,
        shippingAddressId,
        orderStatus,
        totalAmount,
        deliveryMethodId,
        deliveryPrice,
        orderDate,
        customerName,
        employeeName,
        statusText,
      ];
}
