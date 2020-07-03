import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;

  Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [properties];
}

class AuthFailure extends Failure {}

class DbLoadFailure extends Failure {}

class NoResultFailure extends Failure {}

class NetworkFailure extends Failure {}

class ProcessFailure extends Failure {}

class InvalidReferralCodeFailure extends Failure {}

class InvalidBookingSlotFailure extends Failure {}

class JoinSessionFailure extends Failure {}

class UnauthorizedUserFailure extends Failure {}
