import 'package:elaj/features/doctor/availability/domain/entities/availability.dart';

class AvailabilitySingleton {
  static final AvailabilitySingleton _instance =
      AvailabilitySingleton._internal();

  factory AvailabilitySingleton() => _instance;

  AvailabilitySingleton._internal() {
    availability = Availability(
        availableDays: List<AvailableDay>.filled(7, null, growable: false));
  }

  Availability availability;

  void reset() {
    availability = Availability(
        availableDays: List<AvailableDay>.filled(7, null, growable: false));
  }
}
