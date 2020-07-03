import 'medical_record.dart';

class MedicalRecordSingleton {
  static final MedicalRecordSingleton _instance =
      MedicalRecordSingleton._internal();

  factory MedicalRecordSingleton() => _instance;

  MedicalRecordSingleton._internal() {
    medicalRecord = MedicalRecord();
  }

  MedicalRecord medicalRecord;
}
