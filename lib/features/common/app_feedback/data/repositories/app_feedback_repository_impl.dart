import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/firebase/firebase.dart';
import 'package:elaj/core/network/network_info.dart';
import 'package:elaj/features/common/app_feedback/domain/entities/feedback.dart';
import 'package:elaj/features/common/app_feedback/domain/repositories/app_feedback_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppFeedbackRepositoryImpl extends AppFeedbackRepository {
  final NetworkInfo networkInfo;

  AppFeedbackRepositoryImpl({this.networkInfo});

  @override
  Future<Either<Failure, bool>> giveFeedback(String title, String desc) async {
    if (networkInfo.isConnected != null) {
      try {
        FirebaseUser currentUser = await FirebaseInit.auth.currentUser();

        bool isCust = await currentUser.getIdToken(refresh: true).then(
            (idToken) => (idToken.claims.containsKey("customer")
                ? true
                : idToken.claims.containsKey("doctor") ? false : null));

        Feedback feedback =
            Feedback(user: currentUser.uid, title: title, desc: desc);

        await FirebaseInit.dbRef
            .child("appFeedback/" + (isCust ? "customer" : "doctor"))
            .push()
            .set(feedback.toJson());

        return Right(true);
      } catch (e) {
        return Left(ProcessFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
