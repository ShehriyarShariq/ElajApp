import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/book_appointment/presentation/bloc/bloc/book_appointment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class DropdownListWidget extends StatefulWidget {
  final List<String> list;
  final String type;

  const DropdownListWidget({Key key, this.list, this.type}) : super(key: key);

  @override
  _DropdownListWidgetState createState() => _DropdownListWidgetState();
}

class _DropdownListWidgetState extends State<DropdownListWidget> {
  BookAppointmentBloc _bookAppointmentBloc;
  String _selectedItem;

  @override
  void initState() {
    _bookAppointmentBloc = sl<BookAppointmentBloc>();
    _selectedItem = widget.list[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _bookAppointmentBloc,
      listener: (context, state) {
        if (state is FetchingData) {
          _bookAppointmentBloc.add(SaveFetchedValueEvent(
              type: widget.type, property: _selectedItem));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Relationship",
            style: TextStyle(
                fontSize: 16,
                fontFamily: Constant.DEFAULT_FONT,
                color: AppColor.DARK_GRAY),
          ),
          SizedBox(
            height: 5,
          ),
          DropdownButton(
            isExpanded: true,
            value: _selectedItem,
            onChanged: (newValue) {
              setState(() {
                _selectedItem = newValue;
              });
            },
            items: widget.list.map((location) {
              return DropdownMenuItem(
                child: Text(
                  location,
                  style: TextStyle(
                      fontSize: 17, fontFamily: Constant.DEFAULT_FONT),
                ),
                value: location,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
