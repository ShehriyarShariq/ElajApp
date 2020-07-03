import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record.dart';

class Appointment {
  BasicAppointment basic;
  bool isDoctor;
  List<MedicalRecord> medicalRecords;

  Appointment({this.basic, this.isDoctor, this.medicalRecords});
}
