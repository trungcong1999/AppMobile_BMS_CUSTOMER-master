import 'package:hosco/domain/entities/entity.dart';

class ProductParameterVariantEntity extends Entity<String> {
  final String title;
  final int productParameterId;
  final double additionalPrice;

  ProductParameterVariantEntity(
      {String id,
      this.title, 
      this.productParameterId, 
      this.additionalPrice}) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'productParameterId': productParameterId,
      'additionalPrice': additionalPrice
    };
  }

  @override
  List<Object> get props => [
    id, 
    title, 
    productParameterId, 
    additionalPrice
  ];
}
