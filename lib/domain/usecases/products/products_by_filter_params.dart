import 'package:hosco/data/model/filter_rules.dart';
import 'package:hosco/data/model/sort_rules.dart';

class ProductsByFilterParams {
  final String categoryId;
  final SortRules sortBy;
  final FilterRules filterRules;

  final int PageIndex;
  final int PageSize;
  final int Instock;
  final bool Visible;
  final String ProductGroup;
  final String ProductName;

  ProductsByFilterParams({
    this.categoryId,
    this.sortBy, 
    this.filterRules,
    this.PageIndex,
    this.PageSize,
    this.Visible,
    this.ProductGroup = '',
    this.ProductName = '',
    this.Instock
  });

  bool get filterByCategory => categoryId != null;

  Map<String, dynamic> toJson() =>
      {
        'PageIndex': PageIndex,
        'PageSize': PageSize,
        'Visible': Visible,
        'Instock': Instock,
        'ProductGroup': ProductGroup,
        'ProductName': ProductName,
        'filterRules': filterRules
      };
}