part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends SplashState {}

class Success extends SplashState {
  final Map<String, bool> map;

  Success({this.map}) : super([map]);
}

class Error extends SplashState {}
