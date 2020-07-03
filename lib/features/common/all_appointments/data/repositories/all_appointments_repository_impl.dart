import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/exceptions.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/core/firebase/firebase.dart';
import 'package:elaj/core/network/network_info.dart';
import 'package:elaj/features/common/all_appointments/data/datasources/cached_basic_appointments_singleton.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';
import 'package:elaj/features/common/all_appointments/domain/repositories/all_appointments_repository.dart';
import 'package:elaj/features/customer/book_appointment/domain/entities/booking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class AllAppointmentsRepositoryImpl extends AllAppointmentsRepository {
  final NetworkInfo networkInfo;

  AllAppointmentsRepositoryImpl({@required this.networkInfo});

  @override
  Future<Either<Failure, List<BasicAppointment>>>
      getCurrentAppointments() async {
    return await _getEitherCurrentOrPastAppointments(true);
  }

  @override
  Future<Either<Failure, List<BasicAppointment>>> getPastAppointments() async {
    return await _getEitherCurrentOrPastAppointments(false);
  }

  Future<Either<Failure, List<BasicAppointment>>>
      _getEitherCurrentOrPastAppointments(bool current) async {
    if (networkInfo.isConnected != null) {
      try {
        FirebaseUser user = await FirebaseInit.auth.currentUser();
        if (user == null) throw UnauthorizedUserException();

        bool isCust = await user
            .getIdToken(refresh: true)
            .then((idToken) => idToken.claims.containsKey('customer'));

        CachedBasicAppointmentsSingleton cachedBasicAppointments =
            CachedBasicAppointmentsSingleton();

        String uid = user.uid;

        await FirebaseInit.dbRef
            .child((isCust ? "customer/" : "doctor/") +
                "$uid/appointment/" +
                (current ? "current" : "past"))
            .once()
            .then((snapshot) async {
          if (snapshot.value == null) throw NoResultException();

          Map<String, BasicAppointment> appointments = Map();

          await snapshot.value.forEach((appointmentID, dummyVal) async {
            bool isNew = current
                ? !cachedBasicAppointments.currentAppointments
                    .containsKey(appointmentID)
                : !cachedBasicAppointments.pastAppointments
                    .containsKey(appointmentID);
            if (isNew) {
              List<String> ids = appointmentID.toString().split('_');
              Map<String, dynamic> appointmentMap = new Map();
              appointmentMap['id'] = appointmentID;

              await FirebaseInit.dbRef
                  .child("appointment/" + appointmentID + "/basic")
                  .once()
                  .then((appointmentSnapshot) {
                if (appointmentSnapshot.value == null) throw Exception();

                appointmentMap.addAll(
                    Map<String, dynamic>.from(appointmentSnapshot.value));
              });

              await FirebaseInit.dbRef
                  .child((isCust ? "customer/" + ids[2] : "/doctor/" + ids[1]) +
                      "/details/basic")
                  .once()
                  .then((userSnapshot) {
                if (userSnapshot.value == null) throw Exception();

                appointmentMap
                    .addAll(Map<String, dynamic>.from(userSnapshot.value));
              });

              appointments[appointmentID] =
                  BasicAppointment.fromJson(appointmentMap);
            }
          });

          List<String> toBeDeleted = List();
          List<String> existingAppointmentIDs =
              (snapshot.value as Map<String, String>).keys.toList();

          if (current) {
            cachedBasicAppointments.currentAppointments.addAll(appointments);

            cachedBasicAppointments.currentAppointments.keys.forEach((id) {
              if (existingAppointmentIDs.indexOf(id) == -1) toBeDeleted.add(id);
            });

            toBeDeleted.forEach((id) {
              cachedBasicAppointments.currentAppointments.remove(id);
            });
          } else {
            cachedBasicAppointments.pastAppointments.addAll(appointments);

            cachedBasicAppointments.pastAppointments.keys.forEach((id) {
              if (existingAppointmentIDs.indexOf(id) == -1) toBeDeleted.add(id);
            });

            toBeDeleted.forEach((id) {
              cachedBasicAppointments.pastAppointments.remove(id);
            });
          }

          return Right(current
              ? cachedBasicAppointments.currentAppointments
              : cachedBasicAppointments.pastAppointments);
        });

        throw NoResultException();
      } on UnauthorizedUserException {
        return Left(UnauthorizedUserFailure());
      } on NoResultException {
        return Right([]);
      } catch (e) {
        return Left(DbLoadFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
