import 'package:elaj/features/doctor/availability/domain/entities/availability.dart';

class SelectedSlot {
  AvailableDay day;
  DaySlot daySlot;

  SelectedSlot();

  bool isSet() {
    return day != null && daySlot != null;
  }
}
