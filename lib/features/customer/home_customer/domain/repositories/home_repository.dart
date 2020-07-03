import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/category.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Category>>> getAllCategories();
  Future<Either<Failure, List<Category>>> searchFromCategories(
      String searchTerm, List<Category> categories);
  Future<Either<Failure, List<MedicalRecord>>> getAllMedicalRecords();
  Future<Either<Failure, bool>> logOut();
}
