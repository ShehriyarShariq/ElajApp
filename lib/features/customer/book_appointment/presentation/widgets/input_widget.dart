import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/book_appointment/presentation/bloc/bloc/book_appointment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class InputWidget extends StatefulWidget {
  final BookAppointmentBloc bookAppointmentBloc;
  final String hintText, labelText, type;
  final bool showLabel;

  InputWidget(
      {this.hintText,
      this.showLabel = false,
      this.labelText,
      this.type,
      this.bookAppointmentBloc});
  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  TextEditingController textEditingController;
  bool isError = false;

  @override
  void initState() {
    super.initState();

    textEditingController = TextEditingController();

    textEditingController.addListener(() {
      if (isError) {
        if (textEditingController.text.length > 0) {
          setState(() {
            isError = false;
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
      bloc: widget.bookAppointmentBloc,
      listener: (context, state) {
        if (state is FetchingData) {
          String value = textEditingController.text.trim();
          if (value != "") {
            isError = false;
            widget.bookAppointmentBloc
                .add(SaveFetchedValueEvent(type: widget.type, property: value));
          } else {
            setState(() {
              isError = true;
            });
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.showLabel
              ? Column(
                  children: [
                    Text(
                      widget.labelText,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: Constant.DEFAULT_FONT,
                          color: isError
                              ? Theme.of(context).errorColor
                              : AppColor.DARK_GRAY),
                    ),
                    SizedBox(
                      height: 5,
                    )
                  ],
                )
              : Container(),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: isError
                        ? Theme.of(context).errorColor
                        : AppColor.DARK_GRAY),
                borderRadius: BorderRadius.circular(3)),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextField(
              controller: textEditingController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                      fontSize: 17,
                      fontFamily: Constant.DEFAULT_FONT,
                      color: isError
                          ? Theme.of(context).errorColor
                          : AppColor.DARK_GRAY),
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.all(0)),
              style: TextStyle(fontSize: 17, fontFamily: Constant.DEFAULT_FONT),
            ),
          ),
        ],
      ),
    );
  }
}
