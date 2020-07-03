import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/category.dart';
import 'package:elaj/features/doctor/complete_profile/domain/repositories/complete_profile_repository.dart';

class SelectSpecialtiesFromList
    implements UseCase<List<Category>, SearchParams> {
  CompleteProfileRepository repository;

  SelectSpecialtiesFromList(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(SearchParams params) async {
    return await repository.searchFromCategories(
        params.searchTerm, params.list);
  }
}
