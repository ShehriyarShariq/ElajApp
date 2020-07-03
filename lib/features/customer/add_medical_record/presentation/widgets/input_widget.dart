import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/add_medical_record/presentation/bloc/bloc/add_medical_records_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class InputWidget extends StatefulWidget {
  final AddMedicalRecordsBloc addMedicalRecordsBloc;
  final String hintText, labelText, type, prefill;
  final bool isOptional;

  InputWidget(
      {this.hintText,
      this.labelText,
      this.type,
      this.addMedicalRecordsBloc,
      this.isOptional = false,
      this.prefill});
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

    if (widget.prefill != null) textEditingController.text = widget.prefill;

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
      bloc: widget.addMedicalRecordsBloc,
      listener: (context, state) {
        if (state is Fetching) {
          String value = textEditingController.text.trim();
          if (value != "" || widget.isOptional) {
            isError = false;
            widget.addMedicalRecordsBloc
                .add(SaveFetchedValueEvent(type: widget.type, property: value));
            widget.addMedicalRecordsBloc.add(ResetEvent());
          } else {
            widget.addMedicalRecordsBloc.add(ResetEvent());
            setState(() {
              isError = true;
            });
          }
        }
      },
      child: Stack(
        overflow: Overflow.visible,
        children: [
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
          Positioned(
            top: -8,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.white,
              child: Text(
                widget.labelText,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: Constant.DEFAULT_FONT,
                    color: isError
                        ? Theme.of(context).errorColor.withOpacity(0.6)
                        : Colors.black.withOpacity(0.3)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
