/*
 * @author Martin Appelmann <exlo89@gmail.com>
 * @copyright 2020 Open E-commerce App
 * @see user_repository.dart
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hosco/config/server_addresses.dart';
import 'package:hosco/config/storage.dart';
import 'package:hosco/data/model/api_result.dart';
import 'package:hosco/data/model/app_user.dart';
import 'package:hosco/data/repositories/abstract/user_repository.dart';
import 'package:hosco/domain/entities/user/user_entity.dart';

import '../utils.dart';

class RemoteUserRepository extends UserRepository {
  @override
  Future<UserEntity> signIn({
    @required String tenantCode,
    @required String email,
    @required String password,
  }) async {
    var route = HttpClient().createUri(ServerAddresses.authToken);
    var data = <String, dynamic>{
      'UserName': email,
      'Password': password,
      'TenantCode': tenantCode,
      'TenantId': 0,
      'Language': 'en'
    };

    var response = await http.post(route,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));

    Map jsonResponse = json.decode(response.body);
    if (response.statusCode != 200) {
      throw jsonResponse['meta']['message'];
    } else {
      if(jsonResponse['meta']['status_code'] == 1) {
        var user = UserEntity(id: null, name: jsonResponse['meta']['message']);
        return user;
      }

      var u = jsonResponse['data']['Acount'];
      var user = UserEntity(id: u['CustomerId'],
          name: u['DisplayName'],
          username: u['UserName'],
          avatar: u['Avatar'],
          email: u['Email'],
          password: password,
          tenantCode: tenantCode,
          address: u['Address'],
          mobile: u['Mobile'],
          isAdmin: u['IsSystemAccount'],
          Company_Tel1: u['Company_Tel1'],
          Company_Tel2: u['Company_Tel2'],
          token: jsonResponse['data']['token']);

      return user;
    }
  }

  @override
  Future<String> signUp({
    @required String name,
    @required String email,
    @required String password,
  }) async {
    try {
      var route = HttpClient().createUri(ServerAddresses.signUp);
      var data = <String, String>{
        'name': name,
        'username': email,
        'password': password,
      };

      var response = await http.post(route, body: data);
      Map jsonResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }
      return jsonResponse['token'];
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<AppUser> getUser() async {
    try {
      // TODO api call for user information
      await Future.delayed(Duration(seconds: 2));

      return AppUser();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword({
    @required String email,
  }) async {
    try {
      var route = HttpClient().createUri(ServerAddresses.forgotPassword);
      var data = <String, String>{
        'email': email,
      };

      var response = await http.post(route, body: data);
      Map jsonResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<ApiResult> changePassword({
    @required String username,
    @required String currentPassword,
    @required String newPassword,
  }) async {
    try {
      var route = HttpClient().createUri(ServerAddresses.changePassword);
      var data = <String, String>{
        'UserName': username,
        'OldPassword': currentPassword,
        'NewPassword': newPassword
      };

      var headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + Storage().token
      };

      var response = await http.post(route, headers: headers, body: jsonEncode(data));
      var json = jsonDecode(response.body);
      json['data'] = null;
      return ApiResult.fromJson(json);
    } catch (error) {
      rethrow;
    }
  }
}
