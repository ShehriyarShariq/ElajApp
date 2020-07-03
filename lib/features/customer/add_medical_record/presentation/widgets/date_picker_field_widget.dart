import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/add_medical_record/presentation/bloc/bloc/add_medical_records_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DatePickerFieldWidget extends StatefulWidget {
  final AddMedicalRecordsBloc addMedicalRecordsBloc;
  final String hintText, labelText, type;
  final DateTime prefill;

  const DatePickerFieldWidget(
      {Key key,
      this.addMedicalRecordsBloc,
      this.hintText,
      this.labelText,
      this.type,
      this.prefill})
      : super(key: key);

  @override
  _DatePickerFieldWidgetState createState() => _DatePickerFieldWidgetState();
}

class _DatePickerFieldWidgetState extends State<DatePickerFieldWidget> {
  TextEditingController dateController;
  DateTime selected;
  bool isError = false;

  @override
  void initState() {
    super.initState();

    dateController = TextEditingController();

    if (widget.prefill != null) {
      selected = widget.prefill;
      dateController.text = DateFormat("dd / MM / yyyy").format(selected);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.addMedicalRecordsBloc,
      listener: (context, state) {
        if (state is Fetching) {
          String value = dateController.text.trim();
          if (value != "") {
            isError = false;
            widget.addMedicalRecordsBloc.add(
                SaveFetchedValueEvent(type: widget.type, property: selected));
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
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: isError
                              ? Theme.of(context).errorColor
                              : AppColor.DARK_GRAY),
                      borderRadius: BorderRadius.circular(3)),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextField(
                    controller: dateController,
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
                    style: TextStyle(
                        fontSize: 17, fontFamily: Constant.DEFAULT_FONT),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(3),
                    onTap: () {
                      _showDatePicker();
                    },
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: Icon(
                        Icons.date_range,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
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

  _showDatePicker() {
    DateTime now = DateTime.now();
    showDatePicker(
            context: context,
            initialDate: now,
            firstDate: now.add(Duration(days: -365 * 20)),
            lastDate: new DateTime(now.year, now.month + 1, 0))
        .then((date) {
      DateTime selectedDate = DateTime(date.year, date.month, date.day, 0, 0);

      selected = selectedDate;

      dateController.text = DateFormat("dd / MM / yyyy").format(selectedDate);
    });
  }
}
