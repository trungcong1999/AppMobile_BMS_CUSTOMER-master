// Category repository
// Author: openflutterproject@gmail.com
// Date: 2020-02-06

import '../../model/config.dart';

abstract class ConfigRepository {
  Future<dynamic> getConfigs();
}
