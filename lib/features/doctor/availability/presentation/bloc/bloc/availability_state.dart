part of 'availability_bloc.dart';

abstract class AvailabilityState extends Equatable {
  const AvailabilityState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends AvailabilityState {}

class Loading extends AvailabilityState {}

class Loaded extends AvailabilityState {
  final Availability availability;

  Loaded({this.availability}) : super([availability]);
}

class Fetching extends AvailabilityState {}

class Processing extends AvailabilityState {}

class Saved extends AvailabilityState {}

class Error extends AvailabilityState {
  final String msg;

  Error({this.msg}) : super([msg]);
}

class SnackBarError extends AvailabilityState {
  final String msg;

  SnackBarError({this.msg}) : super([msg]);
}

class SlotError extends AvailabilityState {
  final List<int> invalidDays;

  SlotError({this.invalidDays}) : super([invalidDays]);
}
