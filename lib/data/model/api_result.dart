
import 'package:equatable/equatable.dart';
import 'package:hosco/domain/entities/entity.dart';

class ApiResult extends Equatable {
  final List<dynamic> data;
  final Map<String, dynamic> meta;
  final Map<String, dynamic> paging;

  ApiResult({this.data, this.meta, this.paging});

  @override
  List<Object> get props => [
    data, meta, paging
  ];

  @override
  factory ApiResult.fromEntity(Entity entity) {

    return ApiResult(
      data: null,
      meta: null,
      paging: null
    );
  }

  @override
  factory ApiResult.fromJson(Map<String, dynamic> json) {
    return ApiResult(
        data: json['data'],
        meta: json['meta'],
        paging: json.containsKey('paging') ? json['paging'] : null
    );
  }

}