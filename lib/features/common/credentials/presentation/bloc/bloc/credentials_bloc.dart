import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elaj/core/entities/user_cred.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/credentials/domain/entities/user_cred_singleton.dart';
import 'package:elaj/features/common/credentials/domain/usecases/sign_in_with_credentials.dart';
import 'package:elaj/features/common/credentials/domain/usecases/sign_up_with_credentials.dart';
import 'package:elaj/features/doctor/availability/presentation/bloc/bloc/availability_bloc.dart';
import 'package:equatable/equatable.dart';

part 'credentials_event.dart';
part 'credentials_state.dart';

class CredentialsBloc extends Bloc<CredentialsEvent, CredentialsState> {
  SignInWithCredentials signInWithCredentials;
  SignUpWithCredentials signUpWithCredentials;

  CredentialsBloc({SignInWithCredentials signIn, SignUpWithCredentials signUp})
      : assert(signIn != null),
        assert(signUp != null),
        signInWithCredentials = signIn,
        signUpWithCredentials = signUp;

  @override
  CredentialsState get initialState => Initial();

  @override
  Stream<CredentialsState> mapEventToState(
    CredentialsEvent event,
  ) async* {
    if (event is ShowSignInScreenEvent) {
      yield SignIn();
    } else if (event is ShowRegisterScreenEvent) {
      yield Register();
    } else if (event is FetchAllDataEvent) {
      yield Fetching();
    } else if (event is SaveFetchedValueEvent) {
      UserCredSingleton userCredSingleton = UserCredSingleton();

      switch (event.type) {
        case 'isSignIn':
          userCredSingleton.userCred.isSignIn = event.property;
          break;
        case 'firstName':
          userCredSingleton.userCred.firstName = event.property;
          break;
        case 'lastName':
          userCredSingleton.userCred.lastName = event.property;
          break;
        case 'email':
          userCredSingleton.userCred.email = event.property;
          break;
        case 'password':
          userCredSingleton.userCred.password = event.property;
          break;
        case 'phoneNum':
          userCredSingleton.userCred.phoneNum = event.property;
          break;
        case 'signUpReferral':
          userCredSingleton.userCred.signUpReferral = event.property;
          break;
        case 'isCustomer':
          userCredSingleton.userCred.isCustomer = event.property;
          break;
        case 'gender':
          userCredSingleton.userCred.gender = event.property ? "M" : "F";
          break;
      }

      if (userCredSingleton.userCred.areValuesFilled()) {
        final failureOrSuccess = userCredSingleton.userCred.isSignIn
            ? await signInWithCredentials(
                AuthParams(userCred: userCredSingleton.userCred))
            : await signUpWithCredentials(
                AuthParams(userCred: userCredSingleton.userCred));
        yield failureOrSuccess.fold(
            (failure) => Error(
                msg: 'Failed to ' +
                    (userCredSingleton.userCred.isSignIn
                        ? "SignIn"
                        : "Register")),
            (map) => Success(map: map));
      }
    } else if (event is Reset) {
      yield Initial();
    }
  }
}
