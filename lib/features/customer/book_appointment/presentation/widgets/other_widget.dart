import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/book_appointment/presentation/bloc/bloc/book_appointment_bloc.dart';
import 'package:elaj/features/customer/book_appointment/presentation/widgets/dropdown_list_widget.dart';
import 'package:elaj/features/customer/book_appointment/presentation/widgets/input_widget.dart';
import 'package:elaj/features/customer/book_appointment/presentation/widgets/toggle_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../injection_container.dart';

class OtherWidget extends StatefulWidget {
  final BookAppointmentBloc bookAppointmentBloc;

  const OtherWidget({Key key, this.bookAppointmentBloc}) : super(key: key);

  @override
  _OtherWidgetState createState() => _OtherWidgetState();
}

class _OtherWidgetState extends State<OtherWidget> {
  TextEditingController otherNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputWidget(
          bookAppointmentBloc: widget.bookAppointmentBloc,
          hintText: "Enter your name",
          showLabel: true,
          labelText: "Name",
          type: "otherName",
        ),
        SizedBox(
          height: 20,
        ),
        DropdownListWidget(
          list: ["Spouse", "Child", "Parent", "Other"],
        ),
        SizedBox(
          height: 20,
        ),
        ToggleWidget(
            type: "otherGender",
            options: ["Male", "Female"],
            showLabel: true,
            labelText: "Gender",
            bookAppointmentBloc: widget.bookAppointmentBloc)
      ],
    );
  }
}
