import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';

class CompleteDoctorSingleton {
  static final CompleteDoctorSingleton _instance =
      CompleteDoctorSingleton._internal();

  factory CompleteDoctorSingleton() => _instance;

  CompleteDoctorSingleton._internal() {
    completeDoctor = CompleteDoctor();
  }

  CompleteDoctor completeDoctor;
}
