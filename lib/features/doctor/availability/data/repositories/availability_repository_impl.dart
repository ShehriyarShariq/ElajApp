import 'package:elaj/core/error/exceptions.dart';
import 'package:elaj/core/firebase/firebase.dart';
import 'package:elaj/core/network/network_info.dart';
import 'package:elaj/features/doctor/availability/domain/entities/availability.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/features/doctor/availability/domain/repositories/availability_repository.dart';
import 'package:ntp/ntp.dart';

class AvailabilityRepositoryImpl extends AvailabilityRepository {
  final NetworkInfo networkInfo;

  AvailabilityRepositoryImpl({this.networkInfo});

  @override
  Future<Either<Failure, Availability>> loadAvailableDays() async {
    if (networkInfo.isConnected != null) {
      try {
        String uid =
            await FirebaseInit.auth.currentUser().then((user) => user.uid);

        Availability availability = Availability(availableDays: List());

        await FirebaseInit.dbRef
            .child("doctor/" + uid + "/details/workingHours")
            .once()
            .then((snapshot) {
          if (snapshot.value != null)
            availability = Availability.fromJson(snapshot.value);
        });

        DateTime currentTime = DateTime.now();
        await NTP.getNtpOffset().then((int ntpOffset) {
          currentTime = currentTime.add(Duration(milliseconds: ntpOffset));
        });
        DateTime currentDate =
            DateTime(currentTime.year, currentTime.month, currentTime.day);

        if (availability.availableDays.length == 0) {
          DateTime datePointer = currentDate;
          availability.availableDays =
              List<AvailableDay>.filled(7, AvailableDay(), growable: false);
          for (int i = 0; i < 7; i++) {
            availability.availableDays[datePointer.weekday % 7] =
                AvailableDay(date: datePointer, slots: List<DaySlot>());
            datePointer = datePointer.add(Duration(days: 1));
          }

          return Right(availability);
        } else {
          Availability updatedAvailability = Availability(
              availableDays:
                  List<AvailableDay>.filled(7, null, growable: false));

          for (int i = 0; i < availability.availableDays.length; i++) {
            if (!availability.availableDays[i].date.isBefore(currentDate)) {
              updatedAvailability.availableDays[
                      availability.availableDays[i].date.weekday % 7] =
                  availability.availableDays[i];
            }
          }

          for (int i = 0; i < 7; i++) {
            DateTime actualDayDate = currentDate.add(Duration(days: i));
            if (updatedAvailability.availableDays[actualDayDate.weekday % 7] ==
                null) {
              updatedAvailability.availableDays[actualDayDate.weekday % 7] =
                  AvailableDay(date: actualDayDate, slots: List<DaySlot>());
            }
          }

          return Right(updatedAvailability);
        }
      } catch (e) {
        print(e.toString());
        return Left(ProcessFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<int>>> saveAvailableDays(
      Availability availability) async {
    if (networkInfo.isConnected != null) {
      try {
        String uid =
            await FirebaseInit.auth.currentUser().then((user) => user.uid);

        await FirebaseInit.dbRef
            .child("doctor/" + uid + "/slots/")
            .once()
            .then((slotsSnapShot) async {
          if (slotsSnapShot.value != null) {
            Map<int, Map<int, int>> existingSlots =
                slotsSnapShot.value as Map<int, Map<int, int>>;
            Map<int, Map<int, int>> newSlots = availability.getAvailableSlots();

            Map<int, Map<int, int>> updatedSlots = Map();
            List<int> invalidDay = List();

            newSlots.keys.forEach((date) {
              if (existingSlots.containsKey(date)) {
                List<int> alreadyUsedMiniSlots = List();
                newSlots[date].keys.forEach((miniSlotStart) {
                  if (!existingSlots[date].containsKey(miniSlotStart)) {
                    alreadyUsedMiniSlots.add(miniSlotStart);
                  }
                });

                newSlots[date].removeWhere((key, value) {
                  return !alreadyUsedMiniSlots.contains(key);
                });

                if (alreadyUsedMiniSlots.length > 0) {
                  updatedSlots[date] = newSlots[date];
                }
              } else {
                updatedSlots[date] = newSlots[date];
              }
            });

            existingSlots.keys.forEach((date) {
              List<int> dateSlots = existingSlots[date].values.toList();
              if (dateSlots.indexOf(-1) == -1) {
                if (!newSlots.containsKey(date)) {
                  updatedSlots[date] = null;
                }
              } else {
                if (newSlots.containsKey(date)) {
                  int index = dateSlots.indexOf(-1, 0);
                  while (index != -1) {
                    newSlots[date][existingSlots[date].keys.toList()[index]] =
                        dateSlots[index];
                    index = dateSlots.indexOf(-1, index + 1);
                  }
                } else {
                  invalidDay.add(
                      DateTime.fromMillisecondsSinceEpoch(date).weekday % 7);
                }
              }
            });

            if (invalidDay.length > 0) return Right(invalidDay);

            await FirebaseInit.dbRef
                .child("doctor/" + uid + "/details/workingHours")
                .set(availability.toJson());

            Map<String, dynamic> slotsUpdatesMap = Map();
            slotsUpdatesMap["/slots/"] = updatedSlots;

            await FirebaseInit.dbRef
                .child("doctor/" + uid)
                .update(slotsUpdatesMap);
          } else {
            await FirebaseInit.dbRef
                .child("doctor/" + uid + "/details/workingHours")
                .set(availability.toJson());

            await FirebaseInit.dbRef
                .child("doctor/" + uid + "/slots/")
                .set(availability.getAvailableSlots());
          }
        });

        return Right(List());
      } catch (e) {
        return Left(ProcessFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
