import 'package:flutter/material.dart';
import 'package:hosco/data/model/config.dart';
import 'package:hosco/data/error/exceptions.dart';
import 'package:hosco/data/repositories/abstract/config_repository.dart';
import 'package:hosco/data/woocommerce/repositories/woocommerce_wrapper.dart';

class RemoteConfigRepository extends ConfigRepository {
  final WoocommercWrapperAbstract woocommerce;

  RemoteConfigRepository({@required this.woocommerce});

  @override
  Future<dynamic> getConfigs() async {
      return await woocommerce.getConfigs();
  }
}
