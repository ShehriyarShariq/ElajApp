import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record_singleton.dart';
import 'package:elaj/features/customer/add_medical_record/domain/usecases/upload_medical_record.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/medical_records_singleton.dart';
import 'package:equatable/equatable.dart';

part 'add_medical_records_event.dart';
part 'add_medical_records_state.dart';

class AddMedicalRecordsBloc
    extends Bloc<AddMedicalRecordsEvent, AddMedicalRecordsState> {
  UploadMedicalRecord uploadMedicalRecord;

  AddMedicalRecordsBloc({UploadMedicalRecord upload})
      : assert(upload != null),
        uploadMedicalRecord = upload;

  @override
  AddMedicalRecordsState get initialState => Initial();

  @override
  Stream<AddMedicalRecordsState> mapEventToState(
    AddMedicalRecordsEvent event,
  ) async* {
    if (event is FetchAllValuesEvent) {
      yield Fetching();
    } else if (event is SaveFetchedValueEvent) {
      MedicalRecordSingleton medicalRecordSingleton = MedicalRecordSingleton();

      switch (event.type) {
        case "desc":
          medicalRecordSingleton.medicalRecord.desc = event.property;
          break;
        case "date":
          medicalRecordSingleton.medicalRecord.date = event.property;
          break;
        case "doctorName":
          medicalRecordSingleton.medicalRecord.doctorName = event.property;
          break;
        case "doctorSpecialty":
          medicalRecordSingleton.medicalRecord.doctorSpecialty = event.property;
          break;
        case "images":
          medicalRecordSingleton.medicalRecord.pages = event.property["pages"];
          medicalRecordSingleton.medicalRecord.images =
              event.property["existingImages"];
          break;
      }

      if (medicalRecordSingleton.medicalRecord.isFullyInitialized()) {
        final failureOrRecord = await uploadMedicalRecord(
            MedicalRecordParams(record: medicalRecordSingleton.medicalRecord));
        yield failureOrRecord.fold((failure) => Error(), (r) => Saved());
        medicalRecordSingleton.medicalRecord.reset();
      }
    } else if (event is ResetEvent) {
      yield Initial();
    }
  }
}
