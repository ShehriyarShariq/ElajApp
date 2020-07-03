import 'package:equatable/equatable.dart';

class UserCred extends Equatable {
  String firstName, lastName, email, password, phoneNum, signUpReferral, gender;
  bool isCustomer, isSignIn;

  UserCred(
      {this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.phoneNum,
      this.isCustomer,
      this.gender,
      this.signUpReferral,
      this.isSignIn});

  @override
  List<Object> get props => [
        firstName,
        lastName,
        email,
        password,
        phoneNum,
        signUpReferral,
        isCustomer,
        gender,
        isSignIn
      ];

  bool areValuesFilled() {
    return isSignIn != null
        ? (isSignIn
            ? ((email != null) && (password != null))
            : ((firstName != null) &&
                (lastName != null) &&
                (email != null) &&
                (password != null) &&
                (signUpReferral != null) &&
                (gender != null) &&
                (isCustomer != null)))
        : false;
  }

  void reset() {
    isSignIn = null;
    email = null;
    password = null;
    firstName = null;
    lastName = null;
    email = null;
    password = null;
    signUpReferral = null;
    gender = null;
    isCustomer = null;
  }
}
