import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';

class CachedBasicAppointmentsSingleton {
  static final CachedBasicAppointmentsSingleton _instance =
      CachedBasicAppointmentsSingleton._internal();

  factory CachedBasicAppointmentsSingleton() => _instance;

  CachedBasicAppointmentsSingleton._internal() {
    currentAppointments = Map();
    pastAppointments = Map();
  }

  Map<String, BasicAppointment> currentAppointments;
  Map<String, BasicAppointment> pastAppointments;
}
