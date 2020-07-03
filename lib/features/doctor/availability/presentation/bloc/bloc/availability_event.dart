part of 'availability_bloc.dart';

abstract class AvailabilityEvent extends Equatable {
  const AvailabilityEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class LoadAvailableDaysEvent extends AvailabilityEvent {}

class SaveAvailableDaysEvent extends AvailabilityEvent {}

class FetchAllDataEvent extends AvailabilityEvent {}

class SaveFetchedDataEvent extends AvailabilityEvent {
  final dynamic property;
  final int index;

  SaveFetchedDataEvent({this.index, this.property}) : super([index, property]);
}

class Reset extends AvailabilityEvent {}
