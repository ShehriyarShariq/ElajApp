import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/credentials/presentation/bloc/bloc/credentials_bloc.dart';
import 'package:elaj/features/common/credentials/presentation/widgets/sign_in.dart';
import 'package:elaj/features/common/credentials/presentation/widgets/sign_up.dart';
import 'package:elaj/features/customer/home_customer/presentation/pages/home_customer.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/pages/doctor_complete_profile.dart';
import 'package:elaj/features/doctor/home_doctor/presentation/pages/home_doctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class Credentials extends StatefulWidget {
  final bool isFromCustHome;

  const Credentials({Key key, this.isFromCustHome = false}) : super(key: key);

  @override
  _CredentialsState createState() => _CredentialsState();
}

class _CredentialsState extends State<Credentials> {
  CredentialsBloc _credentialsBloc;

  bool _isCurrentSignIn;

  @override
  void initState() {
    _credentialsBloc = sl<CredentialsBloc>();
    _isCurrentSignIn = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.isFromCustHome) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => CustomerHome()));
        }

        return Future.value(true);
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: SingleChildScrollView(
              child: Builder(builder: (context) {
                return Column(children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.12,
                          bottom: 50),
                      child: Image.asset("imgs/logo_alt.jpeg")),
                  BlocListener<CredentialsBloc, CredentialsState>(
                      bloc: _credentialsBloc,
                      listener: (context, state) {
                        if (state is Success) {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);

                          Map<String, bool> map = state.map;

                          if (map['isCust']) {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (_) => CustomerHome(
                                          isCustomer: true,
                                        )));
                          } else {
                            if (map['isCompleteDoctor']) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => DoctorHome()));
                            } else {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => DoctorCompleteProfile()));
                            }
                          }
                        } else if (state is Error) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            duration: Duration(milliseconds: 500),
                            content: Text(state.msg,
                                style: TextStyle(
                                    fontFamily: Constant.DEFAULT_FONT)),
                          ));
                        } else if (state is SignIn) {
                          setState(() {
                            _isCurrentSignIn = true;
                          });
                        } else if (state is Register) {
                          setState(() {
                            _isCurrentSignIn = false;
                          });
                        }
                      },
                      child: _isCurrentSignIn
                          ? SignInBodyWidget(bloc: _credentialsBloc)
                          : SignUpBodyWidget(bloc: _credentialsBloc))
                ]);
              }),
            ),
          ),
        ),
      ),
    );
  }
}
