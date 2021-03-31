import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/all_appointments/presentation/bloc/bloc/all_appointments_bloc.dart';
import 'package:elaj/features/common/credentials/presentation/bloc/bloc/credentials_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class InputWidget extends StatefulWidget {
  final CredentialsBloc bloc;
  final String hintText, labelText, type;
  final bool isPass;

  InputWidget(
      {this.hintText,
      this.isPass = false,
      this.labelText,
      this.type,
      this.bloc});
  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  TextEditingController textEditingController;
  bool _isError = false;
  bool _hidePass = true;

  @override
  void initState() {
    super.initState();

    textEditingController = TextEditingController();

    textEditingController.addListener(() {
      if (_isError) {
        if (textEditingController.text.length > 0) {
          setState(() {
            _isError = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.bloc,
      listener: (context, state) {
        if (state is Fetching) {
          String value = textEditingController.text.trim();
          if (value != "" || widget.type == 'signUpReferral') {
            if ((widget.type == "password" && !validatePassword(value)) ||
                (widget.type == "email" && !validateEmail(value)) ||
                (widget.type == "phoneNum" && !validatePhoneNum(value))) {
              widget.bloc.add(Reset());
              setState(() {
                _isError = true;
              });
            } else {
              _isError = false;
              widget.bloc.add(
                  SaveFetchedValueEvent(type: widget.type, property: value));
            }
          } else {
            widget.bloc.add(Reset());
            setState(() {
              _isError = true;
            });
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: _isError
                    ? Theme.of(context).errorColor
                    : AppColor.DARK_GRAY),
            borderRadius: BorderRadius.circular(3)),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: TextField(
                controller: textEditingController,
                keyboardType: _getInputType(),
                obscureText: widget.isPass && _hidePass,
                decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                        fontSize: 17,
                        fontFamily: Constant.DEFAULT_FONT,
                        color: _isError
                            ? Theme.of(context).errorColor
                            : AppColor.DARK_GRAY),
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.all(0)),
                style:
                    TextStyle(fontSize: 17, fontFamily: Constant.DEFAULT_FONT),
              ),
            ),
            widget.isPass
                ? Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (widget.isPass) {
                            _hidePass = !_hidePass;
                          }
                        });
                      },
                      child: Icon(
                        _hidePass ? Icons.visibility : Icons.visibility_off,
                        size: Constant.INPUT_ICON_SIZE,
                        color: AppColor.DARK_GRAY,
                      ),
                    ))
                // child: IconButton(
                //   icon: Icon(
                //     _hidePass ? Icons.visibility : Icons.visibility_off,
                //     size: Constant.INPUT_ICON_SIZE,
                //   ),
                //   color: ,
                //   onPressed: () {
                //     setState(() {
                //       if (widget.isPass) {
                //         _hidePass = !_hidePass;
                //       }
                //     });
                //   },
                // ))
                : Container(),
          ],
        ),
      ),
    );
  }

  _getInputType() {
    switch (widget.type) {
      case 'email':
        return TextInputType.emailAddress;
      case 'phoneNum':
        return TextInputType.phone;
      default:
        return TextInputType.text;
    }
  }

  bool validateEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool validatePassword(String password) {
    return RegExp(
            r"^(((?=.*[a-z])(?=.*[A-Z]))|((?=.*[a-z])(?=.*[0-9]))|((?=.*[A-Z])(?=.*[0-9])))(?=.{6,})")
        .hasMatch(password);
  }

  bool validatePhoneNum(String phoneNum) {
    return RegExp(r"^(?:[+0]9)?[0-9]{11}$").hasMatch(phoneNum);
  }
}
