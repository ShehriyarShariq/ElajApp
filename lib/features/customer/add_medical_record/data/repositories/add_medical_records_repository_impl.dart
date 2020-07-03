import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/firebase/firebase.dart';
import 'package:elaj/core/network/network_info.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record_page.dart';
import 'dart:io';

import 'package:elaj/features/customer/add_medical_record/domain/repositories/add_medical_records_repository.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/medical_records_singleton.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class AddMedicalRecordsRepositoryImpl extends AddMedicalRecordsRepository {
  final NetworkInfo networkInfo;

  AddMedicalRecordsRepositoryImpl({this.networkInfo});

  @override
  Future<Either<Failure, bool>> uploadMedicalRecord(
      MedicalRecord record) async {
    if (networkInfo.isConnected != null) {
      try {
        String uid =
            await FirebaseInit.auth.currentUser().then((user) => user.uid);

        String recordID = record.id ?? FirebaseInit.dbRef.push().key;

        Iterable<String> existingImageIDs = record.images.keys;
        for (int i = 0; i < record.images.length; i++) {
          MedicalRecordPage page = new MedicalRecordPage(
              id: existingImageIDs.elementAt(i),
              imageURL: record.images[existingImageIDs.elementAt(i)]);

          if (!record.pages.contains(page)) {
            await FirebaseInit.storageRef
                .child("customer/" +
                    uid +
                    "/medicalRecord/" +
                    recordID +
                    "/" +
                    page.id +
                    ".jpg")
                .delete();
          }
        }

        Map<String, String> images = new Map();
        for (int i = 0; i < record.pages.length; i++) {
          MedicalRecordPage page = record.pages[i];
          if (page.imageFile != null) {
            String id = randomAlphaNumeric(9);
            File image = page.imageFile;
            StorageUploadTask uploadTask = FirebaseInit.storageRef
                .child("customer/" +
                    uid +
                    "/medicalRecord/" +
                    recordID +
                    "/" +
                    id +
                    ".jpg")
                .putFile(image);
            StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
            String url = (await downloadUrl.ref.getDownloadURL());

            images[id] = url;
          } else {
            images[page.id] = page.imageURL;
          }
        }

        record.images = images;

        await FirebaseInit.dbRef
            .child("customer/" + uid + "/details/medicalRecord/" + recordID)
            .set(record.toJson());

        MedicalRecordsSingleton medicalRecordsSingleton =
            MedicalRecordsSingleton();
        medicalRecordsSingleton.medicalRecords.add(record);

        return Right(true);
      } catch (e) {
        print(e.toString());
        return Left(ProcessFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
