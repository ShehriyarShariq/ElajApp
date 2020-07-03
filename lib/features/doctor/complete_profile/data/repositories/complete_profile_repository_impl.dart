import 'package:elaj/core/error/exceptions.dart';
import 'package:elaj/core/firebase/firebase.dart';
import 'package:elaj/core/network/network_info.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/category.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/features/doctor/complete_profile/domain/repositories/complete_profile_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class CompleteProfileRepositoryImpl extends CompleteProfileRepository {
  final NetworkInfo networkInfo;

  CompleteProfileRepositoryImpl({this.networkInfo});

  @override
  Future<Either<Failure, Map<String, dynamic>>> loadInitData() async {
    if (networkInfo.isConnected != null) {
      try {
        Map<String, dynamic> initData = Map();

        await FirebaseInit.dbRef
            .child("constants/rate")
            .once()
            .then((snapshot) {
          if (snapshot.value == null) return Left(NoResultException());

          initData["serviceCharges"] = (snapshot.value["serviceCharges"]);
        });

        await FirebaseInit.dbRef.child("category").once().then((snapshot) {
          if (snapshot.value == null) throw NoResultException();

          List<Category> allCategories = List();
          snapshot.value.forEach((id, category) {
            allCategories.add(Category(id: id, name: category["name"]));
          });
          initData["categories"] = allCategories;
        });
        return Right(initData);
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
  Future<Either<Failure, bool>> saveCompleteProfile(
      CompleteDoctor completeDoctor) async {
    if (networkInfo.isConnected != null) {
      try {
        String uid =
            await FirebaseInit.auth.currentUser().then((user) => user.uid);

        // profileImg
        StorageUploadTask profileImgUploadTask = FirebaseInit.storageRef
            .child("doctor/" + uid + "/profileImg.png")
            .putFile(completeDoctor.profileImgFile);
        StorageTaskSnapshot profileImgDownloadUrl =
            (await profileImgUploadTask.onComplete);
        String profileImgUrl =
            (await profileImgDownloadUrl.ref.getDownloadURL());
        completeDoctor.profileImg = profileImgUrl;

        // liscenseImg
        StorageUploadTask liscenseImgUploadTask = FirebaseInit.storageRef
            .child("doctor/" + uid + "/liscenseImg.png")
            .putFile(completeDoctor.liscenseImgFile);
        StorageTaskSnapshot liscenseImgDownloadUrl =
            (await liscenseImgUploadTask.onComplete);
        String liscenseImgUrl =
            (await liscenseImgDownloadUrl.ref.getDownloadURL());
        completeDoctor.liscenseImg = liscenseImgUrl;

        // degreeImg
        StorageUploadTask degreeImgUploadTask = FirebaseInit.storageRef
            .child("doctor/" + uid + "/degreeImg.png")
            .putFile(completeDoctor.degreeImgFile);
        StorageTaskSnapshot degreeImgDownloadUrl =
            (await degreeImgUploadTask.onComplete);
        String degreeImgUrl = (await degreeImgDownloadUrl.ref.getDownloadURL());
        completeDoctor.degreeImg = degreeImgUrl;

        completeDoctor.certification.proofImages = Map();
        for (int i = 0;
            i < completeDoctor.certification.imageFiles.length;
            i++) {
          StorageUploadTask imgUploadTask = FirebaseInit.storageRef
              .child("doctor/" +
                  uid +
                  "/certification/certProofImg_" +
                  i.toString() +
                  ".png")
              .putFile(completeDoctor.certification.imageFiles[i]);
          StorageTaskSnapshot imgDownloadUrl = (await imgUploadTask.onComplete);
          String imgUrl = (await imgDownloadUrl.ref.getDownloadURL());
          completeDoctor.certification.proofImages[randomAlphaNumeric(6)] =
              imgUrl;
        }

        completeDoctor.experience.proofImages = Map();
        for (int i = 0; i < completeDoctor.experience.imageFiles.length; i++) {
          StorageUploadTask imgUploadTask = FirebaseInit.storageRef
              .child("doctor/" +
                  uid +
                  "/experience/expProofImg_" +
                  i.toString() +
                  ".png")
              .putFile(completeDoctor.experience.imageFiles[i]);
          StorageTaskSnapshot imgDownloadUrl = (await imgUploadTask.onComplete);
          String imgUrl = (await imgDownloadUrl.ref.getDownloadURL());
          completeDoctor.experience.proofImages[randomAlphaNumeric(9)] = imgUrl;
        }

        await FirebaseInit.dbRef
            .child("doctor/" + uid + "/details")
            .update(completeDoctor.toJson());

        await FirebaseInit.dbRef
            .child("doctor/" + uid + "/details/basic")
            .update(completeDoctor.basicJsonMap());

        return Right(true);
      } catch (e) {
        return Left(ProcessFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Category>>> searchFromCategories(
      String searchTerm, List<Category> categories) async {
    List<Category> queriedCategory = List();

    categories.forEach((category) {
      if (category.name
          .toLowerCase()
          .contains(searchTerm.trim().toLowerCase())) {
        queriedCategory.add(category);
      }
    });

    if (searchTerm.trim().length == 0) return Right(categories);

    return Right(queriedCategory);
  }
}
