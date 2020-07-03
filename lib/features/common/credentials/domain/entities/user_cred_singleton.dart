import 'package:elaj/core/entities/user_cred.dart';

class UserCredSingleton {
  static final UserCredSingleton _instance = UserCredSingleton._internal();

  factory UserCredSingleton() => _instance;

  UserCredSingleton._internal() {
    userCred = UserCred();
  }

  UserCred userCred;
}
