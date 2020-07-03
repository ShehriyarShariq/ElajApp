import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/core/firebase/firebase.dart';
import 'package:elaj/core/network/network_info.dart';
import 'package:elaj/features/common/splash/domain/repositories/splash_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashRepositoryImpl extends SplashRepository {
  final NetworkInfo networkInfo;

  SplashRepositoryImpl({this.networkInfo});

  @override
  Future<Either<Failure, Map<String, bool>>> checkCurrentUser() async {
    if (networkInfo.isConnected != null) {
      try {
        FirebaseUser currentUser = await FirebaseInit.auth.currentUser();
        if (currentUser == null) return Right({'isSignedIn': false});

        bool isCust;
        await currentUser.getIdToken(refresh: true).then((idToken) {
          if (idToken.claims.containsKey("customer"))
            isCust = true;
          else if (idToken.claims.containsKey("doctor")) isCust = false;
        });
        if (isCust == null) throw Exception();

        Map<String, bool> map = Map();

        if (!isCust) {
          await FirebaseInit.dbRef
              .child("doctor/" + currentUser.uid + "/details/pmdcNum")
              .once()
              .then((snapshot) {
            if (snapshot.value == null) {
              map = {
                'isSignedIn': true,
                'isCust': false,
                'isCompleteDoctor': false
              };
            } else {
              map = {
                'isSignedIn': true,
                'isCust': false,
                'isCompleteDoctor': true
              };
            }
          });

          return Right(map);
        } else {
          return Right({'isSignedIn': true, 'isCust': isCust});
        }
      } catch (e) {
        return Left(AuthFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
