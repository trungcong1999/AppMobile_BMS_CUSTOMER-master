import 'package:equatable/equatable.dart';
import 'package:hosco/domain/entities/user/user_entity.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final UserEntity user;

  LoggedIn(this.user);

  @override
  List<Object> get props => [user];
}

class LoggedOut extends AuthenticationEvent {}
