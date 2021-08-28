/*
 * @author Martin Appelmann <exlo89@gmail.com>
 * @copyright 2020 Open E-commerce App
 * @see user_repository.dart
 */

import 'package:flutter/material.dart';
import 'package:hosco/data/model/api_result.dart';
import 'package:hosco/data/model/app_user.dart';
import 'package:hosco/domain/entities/user/user_entity.dart';

abstract class UserRepository {
  /// Sign in with [email] and [password] and return
  /// an access token as [String]
  Future<UserEntity> signIn({
    @required String tenantCode,
    @required String email,
    @required String password,
  });

  /// Sign up with [username] and [password] and return
  /// an access token as [String]
  Future<String> signUp({
    @required String name,
    @required String email,
    @required String password,
  });

  /// Get the user information and return it as [AppUser]
  Future<AppUser> getUser();

  /// Send to [email] a user forget email
  Future<void> forgotPassword({
    @required String email,
  });

  Future<ApiResult> changePassword({
    @required String username,
    @required String currentPassword,
    @required String newPassword,
  });
}
