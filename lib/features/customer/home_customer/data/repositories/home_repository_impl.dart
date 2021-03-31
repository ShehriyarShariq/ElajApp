import 'dart:io';

import 'package:elaj/core/error/exceptions.dart';
import 'package:elaj/core/firebase/firebase.dart';
import 'package:elaj/core/network/network_info.dart';
import 'package:elaj/core/util/customer_check_singleton.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/all_categories_singleton.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/category.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/medical_records_singleton.dart';
import 'package:elaj/features/customer/home_customer/domain/repositories/home_repository.dart';
import 'package:elaj/features/customer/home_customer/presentation/bloc/bloc/home_customer_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

class HomeRepositoryImpl extends HomeRepository {
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({@required this.networkInfo});

  @override
  Future<Either<Failure, List<Category>>> getAllCategories() async {
    if (networkInfo.isConnected != null) {
      try {
        AllCategoriesSingleton allCategoriesSingleton =
            AllCategoriesSingleton();

        if (allCategoriesSingleton.categories.length == 0) {
          await FirebaseInit.dbRef.child("category").once().then((snapshot) {
            if (snapshot.value == null) throw NoResultException();

            snapshot.value.forEach((id, categoryJson) {
              categoryJson['id'] = id;
              allCategoriesSingleton.categories.add(
                  Category.fromJson(Map<String, String>.from(categoryJson)));
            });
          });
        }

        return Right(allCategoriesSingleton.categories);
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
  Future<Either<Failure, List<MedicalRecord>>> getAllMedicalRecords() async {
    if (networkInfo.isConnected != null) {
      try {
        CustomerCheckSingleton customerCheckSingleton =
            new CustomerCheckSingleton();
        if (!customerCheckSingleton.isCustLoggedIn)
          throw UnauthorizedUserException();

        FirebaseUser user = await FirebaseInit.auth.currentUser();
        if (user == null) throw UnauthorizedUserException();

        customerCheckSingleton.isCustLoggedIn = true;

        MedicalRecordsSingleton medicalRecordsSingleton =
            new MedicalRecordsSingleton();

        medicalRecordsSingleton.medicalRecords = new List<MedicalRecord>();

        await FirebaseInit.dbRef
            .child("customer/" + user.uid + "/details/medicalRecord")
            .once()
            .then((snapShot) {
          if (snapShot.value != null) {
            snapShot.value.forEach((id, recordJson) {
              recordJson['id'] = id;
              medicalRecordsSingleton.medicalRecords.add(MedicalRecord.fromJson(
                  Map<String, dynamic>.from(recordJson)));
            });
          }
        });

        return Right(medicalRecordsSingleton.medicalRecords);
      } on UnauthorizedUserException {
        return Left(UnauthorizedUserFailure());
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
  Future<Either<Failure, List<Category>>> searchFromCategories(
      String searchTerm, List<Category> categories) async {
    if (networkInfo.isConnected != null) {
      try {
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
      } on NoResultException {
        return Left(NoResultFailure());
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
        await Future.delayed(Duration(milliseconds: 500));

        CustomerCheckSingleton customerCheckSingleton =
            CustomerCheckSingleton();
        customerCheckSingleton.isCustLoggedIn = false;

        return Right(true);
      } catch (e) {
        return Left(AuthFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
