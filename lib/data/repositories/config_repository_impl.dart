
import 'package:hosco/data/repositories/abstract/config_repository.dart';
import 'package:hosco/data/model/config.dart';
import 'package:hosco/data/error/exceptions.dart';
import 'package:hosco/data/network/network_status.dart';
import 'package:hosco/data/woocommerce/repositories/config_remote_repository.dart';
import 'package:hosco/locator.dart';

class ConfigRepositoryImpl extends ConfigRepository {

  @override
  Future<dynamic> getConfigs() async {
      ConfigRepository configRep = RemoteConfigRepository(woocommerce: sl());
      return await configRep.getConfigs();
  }
}
