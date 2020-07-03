import 'package:elaj/core/entities/user_cred.dart';
import 'package:elaj/core/ui/input_field_widget.dart';
import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/credentials/domain/entities/user_cred_singleton.dart';
import 'package:elaj/features/common/credentials/presentation/bloc/bloc/credentials_bloc.dart';
import 'package:elaj/features/common/credentials/presentation/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInBodyWidget extends StatefulWidget {
  final CredentialsBloc bloc;
  final bool showSignIn;

  SignInBodyWidget({Key key, this.showSignIn, this.bloc}) : super(key: key);

  @override
  _SignInBodyWidgetState createState() => _SignInBodyWidgetState();
}

class _SignInBodyWidgetState extends State<SignInBodyWidget> {
  TextEditingController emailInput = TextEditingController(),
      passInput = TextEditingController();
  bool _hidePass = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        Text(
          'Sign In to continue',
          style: TextStyle(
              fontSize: 18, fontFamily: "Roboto", fontWeight: FontWeight.w500),
        ),
        Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.05,
              left: 15,
              right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              InputWidget(
                hintText: "Email",
                type: "email",
                bloc: widget.bloc,
              ),
              SizedBox(
                height: 15,
              ),
              InputWidget(
                hintText: "Password",
                type: "password",
                bloc: widget.bloc,
                isPass: true,
              ),
              // SizedBox(height: 10),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: GestureDetector(
              //     onTap: () {
              //       // Open ForgotPassword page

              //       // Navigator.of(context).push(MaterialPageRoute(
              //       //     builder: (_) => ForgotPasswordWidget()));
              //     },
              //     child: Text(
              //       'Forgot Password?',
              //       style: TextStyle(
              //           fontSize: 17,
              //           fontFamily: Constant.DEFAULT_FONT,
              //           color: Theme.of(context).primaryColor),
              //     ),
              //   ),
              // ),
              SizedBox(height: 30),
              RaisedButton(
                  elevation: 0.5,
                  color: Theme.of(context).primaryColor,
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: Text(
                      'SIGN IN',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: Constant.DEFAULT_FONT),
                    ),
                  ),
                  onPressed: () {
                    UserCredSingleton userCredSingleton = UserCredSingleton();
                    userCredSingleton.userCred.reset();

                    widget.bloc.add(SaveFetchedValueEvent(
                        type: "isSignIn", property: true));
                    widget.bloc.add(FetchAllDataEvent());
                  }),
              SizedBox(height: MediaQuery.of(context).size.height * 0.063),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Don\'t have an account? ',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: Constant.DEFAULT_FONT,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.bloc.add(ShowRegisterScreenEvent());
                    },
                    child: Text(
                      'Create account',
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: Constant.DEFAULT_FONT,
                          color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
