import 'package:elaj/core/error/exceptions.dart';
import 'package:elaj/core/firebase/firebase.dart';
import 'package:elaj/core/network/network_info.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/all_appointments/data/datasources/cached_basic_appointments_singleton.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';
import 'package:elaj/features/common/appointment_details/domain/repositories/appointment_details_repository.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record.dart';
import 'package:elaj/features/customer/book_appointment/domain/entities/booking.dart';
import 'package:meta/meta.dart';
import 'package:ntp/ntp.dart';

class AppointmentDetailsRepositoryImpl extends AppointmentDetailsRepository {
  final NetworkInfo networkInfo;

  AppointmentDetailsRepositoryImpl({@required this.networkInfo});

  @override
  Future<Either<Failure, Map<String, dynamic>>> checkCancellationStatus(
      String appointmentID, int startTime) async {
    if (networkInfo.isConnected != null) {
      try {
        Map<String, dynamic> basicMap = await FirebaseInit.dbRef
            .child("appointment/$appointmentID/basic")
            .once()
            .then((basicSnapshot) {
          if (basicSnapshot.value == null) throw NoResultException();

          return {
            'isPaid': basicSnapshot.value['isPaid'],
            'amount': basicSnapshot.value['amount']
          };
        });

        Map<String, dynamic> result = Map();

        if (basicMap['isPaid']) {
          await FirebaseInit.dbRef
              .child("constants/cancellation")
              .once()
              .then((snapshot) async {
            if (snapshot.value == null) throw NoResultException();

            Map<String, String> cancellationMap = snapshot.value;

            DateTime currentTime = DateTime.now();

            await NTP.getNtpOffset().then((value) {
              currentTime = currentTime.add(Duration(milliseconds: value));
            });

            DateTime appointmentTime =
                DateTime.fromMillisecondsSinceEpoch(startTime);
            DateTime realTimeBeforePenalty = appointmentTime.subtract(Duration(
                minutes: cancellationMap['noPenaltyBeforeMins'] as num));

            if (!currentTime.isBefore(appointmentTime)) {
              result['isAllowed'] = false;
              result['message'] =
                  "You can no longer cancel this appointment. Press CANCEL to go back.";
              return Right(result);
            }

            if (!currentTime.isBefore(realTimeBeforePenalty)) {
              num penaltyAmount =
                  (basicMap['amount'] * cancellationMap['penalty']).round();
              result['isAllowed'] = true;
              result['message'] = "If you wish to cancel, Rs." +
                  penaltyAmount.toString() +
                  " will be penalised from Rs." +
                  basicMap['amount'].toString() +
                  ". Do you wish to continue?";
              return Right(result);
            }

            result['isAllowed'] = true;
            result['message'] =
                "Cancelling this appointment won't result in any penalty. Do you wish to continue?";
            return Right(result);
          });
        }

        result['isAllowed'] = true;
        result['message'] =
            "Cancelling this appointment won't result in any penalty. Do you wish to continue?";
        return Right(result);
      } on NoResultException {
        return Left(NoResultFailure());
      } catch (e) {
        return Left(ProcessFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> cancelAppointment(
      String appointmentID, bool withPenalty) async {
    if (networkInfo.isConnected != null) {
      try {
        await FirebaseInit.dbRef
            .child("appointment/$appointmentID/basic/status")
            .set(withPenalty ? "cancellingWithPenalty" : "cancelling");
        return Right(true);
      } catch (e) {
        return Left(ProcessFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, BasicAppointment>> getAppointmentDetails(
      String appointmentID) async {
    if (networkInfo.isConnected != null) {
      try {
        CachedBasicAppointmentsSingleton cachedBasicAppointments =
            CachedBasicAppointmentsSingleton();

        bool isCust = await FirebaseInit.auth.currentUser().then((user) => user
            .getIdToken(refresh: true)
            .then((idToken) => idToken.claims.containsKey('customer')));

        List<String> ids = appointmentID.toString().split('_');

        Map<String, dynamic> appointmentMap = new Map();

        // if (!cachedBasicAppointments.currentAppointments
        //     .containsKey(appointmentID)) {
        appointmentMap['id'] = appointmentID;
        await FirebaseInit.dbRef
            .child("appointment/$appointmentID/basic")
            .once()
            .then((appointmentSnapshot) {
          if (appointmentSnapshot.value == null) throw NoResultException();
          print(appointmentSnapshot.value);
          appointmentMap
              .addAll(Map<String, dynamic>.from(appointmentSnapshot.value));
        });

        await FirebaseInit.dbRef
            .child((!isCust ? "customer/${ids[2]}" : "/doctor/${ids[1]}") +
                "/details/basic")
            .once()
            .then((userSnapshot) {
          if (userSnapshot.value == null) throw NoResultException();

          Map<String, dynamic> userMap =
              Map<String, dynamic>.from(userSnapshot.value);
          print(userMap);
          if (!isCust) userMap.remove('gender');

          appointmentMap.addAll(userMap);
        });
        // }

        if (!isCust) {
          List<MedicalRecord> medicalRecords = List();
          await FirebaseInit.dbRef
              .child("customer/${ids[2]}/details/medicalRecord")
              .once()
              .then((snapshot) {
            if (snapshot.value != null) {
              Map<String, dynamic> records =
                  Map<String, dynamic>.from(snapshot.value);
              List<String> ids = records.keys.toList();

              for (int i = 0; i < records.length; i++) {
                records[ids[i]]['id'] = ids.elementAt(i);
                medicalRecords
                    .add(MedicalRecord.fromJson(records[ids.elementAt(i)]));
              }

              appointmentMap['medicalRecords'] = medicalRecords;
            }
          });
        } else {
          appointmentMap['medicalRecords'] = [];
        }

        print(appointmentMap);

        cachedBasicAppointments.currentAppointments[appointmentID] =
            BasicAppointment.fromJson(appointmentMap);

        print(cachedBasicAppointments.currentAppointments[appointmentID]);

        return Right(
            cachedBasicAppointments.currentAppointments[appointmentID]);
      } on NoResultException {
        return Left(NoResultFailure());
      } catch (e) {
        print(e.toString());
        return Left(DbLoadFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkJoinSessionStatus(num startTime) async {
    if (networkInfo.isConnected != null) {
      try {
        DateTime currentTime = DateTime.now();
        DateTime appointmentStartTime =
            DateTime.fromMillisecondsSinceEpoch(startTime);
        DateTime appointmentEndTime = appointmentStartTime
            .add(Duration(minutes: Constant.SESSION_LENGTH));

        await NTP.getNtpOffset().then((int ntpOffset) {
          currentTime = currentTime.add(Duration(milliseconds: ntpOffset));
        });

        if (currentTime.isBefore(appointmentStartTime) ||
            currentTime.isAfter(appointmentEndTime)) return Right(false);

        return Right(true);
      } catch (e) {
        return Left(JoinSessionFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
