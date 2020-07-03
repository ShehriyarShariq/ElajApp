import 'dart:io';

import 'package:elaj/features/common/appointment_session/domain/entities/prescription.dart';
import 'package:elaj/features/common/appointment_session/domain/entities/review.dart';
import 'package:elaj/features/customer/book_appointment/domain/entities/booking.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record.dart';
import 'package:elaj/features/doctor/availability/domain/entities/availability.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AuthParams extends Equatable {
  final dynamic userCred;

  AuthParams({@required this.userCred});

  @override
  List<Object> get props => [userCred];
}

class SearchParams extends Equatable {
  final String searchTerm;
  final List<dynamic> list;

  SearchParams({@required this.searchTerm, @required this.list});

  @override
  List<Object> get props => [searchTerm, list];
}

class MedicalRecordParams extends Equatable {
  final MedicalRecord record;

  MedicalRecordParams({@required this.record});

  @override
  List<Object> get props => [record];
}

class CategoricalDoctorsParams extends Equatable {
  final String lastFetchedDoctorID, categoryID;

  CategoricalDoctorsParams(
      {@required this.lastFetchedDoctorID, @required this.categoryID});

  @override
  List<Object> get props => [lastFetchedDoctorID, categoryID];
}

class AppointmentParams extends Equatable {
  final String appointmentID;
  final int startTime;
  final bool withPenalty;

  AppointmentParams({this.appointmentID, this.startTime, this.withPenalty});

  @override
  List<Object> get props => [appointmentID, startTime];
}

class AvailabilityParams extends Equatable {
  final Availability availability;

  AvailabilityParams({this.availability});

  @override
  List<Object> get props => [availability];
}

class CompleteProfileParams extends Equatable {
  final CompleteDoctor completeDoctor;

  CompleteProfileParams({this.completeDoctor});

  @override
  List<Object> get props => [completeDoctor];
}

class BookingParams extends Equatable {
  final Booking booking;
  final String doctorID;

  BookingParams({this.booking, this.doctorID});

  @override
  List<Object> get props => [booking];
}

class RatingParams extends Equatable {
  final Review rating;

  RatingParams({this.rating});

  @override
  List<Object> get props => [rating];
}

class PrescriptionParams extends Equatable {
  final Prescription prescription;

  PrescriptionParams({this.prescription});

  @override
  List<Object> get props => [prescription];
}

class DoctorProfileParams extends Equatable {
  final String doctorID;

  DoctorProfileParams({this.doctorID});

  @override
  List<Object> get props => [doctorID];
}

class DoctorReviewsParams extends Equatable {
  final String lastFetchedReviewID, categoryID, doctorID;

  DoctorReviewsParams(
      {@required this.lastFetchedReviewID,
      @required this.categoryID,
      @required this.doctorID});

  @override
  List<Object> get props => [lastFetchedReviewID, categoryID, doctorID];
}

class AppFeedbackParams extends Equatable {
  final String title, desc;

  AppFeedbackParams({this.title, this.desc});

  @override
  List<Object> get props => [title, desc];
}
