import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record_page.dart';

class MedicalRecord {
  String id, desc, doctorName, doctorSpecialty;
  DateTime date;
  Map<String, String> images;
  List<MedicalRecordPage> pages;

  MedicalRecord(
      {this.id,
      this.desc,
      this.date,
      this.doctorName,
      this.doctorSpecialty,
      this.images});

  factory MedicalRecord.fromJson(Map<String, dynamic> json) => MedicalRecord(
      id: json["id"],
      desc: json["desc"],
      date: DateTime.fromMillisecondsSinceEpoch(json["date"]),
      doctorName: json["doctorName"],
      doctorSpecialty: json["doctorSpecialty"],
      images: Map<String, String>.from(json['images']));

  Map<String, dynamic> toJson() {
    return {
      'desc': desc,
      'date': date.millisecondsSinceEpoch,
      'doctorName': doctorName.length == 0 ? null : doctorName,
      'doctorSpecialty': doctorSpecialty.length == 0 ? null : doctorSpecialty,
      'images': images
    };
  }

  bool isFullyInitialized() {
    return (desc != null) &&
        (date != null) &&
        (doctorName != null) &&
        (doctorSpecialty != null) &&
        (pages != null && pages.length > 0);
  }

  void reset() {
    desc = null;
    date = null;
    doctorName = null;
    doctorSpecialty = null;
    pages = null;
    images = null;
  }
}
