import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/book_appointment/presentation/bloc/bloc/book_appointment_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class ToggleWidget extends StatefulWidget {
  BookAppointmentBloc bookAppointmentBloc;
  final List<String> options;
  final String type, labelText;
  final bool showLabel;

  ToggleWidget(
      {this.type,
      this.options,
      this.bookAppointmentBloc,
      this.showLabel = false,
      this.labelText});

  @override
  _ToggleWidgetState createState() => _ToggleWidgetState();
}

class _ToggleWidgetState extends State<ToggleWidget> {
  bool isFirst;

  @override
  void initState() {
    if (widget.bookAppointmentBloc == null) {
      widget.bookAppointmentBloc = sl<BookAppointmentBloc>();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isFirst == null) isFirst = true;

    return BlocListener(
      bloc: widget.bookAppointmentBloc,
      listener: (context, state) {
        if (state is FetchingData) {
          print("WTFFFF");
          widget.bookAppointmentBloc.add(SaveFetchedValueEvent(
              type: widget.type,
              property: widget.type == "otherGender"
                  ? isFirst ? "M" : "F"
                  : isFirst));
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
                          color: AppColor.DARK_GRAY),
                    ),
                    SizedBox(
                      height: 5,
                    )
                  ],
                )
              : Container(),
          SizedBox(
            height: 45,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (!isFirst) {
                        if (widget.type == "isSelf")
                          widget.bookAppointmentBloc.add(ShowSelfEvent());

                        setState(() {
                          isFirst = true;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: isFirst
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Colors.transparent,
                          border: Border.all(
                              color: isFirst
                                  ? Theme.of(context).primaryColor
                                  : Colors.black.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(3)),
                      child: Center(
                        child: Text(
                          widget.options[0],
                          style: TextStyle(
                              fontSize: 17,
                              fontFamily: Constant.DEFAULT_FONT,
                              color: isFirst
                                  ? Theme.of(context).primaryColor
                                  : Colors.black.withOpacity(0.4)),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (isFirst) {
                        if (widget.type == "isSelf")
                          widget.bookAppointmentBloc.add(ShowOtherEvent());

                        setState(() {
                          isFirst = false;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: !isFirst
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Colors.transparent,
                          border: Border.all(
                              color: !isFirst
                                  ? Theme.of(context).primaryColor
                                  : Colors.black.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(3)),
                      child: Center(
                        child: Text(
                          widget.options[1],
                          style: TextStyle(
                              fontSize: 17,
                              fontFamily: Constant.DEFAULT_FONT,
                              color: !isFirst
                                  ? Theme.of(context).primaryColor
                                  : Colors.black.withOpacity(0.4)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
