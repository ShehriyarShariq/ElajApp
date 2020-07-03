part of 'add_medical_records_bloc.dart';

abstract class AddMedicalRecordsEvent extends Equatable {
  const AddMedicalRecordsEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class FetchAllValuesEvent extends AddMedicalRecordsEvent {}

class SaveFetchedValueEvent extends AddMedicalRecordsEvent {
  final property;
  final String type;

  SaveFetchedValueEvent({this.property, this.type}) : super([property, type]);
}

class ResetEvent extends AddMedicalRecordsEvent {}
