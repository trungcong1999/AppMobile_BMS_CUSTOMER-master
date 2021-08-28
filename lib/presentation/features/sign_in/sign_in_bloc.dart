import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hosco/data/repositories/abstract/user_repository.dart';
import 'package:hosco/presentation/features/authentication/authentication.dart';

import 'sign_in.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  SignInBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null),
        super(SignInInitialState());
  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    // normal sign in
    if (event is SignInPressed) {
      yield SignInProcessingState();
      try {
        var user = await userRepository.signIn(
          tenantCode: event.tenantCode,
          email: event.email,
          password: event.password,
        );

        if(user.id != null) {
          authenticationBloc.add(LoggedIn(user));
          yield SignInFinishedState();
        } else {
          yield SignInErrorState(user.name);
        }
      } catch (error) {
        print(error.toString());
        yield SignInErrorState(error);
      }
    }

    // sign in with facebook
    if (event is SignInPressedFacebook) {
      yield SignInProcessingState();
      try {
        await Future.delayed(
          Duration(milliseconds: 300),
        ); //TODO use real auth service

        yield SignInFinishedState();
      } catch (error) {
        yield SignInErrorState(error);
      }
    }

    // sign in with google
    if (event is SignInPressedGoogle) {
      yield SignInProcessingState();
      try {
        await Future.delayed(
          Duration(milliseconds: 100),
        ); //TODO use real auth service

        yield SignInFinishedState();
      } catch (error) {
        yield SignInErrorState(error);
      }
    }
  }
}
