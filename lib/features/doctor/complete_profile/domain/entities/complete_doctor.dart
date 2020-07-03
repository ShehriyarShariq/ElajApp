import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:elaj/features/customer/categorial_doctors/domain/entities/basic_doctor.dart';

class CompleteDoctor {
  BasicDoctor basicDoctor;
  Map<String, String> specialties;
  String id,
      name,
      pmdcNum,
      profileImg,
      liscenseImg,
      degreeImg,
      overview,
      gender;
  CertificationOrExperience certification = CertificationOrExperience(),
      experience = CertificationOrExperience();
  List<Education> education;
  List<EmploymentHistory> employmentHist;
  int rate;
  Location location = Location();
  bool isVerified;

  File profileImgFile, liscenseImgFile, degreeImgFile;

  CompleteDoctor(
      {this.id,
      this.name,
      this.specialties,
      this.pmdcNum,
      this.profileImg,
      this.liscenseImg,
      this.degreeImg,
      this.overview,
      this.certification,
      this.experience,
      this.education,
      this.employmentHist,
      this.rate,
      this.location,
      this.gender,
      this.isVerified});

  factory CompleteDoctor.fromJson(Map<dynamic, dynamic> json) => CompleteDoctor(
      id: json['id'],
      name: json['basic']['name'],
      specialties: Map<String, String>.from(json['basic']['specialty']),
      pmdcNum: json['pmdcNum'].toString(),
      profileImg: json['basic']['picture'],
      liscenseImg: json['license'],
      degreeImg: json['degree'],
      overview: json['overview'],
      certification: CertificationOrExperience.fromJson(
          Map<String, dynamic>.from(json['certification'])),
      experience: CertificationOrExperience.fromJson(
          Map<String, dynamic>.from(json['basic']['experience'])),
      education: _decodeMap(Map<String, Map>.from(json['education']), true)
          .cast<Education>()
          .toList(),
      employmentHist:
          _decodeMap(Map<String, dynamic>.from(json['employmentHist']), false)
              .cast<EmploymentHistory>()
              .toList(),
      rate: json['rate'],
      gender: json['basic']['gender'],
      location: Location.fromJson(Map<String, String>.from(json['location'])),
      isVerified: json['isVerified']);

  Map<String, dynamic> basicJsonMap() {
    return {
      'picture': profileImg,
      'specialty': specialties,
      'experience': experience.toJson(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'pmdcNum': pmdcNum,
      'license': liscenseImg,
      'degree': degreeImg,
      'certification': certification.toJson(),
      'overview': overview,
      'education': _encodeList(education),
      'employmentHist': _encodeList(employmentHist),
      'rate': rate,
      'location': location.toJson()
    };
  }

  static Map<String, dynamic> _encodeList(dynamic list) {
    Map<String, dynamic> map = Map();
    list.forEach((item) {
      map[item.id] = item.toJson();
    });
    return map;
  }

  static List _decodeMap(Map<String, dynamic> map, bool isEducation) {
    List list = List();
    map.forEach((key, value) {
      value['id'] = key;
      list.add(isEducation
          ? Education.fromJson(Map<String, String>.from(value))
          : EmploymentHistory.fromJson(Map<String, String>.from(value)));
    });
    return list;
  }

  bool isFullyInitialized() {
    return isFirstFullyInitialized() &&
        isSecondFullyInitialized() &&
        location.isAllSet();
  }

  bool isFirstFullyInitialized() {
    return (specialties != null && specialties.length != 0) &&
        (pmdcNum != null) &&
        (profileImgFile != null) &&
        (liscenseImgFile != null) &&
        (degreeImgFile != null) &&
        (certification != null && certification.isAllSet()) &&
        (experience != null && experience.isAllSet()) &&
        (overview != null);
  }

  bool isSecondFullyInitialized() {
    return (education != null && education.length != 0) &&
        ((employmentHist != null && employmentHist.length != 0)) &&
        rate != null;
  }
}

class CertificationOrExperience {
  String desc, years;
  Map<String, String> proofImages;
  List<File> imageFiles = List();

  CertificationOrExperience({this.desc, this.years, this.proofImages});

  factory CertificationOrExperience.fromJson(Map<String, dynamic> json) =>
      CertificationOrExperience(
        desc: json['desc'],
        years: json['years'].toString(),
        proofImages: Map<String, String>.from(json['proof']),
      );

  Map<String, dynamic> toJson() {
    return {
      'desc': desc,
      'years': years,
      'proof': proofImages,
    };
  }

  bool isAllSet() {
    return ((desc != null) || (years != null)) &&
        (imageFiles != null && imageFiles.length != 0);
  }
}

class Education {
  String id, institute, degree, startYear, completionYear, cgpa;

  Education(
      {this.id,
      this.institute,
      this.degree,
      this.cgpa,
      this.startYear,
      this.completionYear});

  factory Education.fromJson(Map<String, dynamic> json) => Education(
        id: json['id'],
        institute: json['institute'],
        degree: json['degree'],
        startYear: json['startYear'],
        completionYear: json['completionYear'],
        cgpa: json['cgpa'],
      );

  Map<String, dynamic> toJson() {
    return {
      'institute': institute,
      'degree': degree,
      'cgpa': cgpa,
      'startYear': startYear,
      'completionYear': completionYear
    };
  }

  bool isAllSet() {
    return (institute != null) &&
        (degree != null) &&
        (cgpa != null) &&
        (startYear != null) &&
        (completionYear != null);
  }
}

class EmploymentHistory {
  String id, company, designation, joiningDate, leavingDate;

  EmploymentHistory(
      {this.id,
      this.company,
      this.designation,
      this.joiningDate,
      this.leavingDate});

  factory EmploymentHistory.fromJson(Map<String, dynamic> json) =>
      EmploymentHistory(
          id: json['id'],
          company: json['company'],
          designation: json['designation'],
          joiningDate: json['joiningDate'],
          leavingDate: json['leavingDate']);

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'designation': designation,
      'joiningDate': joiningDate,
      'leavingDate': leavingDate,
    };
  }

  bool isAllSet() {
    return (company != null) &&
        (designation != null) &&
        (joiningDate != null) &&
        (leavingDate != null);
  }
}

class Location {
  String address, city, province, zip, country;

  Location({this.address, this.city, this.province, this.zip, this.country});

  factory Location.fromJson(Map<String, String> json) => Location(
      address: json['address'],
      city: json['city'],
      province: json['province'],
      zip: json['zip'],
      country: json['country']);

  Map<String, String> toJson() {
    return {
      'address': address,
      'city': city,
      'province': province,
      'zip': zip,
      'country': country
    };
  }

  bool isAllSet() {
    return (address != null) &&
        (city != null) &&
        (province != null) &&
        (zip != null) &&
        (country != null);
  }
}
