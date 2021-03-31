import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record.dart';
import 'package:elaj/features/customer/book_appointment/domain/entities/booking.dart';
import 'package:equatable/equatable.dart';

class BasicAppointment extends Equatable {
  final String id, name, photoURL, status, gender;
  final DateTime start, end, createdAt;
  final bool isPaid;
  final Other other;
  final List<MedicalRecord> medicalRecords;

  BasicAppointment(
      {this.id,
      this.name,
      this.photoURL,
      this.status,
      this.gender,
      this.start,
      this.end,
      this.createdAt,
      this.isPaid = false,
      this.other,
      this.medicalRecords});

  factory BasicAppointment.fromJson(Map<String, dynamic> json) =>
      BasicAppointment(
          id: json['id'],
          name: json['name'],
          photoURL: json['picture'],
          status: json['status'],
          gender: json['gender'],
          start: DateTime.fromMillisecondsSinceEpoch(json['start']),
          end: DateTime.fromMillisecondsSinceEpoch(json['end']),
          createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
          isPaid: json['isPaid'] == null ? false : json['isPaid'],
          other:
              json.containsKey('other') ? Other.fromJson(json['other']) : null,
          medicalRecords: json.containsKey('medicalRecords')
              ? json['medicalRecords'].cast<MedicalRecord>().toList()
              : []);

  @override
  List<Object> get props => [
        id,
        name,
        photoURL,
        start,
        end,
        createdAt,
        status,
        other,
        gender,
        isPaid,
        medicalRecords
      ];
}
