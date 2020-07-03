import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/customer/categorial_doctors/domain/entities/basic_doctor.dart';
import 'package:elaj/features/customer/categorial_doctors/domain/repositories/categorical_doctors_repository.dart';

class SearchFromCategoricalDoctors
    implements UseCase<List<BasicDoctor>, SearchParams> {
  CategoricalDoctorsRepository repository;

  SearchFromCategoricalDoctors(this.repository);

  @override
  Future<Either<Failure, List<BasicDoctor>>> call(SearchParams params) async {
    return await repository.searchFromCategoricalDoctors(
        params.searchTerm, params.list);
  }
}
