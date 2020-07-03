part of 'credentials_bloc.dart';

abstract class CredentialsEvent extends Equatable {
  const CredentialsEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => const <dynamic>[];
}

class ShowSignInScreenEvent extends CredentialsEvent {}

class ShowRegisterScreenEvent extends CredentialsEvent {}

class SignInWithCredentialsEvent extends CredentialsEvent {
  final UserCred userCred;

  SignInWithCredentialsEvent(this.userCred) : super([userCred]);
}

class RegisterWithCredentialsEvent extends CredentialsEvent {
  final UserCred userCred;

  RegisterWithCredentialsEvent(this.userCred) : super([userCred]);
}

class FetchAllDataEvent extends CredentialsEvent {}

class SaveFetchedValueEvent extends CredentialsEvent {
  final dynamic property;
  final String type;

  SaveFetchedValueEvent({this.property, this.type}) : super([type, property]);
}

class Reset extends CredentialsEvent {}
