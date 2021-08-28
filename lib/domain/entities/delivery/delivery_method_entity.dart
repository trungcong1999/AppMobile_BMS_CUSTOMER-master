import 'package:hosco/domain/entities/entity.dart';

class DeliveryMethodEntity extends Entity<String> {
  final String title;
  final double price;

  DeliveryMethodEntity(
    {String id,
    this.title, 
    this.price}) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'title': title, 
      'price': price
    };
  }

  @override
  List<Object> get props => [
    id, 
    title, 
    price
  ];
}
