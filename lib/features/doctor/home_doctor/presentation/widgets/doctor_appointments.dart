import 'package:elaj/core/ui/loading_widget.dart';
import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';
import 'package:elaj/features/doctor/home_doctor/presentation/bloc/bloc/home_doctor_bloc.dart';
import 'package:elaj/features/doctor/home_doctor/presentation/widgets/date_picker.dart';
import 'package:elaj/features/doctor/home_doctor/presentation/widgets/doctor_appointments_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class DoctorAppointments extends StatefulWidget {
  @override
  _DoctorAppointmentsState createState() => _DoctorAppointmentsState();
}

class _DoctorAppointmentsState extends State<DoctorAppointments> {
  HomeDoctorBloc _homeDoctorBloc;
  DatePickerController _datePickerController = DatePickerController();

  DateTime _selectedDate = DateTime.now();
  DateTime _startDate;

  Map<DateTime, List<BasicAppointment>> appointments = Map();
  List<BasicAppointment> selectedDayAppointments = List(),
      placeholderList = List.filled(3, null, growable: false);

  @override
  void initState() {
    _homeDoctorBloc = sl<HomeDoctorBloc>();

    _homeDoctorBloc.add(GetDoctorAppointmentsEvent());

    _startDate = DateTime.now();
    _startDate = DateTime(_startDate.year, _startDate.month, _startDate.day);
    _selectedDate = _startDate;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        titleSpacing: 20,
        title: Center(
          child: Text("Appointments",
              style: TextStyle(
                  fontSize: Constant.TITLE_SIZE - 2,
                  fontFamily: Constant.DEFAULT_FONT)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: DatePicker(
                _startDate,
                width: 60,
                height: 80,
                controller: _datePickerController,
                initialSelectedDate: DateTime.now(),
                selectionColor: Theme.of(context).primaryColor.withOpacity(0.7),
                selectedTextColor: Colors.white,
                daysCount: 7,
                enabled: true,
                onDateChange: (date) {
                  // New date selected
                  date = DateTime(date.year, date.month, date.day);
                  setState(() {
                    _selectedDate = date;

                    selectedDayAppointments = appointments[_selectedDate];
                  });
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: BlocBuilder<HomeDoctorBloc, HomeDoctorState>(
                  bloc: _homeDoctorBloc,
                  builder: (context, state) {
                    if (state is LoadingAppointments) {
                      return _buildBody(false);
                    } else if (state is Error) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Some error occurred! Try again",
                            style: TextStyle(
                                color: AppColor.DARK_GRAY,
                                fontSize: 22,
                                fontFamily: Constant.DEFAULT_FONT),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FlatButton(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.8),
                            onPressed: () {
                              _homeDoctorBloc.add(GetDoctorAppointmentsEvent());
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                "Try Again",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: Constant.DEFAULT_FONT),
                              ),
                            ),
                          )
                        ],
                      );
                    } else if (state is LoadedAppointments) {
                      appointments = state.appointments;
                      selectedDayAppointments = appointments[_selectedDate];
                    }

                    return _buildBody(true);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody(bool isLoaded) {
    List<BasicAppointment> list =
        isLoaded ? selectedDayAppointments : placeholderList;
    return list == null || list.length == 0
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No Appointments",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColor.DARK_GRAY,
                      fontSize: 22,
                      fontFamily: Constant.DEFAULT_FONT),
                ),
              ],
            ),
          )
        : ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: list
                        .map((appointment) => DoctorAppointmentsListItem(
                              appointment,
                              shimmer: isLoaded,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          );
  }
}
