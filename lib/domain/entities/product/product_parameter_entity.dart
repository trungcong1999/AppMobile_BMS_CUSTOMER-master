import 'package:hosco/domain/entities/entity.dart';

class ProductParameterEntity extends Entity<String> {
  final String title;

  ProductParameterEntity(
    {String id,
    this.title}) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  @override
  List<Object> get props => [
    id, 
    title
  ];
}
