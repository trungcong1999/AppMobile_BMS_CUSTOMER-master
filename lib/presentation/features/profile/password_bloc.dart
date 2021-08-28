import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hosco/config/storage.dart';
import 'package:hosco/data/repositories/abstract/user_repository.dart';
import 'package:hosco/data/repositories/fake_repos/password_repository.dart';
import 'package:hosco/presentation/features/profile/password_event.dart';
import 'package:hosco/presentation/features/profile/password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final PasswordRepository passwordRepository;
  final UserRepository userRepository;

  PasswordBloc({@required this.passwordRepository, @required this.userRepository})
      : assert(passwordRepository != null),
        super(PasswordInitialState());

  @override
  Stream<PasswordState> mapEventToState(PasswordEvent event) async* {
    if (event is ChangePasswordEvent) {
      if (event.currentPassword.isEmpty) {
        yield EmptyCurrentPasswordState();
      } else if (event.newPassword.isEmpty) {
        yield EmptyNewPasswordState();
      // } else if (event.repeatNewPassword.isEmpty) {
      //   yield EmptyRepeatPasswordState();
      // } else if (event.newPassword != event.repeatNewPassword) {
      //   yield PasswordMismatchState();
      // } else if (event.newPassword.length < 6) {
      //   yield InvalidNewPasswordState();
      } else {
        try {
          var user = Storage().account;
/*
          var currentPassword = await passwordRepository.getCurrentPassword();
          if (event.currentPassword != user.password) {
            yield IncorrectCurrentPasswordState();
          } else {*/
            try {
              var result = await userRepository.changePassword(username: user.name,
                  currentPassword: event.currentPassword, newPassword: event.newPassword);
              if(result.meta['status_code'] == 0) {
                yield PasswordChangedState();
              } else {
                yield ChangePasswordErrorState(errorMessage: result.meta['message']);
              }
            } catch (error) {
              yield ChangePasswordErrorState(errorMessage: 'Đã có lỗi xảy ra !');
            }
          // }
        } catch (error) {
          yield ChangePasswordErrorState(errorMessage: 'Đã có lỗi xảy ra !');
        }
      }
    }
  }
}
