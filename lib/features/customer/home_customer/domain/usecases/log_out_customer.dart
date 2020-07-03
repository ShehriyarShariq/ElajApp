import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/features/customer/home_customer/domain/repositories/home_repository.dart';

class LogOutCustomer implements UseCase<bool, NoParams> {
  HomeRepository repository;

  LogOutCustomer(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.logOut();
  }
}
