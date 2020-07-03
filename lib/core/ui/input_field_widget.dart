import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:flutter/material.dart';

class InputFieldWidget extends StatefulWidget {
  final String text, defText, type;
  final bool hasRemoveBtn, isPass;
  final TextEditingController controller;

  InputFieldWidget(
      {Key key,
      this.text = '',
      this.defText,
      this.hasRemoveBtn = false,
      this.type,
      this.controller,
      this.isPass = false})
      : super(key: key);

  @override
  _InputFieldWidgetState createState() => _InputFieldWidgetState();

  TextEditingController get textController {
    return controller;
  }
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  bool _hidePass = true;

  TextInputType getInputType() {
    if (widget.type == 'email') {
      return TextInputType.emailAddress;
    } else if (widget.type == 'password') {
      return TextInputType.visiblePassword;
    } else {
      return TextInputType.text;
    }
  }

  @override
  void initState() {
    widget.controller.text = widget.text;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(children: <Widget>[
          TextField(
            controller: widget.controller,
            keyboardType: getInputType(),
            decoration: InputDecoration(
              labelText: widget.defText,
              labelStyle: TextStyle(fontSize: Constant.DEFAULT_INPUT_FONT_SIZE),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.GRAY, width: 3)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 3)),
              contentPadding:
                  EdgeInsets.fromLTRB(0, 0, Constant.INPUT_ICON_SIZE + 10, 0),
            ),
            obscureText: widget.isPass && _hidePass,
            style: TextStyle(
                fontSize: Constant.DEFAULT_INPUT_FONT_SIZE,
                fontFamily: Constant.DEFAULT_FONT),
          ),
          widget.hasRemoveBtn || widget.isPass
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
        ]),
        // SizedBox(height: 16,),
        // Padding(
        //   padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0),
        //   child: Text("Error Occurred",
        //       style:
        //           TextStyle(fontSize: 12, color: Theme.of(context).errorColor)),
        // )
      ],
    );
  }
}
