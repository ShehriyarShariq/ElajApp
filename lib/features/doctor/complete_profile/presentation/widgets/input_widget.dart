import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/book_appointment/presentation/bloc/bloc/book_appointment_bloc.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/bloc/bloc/complete_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class InputWidget extends StatefulWidget {
  final CompleteProfileBloc bloc;
  final String text, hintText, labelText, type, parentType;
  final bool showLabel, isClear;
  final int pageNum, parentIndex;

  InputWidget(
      {this.hintText,
      this.showLabel = false,
      this.labelText,
      this.type,
      this.bloc,
      this.pageNum,
      this.parentIndex,
      this.isClear,
      this.parentType,
      this.text});
  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  TextEditingController textEditingController;
  bool isError = false;

  @override
  void initState() {
    textEditingController = TextEditingController();

    if (widget.text != null) textEditingController.text = widget.text;

    textEditingController.addListener(() {
      if (isError) {
        if (textEditingController.text.length > 0) {
          setState(() {
            isError = false;
          });
        }
      }
    });

    super.initState();
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
      condition: (previousState, state) {
        return true;
      },
      listener: (context, state) {
        if (widget.parentIndex == null && widget.parentType == null) {
          if (state is Fetching) {
            String value = textEditingController.text.trim();
            if (value != "") {
              isError = false;
              widget.bloc.add(SaveFetchedDataEvent(
                  type: widget.type, property: value, pageNum: widget.pageNum));
            } else {
              widget.bloc.add(ResetEvent());
              setState(() {
                isError = true;
              });
            }
          }
        } else if (state is FetchingChildFieldData) {
          if (widget.type.contains(state.parentType) ||
              widget.parentType == state.parentType) {
            //
            String value = textEditingController.text.trim();
            if (value != "") {
              isError = false;
              widget.bloc.add(SaveFetchedDataToParentEvent(
                  type: widget.type,
                  property: value,
                  parentIndex: widget.parentIndex,
                  parentType: state.parentType));
              widget.bloc.add(ResetEvent());
            } else {
              widget.bloc.add(ResetEvent());
              setState(() {
                isError = true;
              });
            }
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
