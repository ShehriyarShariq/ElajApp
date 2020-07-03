import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseInit {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final dbRef = FirebaseDatabase.instance.reference();
  static final StorageReference storageRef = FirebaseStorage.instance.ref();
  static final FirebaseMessaging fcm = new FirebaseMessaging();
}
