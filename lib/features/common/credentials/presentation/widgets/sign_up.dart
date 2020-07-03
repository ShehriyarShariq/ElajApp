import 'package:elaj/core/entities/user_cred.dart';
import 'package:elaj/core/ui/input_field_widget.dart';
import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/credentials/domain/entities/user_cred_singleton.dart';
import 'package:elaj/features/common/credentials/presentation/bloc/bloc/credentials_bloc.dart';
import 'package:elaj/features/common/credentials/presentation/widgets/input_widget.dart';
import 'package:elaj/features/common/credentials/presentation/widgets/toggle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBodyWidget extends StatefulWidget {
  final CredentialsBloc bloc;

  const SignUpBodyWidget({Key key, this.bloc}) : super(key: key);

  @override
  _SignUpBodyWidgetState createState() => _SignUpBodyWidgetState();
}

class _SignUpBodyWidgetState extends State<SignUpBodyWidget> {
  TextEditingController emailInput = TextEditingController(),
      passInput = TextEditingController(),
      confirmPassInp = TextEditingController();
  bool _hidePass = true, _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Text(
            'Register a new account',
            style: TextStyle(
                fontSize: 18,
                fontFamily: Constant.DEFAULT_FONT,
                fontWeight: FontWeight.w500),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.05,
                  left: 15,
                  right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ToggleWidget(
                    options: ["Customer", "Doctor"],
                    bloc: widget.bloc,
                    type: "isCustomer",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InputWidget(
                    hintText: "First name",
                    type: "firstName",
                    bloc: widget.bloc,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InputWidget(
                    hintText: "Last name",
                    type: "lastName",
                    bloc: widget.bloc,
                  ),
                  SizedBox(
                    height: 15,
                  ),
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
                    isPass: true,
                    bloc: widget.bloc,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0, top: 2.0),
                    child: Text(
                        "Must contain letters and numbers [Length >= 6]",
                        style: TextStyle(
                            fontSize: 14, color: Theme.of(context).errorColor)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InputWidget(
                    hintText: "Phone #",
                    type: "phoneNum",
                    bloc: widget.bloc,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ToggleWidget(
                    options: ["Male", "Female"],
                    bloc: widget.bloc,
                    type: "gender",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InputWidget(
                    hintText: "Referral Code (Optional)",
                    type: "signUpReferral",
                    bloc: widget.bloc,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                      elevation: 0.5,
                      color: Theme.of(context).primaryColor,
                      child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          child: Text(
                            'CREATE ACCOUNT',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: Constant.DEFAULT_FONT),
                          )),
                      onPressed: () {
                        UserCredSingleton userCredSingleton =
                            UserCredSingleton();
                        userCredSingleton.userCred.reset();

                        widget.bloc.add(SaveFetchedValueEvent(
                            type: "isSignIn", property: false));
                        widget.bloc.add(FetchAllDataEvent());
                      }),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                            fontSize: 17, fontFamily: Constant.DEFAULT_FONT),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.bloc.add(ShowSignInScreenEvent());
                          });
                        },
                        child: Text(
                          'Sign In',
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
          ),
        ]),
      ),
    );
  }
}
