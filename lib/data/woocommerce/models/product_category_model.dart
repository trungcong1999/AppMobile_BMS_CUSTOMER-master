
import 'package:flutter/material.dart';
import 'package:hosco/domain/entities/product/product_category_entity.dart';

class ProductCategoryModel extends ProductCategoryEntity {

  ProductCategoryModel(
    {@required String id,
    @required title,
    @required description,
    @required image,
    @required thumb,
    parentId,
    orderNumber,
    count}) : super(
      id: id, 
      title: title,
      description: description,
      image: image,
      thumb: thumb,
      parentId: parentId,
      orderNumber: orderNumber,
      count: count
    );
      
  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    var title = json['GroupName'] as String;
    if(title.length > 20) {
      title = title.substring(0, 18) + '...';
    }
    return ProductCategoryModel(
      id: json['Id'],
      title: title,
      description: json['Description'] ?? '',
      image: json['Picture'] ?? '',
      thumb: json['Picture'] ?? '',
      parentId: '0', //(json['parent'] as num).toInt(),
      orderNumber: 0,//(json['menu_order'] as num).toInt(),
      count: 0,//(json['InStock'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 
      'name': title,
      'parent': parentId,
      'description': description,
      'image': {
        'src': image,
      },
      'menu_order': orderNumber,
      'count': count
    };
  }
}
