part of 'credentials_bloc.dart';

abstract class CredentialsState extends Equatable {
  const CredentialsState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => const <dynamic>[];
}

class Initial extends CredentialsState {}

class ProcessingSignIn extends CredentialsState {}

class ProcessingRegister extends CredentialsState {}

class SignIn extends CredentialsState {}

class Register extends CredentialsState {}

class Registered extends CredentialsState {}

class Success extends CredentialsState {
  final Map<String, bool> map;

  Success({this.map}) : super([map]);
}

class Error extends CredentialsState {
  final String msg;

  Error({this.msg}) : super([msg]);
}

class Fetching extends CredentialsState {}
