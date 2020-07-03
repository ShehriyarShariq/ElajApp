part of 'add_medical_records_bloc.dart';

abstract class AddMedicalRecordsState extends Equatable {
  const AddMedicalRecordsState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends AddMedicalRecordsState {}

class Fetching extends AddMedicalRecordsState {}

class Saved extends AddMedicalRecordsState {}

class Error extends AddMedicalRecordsState {}
