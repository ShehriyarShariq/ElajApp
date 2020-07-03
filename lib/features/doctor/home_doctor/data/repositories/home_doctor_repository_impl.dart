import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/exceptions.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/core/firebase/firebase.dart';
import 'package:elaj/core/network/network_info.dart';
import 'package:elaj/features/common/all_appointments/data/datasources/cached_basic_appointments_singleton.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';
import 'package:elaj/features/customer/book_appointment/domain/entities/booking.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';
import 'package:elaj/features/doctor/home_doctor/domain/entities/wallet.dart';
import 'package:elaj/features/doctor/home_doctor/domain/repositories/home_doctor_repository.dart';

class HomeDoctorRepositoryImpl extends HomeDoctorRepository {
  NetworkInfo networkInfo;

  HomeDoctorRepositoryImpl({this.networkInfo});

  @override
  Future<Either<Failure, Map<DateTime, List<BasicAppointment>>>>
      getDoctorAppointments() async {
    if (networkInfo.isConnected != null) {
      try {
        CachedBasicAppointmentsSingleton cachedBasicAppointments =
            CachedBasicAppointmentsSingleton();

        String uid =
            await FirebaseInit.auth.currentUser().then((user) => user.uid);

        await FirebaseInit.dbRef
            .child("doctor/" + uid + "/appointment/" + "current")
            .once()
            .then((snapshot) async {
          if (snapshot.value == null) throw NoResultException();

          Map<String, BasicAppointment> appointments = Map();

          await snapshot.value.forEach((appointmentID, dummyVal) async {
            bool isNew = !cachedBasicAppointments.currentAppointments
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
                  .child("customer/" + ids[2] + "/details/basic")
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

          cachedBasicAppointments.currentAppointments.addAll(appointments);

          cachedBasicAppointments.currentAppointments.keys.forEach((id) {
            if (existingAppointmentIDs.indexOf(id) == -1) toBeDeleted.add(id);
          });

          toBeDeleted.forEach((id) {
            cachedBasicAppointments.currentAppointments.remove(id);
          });

          Map<DateTime, List<BasicAppointment>> appointmentsMap = Map();
          cachedBasicAppointments.currentAppointments.forEach((key, value) {
            DateTime thisDate = value.start;
            thisDate = DateTime(thisDate.year, thisDate.month, thisDate.day);

            if (appointmentsMap.containsKey(thisDate)) {
              appointmentsMap[thisDate].add(value);
            } else {
              appointmentsMap[thisDate] = [value];
            }
          });

          return Right(appointmentsMap);
        });

        throw NoResultException();
      } on NoResultException {
        return Right({});
      } catch (e) {
        return Left(DbLoadFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, CompleteDoctor>> getDoctorProfile() async {
    if (networkInfo.isConnected != null) {
      try {
        String uid =
            await FirebaseInit.auth.currentUser().then((user) => user.uid);

        CompleteDoctor doctor;

        await FirebaseInit.dbRef
            .child("doctor/" + uid + "/details/")
            .once()
            .then((snapshot) async {
          if (snapshot.value == null) throw NoResultException();

          snapshot.value["id"] = snapshot.key;
          doctor = CompleteDoctor.fromJson(snapshot.value);
          print(doctor.liscenseImg);
        });

        await FirebaseInit.dbRef
            .child("doctor/" + uid + "/isVerified")
            .once()
            .then((snapshot) {
          if (snapshot.value == null || snapshot.value == false)
            doctor.isVerified = false;
          else
            doctor.isVerified = true;
        });

        return Right(doctor);
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
  Future<Either<Failure, Wallet>> getDoctorWallet() async {
    if (networkInfo.isConnected != null) {
      try {
        String uid =
            await FirebaseInit.auth.currentUser().then((user) => user.uid);
        Wallet wallet;

        await FirebaseInit.dbRef
            .child("doctorEarning/" + uid)
            .once()
            .then((snapshot) async {
          if (snapshot.value == null) {
            wallet = Wallet(wallet: "0", appointment: {});
          } else {
            wallet = Wallet.fromJson(snapshot.value);
          }
        });

        return Right(wallet);
      } on NoResultException {
        return Left(NoResultFailure());
      } catch (e) {
        return Left(DbLoadFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logOut() async {
    if (networkInfo.isConnected != null) {
      try {
        await FirebaseInit.auth.signOut();
        return Right(true);
      } catch (e) {
        return Left(AuthFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
