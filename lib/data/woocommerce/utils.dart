/*
 * @author Martin Appelmann <exlo89@gmail.com>
 * @copyright 2020 Open E-commerce App
 * @see utils.dart
 */


import 'package:hosco/config/server_addresses.dart';
import 'package:hosco/config/storage.dart';

class HttpClient {

  Map createHeader() {
    var header = <String, String>{
      'authorization': 'Bearer ' + Storage().token,
    };
    return header;
  }

  Uri createUri(String route, [Map<String, String> param = const {}]) {
    return Uri(
      scheme: 'http',
      host: ServerAddresses.serverAddress,
      path: route,
      queryParameters: param,
    );
  }
}
