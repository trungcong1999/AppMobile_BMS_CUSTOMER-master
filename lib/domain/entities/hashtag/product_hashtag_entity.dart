import 'package:hosco/domain/entities/entity.dart';

class ProductHashTagEntity extends Entity<String> {
  final int hashTagId;
  final int productId;

  ProductHashTagEntity({String id, this.hashTagId, this.productId}) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hashTagId': hashTagId,
      'productId': productId,
    };
  }

  @override
  List<Object> get props => [id, hashTagId, productId];
}
