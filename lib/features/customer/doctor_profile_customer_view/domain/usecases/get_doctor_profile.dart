import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/features/customer/doctor_profile_customer_view/domain/repositories/doctor_profile_customer_view_repository.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';
import '../../../../../core/util/params.dart';

class GetDoctorProfile implements UseCase<CompleteDoctor, DoctorProfileParams> {
  DoctorProfileCustomerViewRepository repository;

  GetDoctorProfile(this.repository);

  @override
  Future<Either<Failure, CompleteDoctor>> call(params) async {
    return await repository.getDoctorProfile(params.doctorID);
  }
}
