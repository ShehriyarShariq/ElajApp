part of 'splash_bloc.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class CheckCurrentUserEvent extends SplashEvent {}
