import 'package:hosco/domain/entities/entity.dart';

class ProductCartEntity extends Entity<String> {
  final int productId;
  final int productCount;
  final double totalPrice;

  ProductCartEntity(
    {String id,
    this.productId, 
    this.productCount, 
    this.totalPrice}) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productCount': productCount,
      'totalPrice': totalPrice,
    };
  }

  @override
  List<Object> get props => [
    id, 
    productId, 
    productCount, 
    totalPrice
  ];
}
