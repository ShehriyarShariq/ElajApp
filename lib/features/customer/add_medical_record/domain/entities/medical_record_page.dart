import 'dart:io';

import 'package:equatable/equatable.dart';

class MedicalRecordPage extends Equatable {
  String id, imageURL;
  File imageFile;

  MedicalRecordPage({this.id, this.imageURL, this.imageFile});

  bool isPickedImage() {
    return imageFile != null;
  }

  bool isNull() {
    return imageURL == null && imageFile == null;
  }

  @override
  List<Object> get props => [id, imageURL, imageFile];
}
