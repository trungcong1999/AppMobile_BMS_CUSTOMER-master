import 'package:hosco/domain/entities/entity.dart';

class Product2ParameterEntity extends Entity<String> {
  final int productParameterId;
  final int productId;

  Product2ParameterEntity(
    {String id,
    this.productParameterId, 
    this.productId}) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productParameterId': productParameterId,
      'productId': productId,
    };
  }

  @override
  List<Object> get props => [
    id, 
    productParameterId, 
    productId
  ];
}
