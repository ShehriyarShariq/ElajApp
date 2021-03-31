import 'package:elaj/core/util/customer_check_singleton.dart';
import 'package:elaj/features/common/appointment_details/presentation/pages/appointment_details.dart';
import 'package:elaj/features/common/credentials/presentation/pages/credentials.dart';
import 'package:elaj/features/common/splash/presentation/bloc/bloc/splash_bloc.dart';
import 'package:elaj/features/customer/home_customer/presentation/pages/home_customer.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/pages/doctor_complete_profile.dart';
import 'package:elaj/features/doctor/home_doctor/presentation/pages/home_doctor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SplashBloc _splashBloc;

  @override
  void initState() {
    _splashBloc = sl<SplashBloc>();

    _splashBloc.add(CheckCurrentUserEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _splashBloc,
      listener: (context, state) async {
        if (state is Success) {
          Map<String, bool> map = state.map;

          if (map['isSignedIn']) {
            if (map['isCust']) {
              CustomerCheckSingleton customerCheckSingleton =
                  new CustomerCheckSingleton();

              customerCheckSingleton.isCustLoggedIn = true;

              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => CustomerHome()));
            } else {
              if (map['isCompleteDoctor']) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => DoctorHome()));
              } else {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => DoctorCompleteProfile()));
              }
            }
          } else {
            await Future.delayed(Duration(milliseconds: 500));
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => CustomerHome()));
          }
        } else if (state is Error) {
          await Future.delayed(Duration(milliseconds: 500));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => CustomerHome()));
        }
      },
      child: Container(
        child: Image.asset(
          "imgs/splash.jpeg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
