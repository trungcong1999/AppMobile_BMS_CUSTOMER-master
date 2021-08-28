/*
 * @author Andrew Poteryahin <openflutterproject@gmail.com>
 * @copyright 2020 Open E-commerce App
 * @see user_repository_impl.dart
 */

import 'package:flutter/material.dart';
import 'package:hosco/data/model/api_result.dart';
import 'package:hosco/data/model/app_user.dart';
import 'package:hosco/data/repositories/abstract/user_repository.dart';
import 'package:hosco/data/woocommerce/repositories/remote_user_repository.dart';
import 'package:hosco/domain/entities/user/user_entity.dart';

class UserRepositoryImpl extends UserRepository {
  final RemoteUserRepository remoteUserRepository;

  UserRepositoryImpl({@required this.remoteUserRepository});

  @override
  Future<UserEntity> signIn({
    @required String tenantCode,
    @required String email,
    @required String password,
  }) async {
    return remoteUserRepository.signIn(tenantCode: tenantCode, email: email, password: password);
  }

  @override
  Future<String> signUp({
    @required String name,
    @required String email,
    @required String password,
  }) async {
    return remoteUserRepository.signUp(name: name, email: email, password: password);
  }

  @override
  Future<AppUser> getUser() async {
    try {
      return remoteUserRepository.getUser();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword({
    @required String email,
  }) async {
      return remoteUserRepository.forgotPassword(email: email);
  }

  @override
  Future<ApiResult> changePassword({
    @required String username,
    @required String currentPassword,
    @required String newPassword,
  }) async {
    return remoteUserRepository.changePassword(username: username, currentPassword: currentPassword, newPassword: newPassword);
  }
}
