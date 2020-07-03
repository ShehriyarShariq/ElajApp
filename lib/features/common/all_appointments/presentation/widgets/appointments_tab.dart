import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';
import 'package:elaj/features/common/all_appointments/presentation/bloc/bloc/all_appointments_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'appointments_list_item.dart';

class AppointmentsTab extends StatefulWidget {
  final AllAppointmentsBloc allAppointmentsBloc;
  final bool isCurrent;

  const AppointmentsTab({Key key, this.isCurrent, this.allAppointmentsBloc})
      : super(key: key);

  @override
  _AppointmentsTabState createState() => _AppointmentsTabState();
}

class _AppointmentsTabState extends State<AppointmentsTab> {
  List<BasicAppointment> appointments,
      placeholderList = List.filled(5, null, growable: false);

  @override
  void initState() {
    widget.allAppointmentsBloc.add(widget.isCurrent
        ? GetAllCurrentAppointmentsEvent()
        : GetAllPastAppointmentsEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.GRAY,
      height: MediaQuery.of(context).size.height,
      child: BlocBuilder(
          bloc: widget.allAppointmentsBloc,
          builder: (context, state) {
            if (state is Error) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Some error occurred!",
                    style: TextStyle(
                        color: AppColor.DARK_GRAY,
                        fontSize: 22,
                        fontFamily: Constant.DEFAULT_FONT),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                    onPressed: () {
                      widget.allAppointmentsBloc.add(widget.isCurrent
                          ? GetAllCurrentAppointmentsEvent()
                          : GetAllPastAppointmentsEvent());
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
            } else if (state is Loaded) {
              appointments = state.appointments;

              if (appointments.length == 0)
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      widget.isCurrent
                          ? "No current appointments found"
                          : "No past appointments found",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: Constant.DEFAULT_FONT,
                          color: Colors.black.withOpacity(0.6)),
                    ),
                  ],
                );
            }

            return ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                  child: Column(
                      children: appointments != null
                          ? appointments
                              .map((appointment) =>
                                  AppointmentsListItem(appointment))
                              .toList()
                          : placeholderList
                              .map((appointment) => AppointmentsListItem(
                                    appointment,
                                    shimmer: false,
                                  ))
                              .toList()),
                ),
              ),
            );
          }),
    );
  }
}
