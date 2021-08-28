import 'package:hosco/domain/entities/entity.dart';

class CategoryHashTagEntity extends Entity<String> {
  final int hashTagId;
  final int categoryId;

  CategoryHashTagEntity({String id, this.hashTagId, this.categoryId}) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hashTagId': hashTagId,
      'categoryId': categoryId,
    };
  }

  @override
  List<Object> get props => [
    id, 
    hashTagId, 
    categoryId
  ];
}
