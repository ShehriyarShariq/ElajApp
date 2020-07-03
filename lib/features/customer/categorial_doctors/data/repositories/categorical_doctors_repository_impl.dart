import 'package:elaj/core/error/exceptions.dart';
import 'package:elaj/core/firebase/firebase.dart';
import 'package:elaj/core/network/network_info.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/categorial_doctors/domain/entities/basic_doctor.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/features/customer/categorial_doctors/domain/repositories/categorical_doctors_repository.dart';
import 'package:meta/meta.dart';

class CategoricalDoctorsRepositoryImpl extends CategoricalDoctorsRepository {
  final NetworkInfo networkInfo;

  CategoricalDoctorsRepositoryImpl({@required this.networkInfo});

  @override
  Future<Either<Failure, List<BasicDoctor>>> getAllCategoricalDoctors(
      String lastFetchedDoctorID, String categoryID) async {
    if (networkInfo.isConnected != null) {
      try {
        List<BasicDoctor> doctors = List();

        await FirebaseInit.dbRef
            .child("category_doctor/" + categoryID)
            .startAt(null, key: lastFetchedDoctorID)
            .limitToFirst(Constant.CATEGORICAL_DOCTOR_LOAD_LIMIT + 1)
            .once()
            .then((snapshot) async {
          if (snapshot.value == null) throw NoResultException();

          Iterable<String> categoricalDoctorIDs =
              Map<String, String>.from(snapshot.value).keys;

          for (int i = 0; i < categoricalDoctorIDs.length; i++) {
            String doctorID = categoricalDoctorIDs.elementAt(i);
            if (doctorID != lastFetchedDoctorID) {
              BasicDoctor doctor = BasicDoctor.empty();
              doctor.id = doctorID;
              doctor.photoURL = await FirebaseInit.storageRef
                  .child("doctor/" + doctorID + "/profileImg.png")
                  .getDownloadURL();

              await FirebaseInit.dbRef
                  .child("doctor/" + doctorID + "/details/basic")
                  .once()
                  .then((snapShot) async {
                Map<String, dynamic> doctorBasicMap =
                    Map<String, dynamic>.from(snapShot.value);
                doctor.name = doctorBasicMap['name'];
                doctor.specialty =
                    Map<String, String>.from(doctorBasicMap['specialty'])
                        .values
                        .join(", ");
                doctor.expYears = doctorBasicMap['experience']['years'];
              });

              await FirebaseInit.dbRef
                  .child("doctor/" + doctorID + "/details/rate")
                  .once()
                  .then((rateSnapshot) => doctor.rate = rateSnapshot.value);

              await FirebaseInit.dbRef
                  .child(
                      "category_doctor_rating/" + categoryID + "/" + doctorID)
                  .once()
                  .then((ratingSnapShot) {
                if (ratingSnapShot.value != null) {
                  num totalRating = 0, totalCount = 0;
                  ratingSnapShot.value.forEach((ratingCategory, count) {
                    totalRating += Constant.RATING_MAP[ratingCategory] * count;
                    totalCount += count;
                  });

                  doctor.rating = 1.0 * totalRating / totalCount;
                } else {
                  doctor.rating = -1;
                }
              });

              doctors.add(doctor);
            }
          }
        });

        return Right(doctors);
      } on NoResultException {
        return Right([]);
      } catch (e) {
        return Left(DbLoadFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<BasicDoctor>>> searchFromCategoricalDoctors(
      String searchTerm, categoricalDoctors) async {
    if (networkInfo.isConnected != null) {
      try {
        List<BasicDoctor> queriedDoctors = List();

        categoricalDoctors.forEach((category) {
          if (category.name
              .toLowerCase()
              .contains(searchTerm.trim().toLowerCase())) {
            queriedDoctors.add(category);
          }
        });

        if (searchTerm.trim().length == 0) return Right(categoricalDoctors);

        if (queriedDoctors.length == 0) throw NoResultException();

        return Right(queriedDoctors);
      } on NoResultException {
        return Left(NoResultFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
