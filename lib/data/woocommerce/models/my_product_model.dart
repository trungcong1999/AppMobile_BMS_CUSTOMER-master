import 'package:flutter/material.dart';
import 'package:hosco/data/model/product_attribute.dart';
import 'package:hosco/domain/entities/hashtag/hashtag_entity.dart';
import 'package:hosco/domain/entities/product/product_category_entity.dart';
import 'package:hosco/domain/entities/product/product_entity.dart';

class MyProductModel extends ProductEntity {

  MyProductModel(
    {@required id,
    @required title,
    @required subTitle,
    @required description,
    @required images,
    @required double price,
    @required salePrice,
    @required thumb,
    @required selectableAttributes,
    rating,
    List<ProductCategoryEntity> categories,
    List<HashTagEntity> hashTags,
    orderNumber,
      unit, unitPrice, fConvert,
    count}) : super(
      id: id, 
      title: title,
      subTitle: subTitle,
      price: price,
      amount: count,
      discountPercent: 0,//salePrice != 0 ? ((price - salePrice)/price*100).round().toDouble() : 0,
      description: description,
      selectableAttributes: selectableAttributes,
      images: images,
      thumb: thumb,
      rating: rating,
      categories: categories,
      hashTags: hashTags,
    unit: unit,
    unitPrice: unitPrice,
    fConvert: fConvert,
    );

  factory MyProductModel.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    if ( json['ImageUrls']!=null ) {
      (json['ImageUrls'] as List).forEach((f) => images.add(f));
    }
    var title = json['Name'] as String;
    var groupName = json['GroupName'] as String;

    return MyProductModel(
      id: json['Id'],
      title: title,
      subTitle: groupName,//json['categories']!=null? json['categories'][0]['name']:'',
      description: stripTags(json['Description']),
      rating: 0.0, //json['average_rating'] !=null ? double.parse(json['average_rating']) : 0,
      images: images,
      price: json['Price'],// !=null && json['UnitPrice'] != '' ? double.parse(json['UnitPrice']) : 0,
      salePrice: json['Price'],// !=null && json['Price'] != '' ? double.parse(json['Price']) : 0,
      thumb: json['Picture'] ?? '',
      unit: json['Unit']??'',
      unitPrice: json['UnitPrice']??0.0,
      fConvert: json['f_Convert']??0,
      //TODO: add all categories related to product
      categories: _getCategoriesFromJson(json),
      orderNumber: 10,//(json['menu_order'] as num).toInt(),
      selectableAttributes: _getSelectableAttributesFromJson(json),
      hashTags: _getHashTagsFromJson(json),
        count: (json['InStock'] as num).toInt(),
    );
  }

  static List<HashTagEntity> _getHashTagsFromJson(Map<String, dynamic> json){
    List<HashTagEntity> tags = [];
    /*
    if ( json['tags']!= null ) {
       for (var hashTag in json['tags']) {
        tags.add(
          HashTagEntity(
            id: hashTag['id']??0,
            title: hashTag['name']??''
          )
        );
      }
    }*/
    return tags;
  }

  static List<ProductCategoryEntity> _getCategoriesFromJson(Map<String, dynamic> json){
    List<ProductCategoryEntity> categories = [];
    /*
    if ( json['categories']!= null ) {
       for (var category in json['categories']) {
        categories.add(
          ProductCategoryEntity(
            id: category['id']??0,
            title: category['name']??''
          )
        );
      }
    }*/
    return categories;
  }

  static List<ProductAttribute> _getSelectableAttributesFromJson(Map<String, dynamic> json){
    List<ProductAttribute> selectableAttributes = [];
    /*
    if ( json['attributes']!= null ) {
       for (var attribute in json['attributes']) {
        selectableAttributes.add(
          ProductAttribute(
            id: attribute['id']??0,
            name: attribute['name']??'',
            options: List<String>.from(attribute['options'])
          )
        );
      }
    }*/
    return selectableAttributes;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 
      'name': title,
      'description': description,
      // 'image': {
      //   'src': images.isNotEmpty?images[0]:'',
      // }
    };
  }
  static String stripTags(String htmlText) {
    RegExp exp = RegExp(
        r'<[^>]*>',
        multiLine: true,
        caseSensitive: true
      );
    return htmlText.replaceAll(exp, '');
  }
}
