import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hosco/config/storage.dart';
import 'package:hosco/domain/entities/user/user_entity.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
      AuthenticationBloc():super(Uninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    // app start
    if (event is AppStarted) {
      var token = await _getToken();
      var user = await _getAccount();
      if (token != '') {
        Map<String, dynamic> account = jsonDecode(user);
        Storage().token = token;
        Storage().account = UserEntity.fromJson(account);
        yield Authenticated();
      } else {
        yield Unauthenticated();
      }
    }

    if (event is LoggedIn) {
      Storage().token = event.user.token;
      Storage().account = event.user;
      await _saveToken(event.user.token);
      String u = jsonEncode(event.user.toJson());
      await _saveAccount(u);
      yield Authenticated();
    }

    if (event is LoggedOut) {
      Storage().token = '';
      //Storage().account = null;
      await _deleteToken();
      //await _deleteAccount();
      yield Unauthenticated();
    }
  }

  /// delete from keystore/keychain
  Future<void> _deleteToken() async {
    await Storage().secureStorage.delete(key: 'access_token');
  }

  /// write to keystore/keychain
  Future<void> _saveToken(String token) async {
    await Storage().secureStorage.write(key: 'access_token', value: token);
  }

  /// read to keystore/keychain
  Future<String> _getToken() async {
    return await Storage().secureStorage.read(key: 'access_token') ?? '';
  }

  /// delete from keystore/keychain
  Future<void> _deleteAccount() async {
    await Storage().secureStorage.delete(key: 'user_logged');
  }

  /// write to keystore/keychain
  Future<void> _saveAccount(String userJson) async {
    await Storage().secureStorage.write(key: 'user_logged', value: userJson);
  }

  /// read to keystore/keychain
  Future<String> _getAccount() async {
    return await Storage().secureStorage.read(key: 'user_logged') ?? '';
  }
}
