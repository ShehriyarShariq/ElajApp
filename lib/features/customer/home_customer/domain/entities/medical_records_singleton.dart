import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record.dart';

class MedicalRecordsSingleton {
  static final MedicalRecordsSingleton _instance =
      MedicalRecordsSingleton._internal();

  factory MedicalRecordsSingleton() => _instance;

  MedicalRecordsSingleton._internal() {
    medicalRecords = List<MedicalRecord>();
  }

  List<MedicalRecord> medicalRecords;
}
