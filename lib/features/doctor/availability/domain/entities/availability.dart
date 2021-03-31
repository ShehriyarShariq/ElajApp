import 'package:elaj/core/util/constants.dart';

class Availability {
  List<AvailableDay> availableDays;

  Availability({this.availableDays});

  factory Availability.fromJson(List<dynamic> json) => Availability(
        availableDays: _decodeSnapshotList(json).cast<AvailableDay>().toList(),
      );

  List toJson() {
    return encodeAvailableDaysList(availableDays);
  }

  static List encodeAvailableDaysList(List<AvailableDay> list) {
    List jsonList = List();
    list.map((item) {
      if (item.date != null) {
        jsonList.add(item.toJson());
      }
    }).toList();
    return jsonList;
  }

  static List<AvailableDay> _decodeSnapshotList(List jsonList) {
    List<AvailableDay> list = List<AvailableDay>();
    jsonList.forEach((item) {
      list.add(AvailableDay.fromJson(Map<String, dynamic>.from(item)));
    });
    return list;
  }

  Map<String, Map<String, String>> getAvailableSlots() {
    Map<String, Map<String, String>> allDaysSlots = Map();
    availableDays.forEach((day) {
      Map<String, String> slots = Map();
      if (day.slots != null) {
        day.slots.forEach((slot) {
          DateTime slotPointer = slot.start;

          while (slotPointer.isBefore(slot.end)) {
            DateTime miniSlotStart = slotPointer;
            DateTime miniSlotEnd =
                miniSlotStart.add(Duration(minutes: Constant.SESSION_LENGTH));

            slots[miniSlotStart.millisecondsSinceEpoch.toString()] =
                miniSlotEnd.millisecondsSinceEpoch.toString();
            slotPointer = miniSlotEnd;
          }
        });
        allDaysSlots[day.date.millisecondsSinceEpoch.toString()] = slots;
      }
    });
    return allDaysSlots;
  }
}

class AvailableDay {
  DateTime date;
  List<DaySlot> slots;

  AvailableDay({this.date, this.slots});

  factory AvailableDay.fromJson(Map<String, dynamic> json) => AvailableDay(
        date: DateTime.fromMillisecondsSinceEpoch(json['date']),
        slots: _decodeSnapshotList(json['slots']).cast<DaySlot>().toList(),
      );

  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'slots': slots != null ? _encodeSlotsList(slots) : null
    };
  }

  static List _encodeSlotsList(List<DaySlot> list) {
    List jsonList = List();
    list.map((item) {
      jsonList.add(item.toJson());
    }).toList();
    return jsonList;
  }

  static List<DaySlot> _decodeSnapshotList(List jsonList) {
    List<DaySlot> list = List<DaySlot>();
    jsonList.forEach((item) {
      list.add(DaySlot.fromJson(Map<String, num>.from(item)));
    });
    return list;
  }
}

class DaySlot {
  DateTime start, end;

  DaySlot({this.start, this.end});

  factory DaySlot.fromJson(Map<String, num> json) => DaySlot(
        start: DateTime.fromMillisecondsSinceEpoch(json['start']),
        end: DateTime.fromMillisecondsSinceEpoch(json['end']),
      );

  Map<String, num> toJson() {
    return {
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch
    };
  }
}
