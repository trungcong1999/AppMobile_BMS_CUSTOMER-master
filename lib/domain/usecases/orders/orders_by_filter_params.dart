import 'package:hosco/data/model/filter_rules.dart';
import 'package:hosco/data/model/sort_rules.dart';

class OrdersByFilterParams {
  final String categoryId;
  final SortRules sortBy;
  final FilterRules filterRules;

  final int PageIndex;
  final int PageSize;
  final int FilterType;
  final int OrderStatus;
  final String SearchPattern;

  OrdersByFilterParams({
    this.categoryId,
    this.sortBy, 
    this.filterRules,
    this.FilterType = -1,
    this.PageIndex = 0,
    this.PageSize = 20,
    this.OrderStatus = -1,
    this.SearchPattern
  });

  bool get filterByCategory => categoryId != null;

  Map<String, dynamic> toJson() =>
      {
        'FilterType': FilterType,
        'PageIndex': PageIndex,
        'PageSize': PageSize,
        'OrderStatus': OrderStatus,
        'filterRules': filterRules,
        'FromDate': '2021-01-27T14:19:36.839Z',
        'ToDate': '2021-01-28T14:19:36.839Z',
        'LocationId': '',
        'SearchByOrderInfo': SearchPattern,
        'SearchByCustomerInfo': '',
        'SearchByProductInfo': '',
      };
}