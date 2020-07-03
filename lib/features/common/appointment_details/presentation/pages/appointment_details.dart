import 'dart:async';

import 'package:elaj/core/util/colors.dart';
import 'package:elaj/features/common/appointment_details/presentation/widgets/join_button_widget.dart';
import 'package:elaj/features/common/appointment_details/presentation/widgets/pay_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import '../../../../../core/ui/loading_widget.dart';
import '../../../../../core/ui/no_glow_scroll_behavior.dart';
import '../../../../../core/ui/overlay_loader.dart' as OverlayLoader;
import '../../../../../core/util/constants.dart';
import '../../../../../injection_container.dart';
import '../../../all_appointments/domain/entities/basic_appointment.dart';
import '../../../appointment_session/presentation/pages/appointment_session.dart';
import '../bloc/bloc/appointment_details_bloc.dart';

class AppointmentDetails extends StatefulWidget {
  final String appointmentID;

  AppointmentDetails({Key key, this.appointmentID}) : super(key: key);

  @override
  _AppointmentDetailsState createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  AppointmentDetailsBloc _appointmentDetailsBloc;
  BasicAppointment appointment;

  @override
  void initState() {
    super.initState();
    _appointmentDetailsBloc = sl<AppointmentDetailsBloc>();

    _appointmentDetailsBloc
        .add(LoadAppointmentEvent(appointmentID: widget.appointmentID));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _appointmentDetailsBloc,
      listener: (context, state) {
        if (state is JoinSessionAllowed) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => AppointmentSession(
                    appointmentID: widget.appointmentID,
                  )));
        } else if (state is CheckedCancellationStatus) {
          _showCancellationStatusDialog(context, state.status);
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              titleSpacing: 0,
              title: Row(
                children: <Widget>[
                  Text(
                    "Appointment",
                    style: TextStyle(
                        fontSize: Constant.TITLE_SIZE,
                        fontFamily: Constant.DEFAULT_FONT),
                  ),
                  BlocBuilder(
                    bloc: _appointmentDetailsBloc,
                    builder: (context, state) {
                      if (!(state is Loading || state is Initial)) {
                        return Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      _showCancellationAccidentalClickDialog(
                                          context);
                                    },
                                    radius: 40,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Icon(
                                        Icons.delete,
                                        color: Theme.of(context).accentColor,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }

                      return Container();
                    },
                  ),
                ],
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                BlocBuilder(
                    bloc: _appointmentDetailsBloc,
                    builder: (context, state) {
                      if (state is Loading || state is Initial) {
                        return Expanded(
                            child: Container(child: LoadingWidget()));
                      } else if (state is Error) {
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
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.8),
                              onPressed: () {
                                _appointmentDetailsBloc.add(
                                    LoadAppointmentEvent(
                                        appointmentID: widget.appointmentID));
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
                        appointment = state.appointment;
                      }

                      return _buildBody();
                    }),
              ],
            ),
          ),
          BlocBuilder(
            bloc: _appointmentDetailsBloc,
            builder: (context, state) {
              if (state is CheckingCancellationStatus || state is Cancelling) {
                return OverlayLoader.Overlay();
              }

              return Container();
            },
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                (MediaQuery.of(context).size.width - 15) *
                                    0.25 /
                                    2),
                            child: Container(
                              width: (MediaQuery.of(context).size.width - 15) *
                                  0.25,
                              height: (MediaQuery.of(context).size.width - 15) *
                                  0.25,
                              color: Colors.white,
                              child: appointment.photoURL == null
                                  ? Image.asset(
                                      appointment?.gender != null
                                          ? appointment.gender == "M"
                                              ? "imgs/doctor_male.png"
                                              : "imgs/doctor_female.png"
                                          : "imgs/patient.png",
                                      fit: BoxFit.cover)
                                  : FadeInImage(
                                      image: NetworkImage(appointment.photoURL),
                                      placeholder: AssetImage(
                                          appointment?.gender != null
                                              ? appointment.gender == "M"
                                                  ? "imgs/doctor_male.png"
                                                  : "imgs/doctor_female.png"
                                              : "imgs/patient.png"),
                                      fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  // Name
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          (appointment.gender != null
                                                  ? "Dr."
                                                  : "") +
                                              appointment.name,
                                          style: TextStyle(
                                              fontFamily: Constant.DEFAULT_FONT,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // For
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: RichText(
                                      overflow: TextOverflow.clip,
                                      softWrap: false,
                                      text: TextSpan(
                                          text: "For: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: Constant.DEFAULT_FONT,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: appointment?.other == null
                                                    ? "Self"
                                                    : "Other",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 17,
                                                ))
                                          ]),
                                    ),
                                  ),

                                  // For Details
                                  appointment.other != null
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: constraints.maxWidth,
                                                child: RichText(
                                                  overflow: TextOverflow.clip,
                                                  softWrap: false,
                                                  text: TextSpan(
                                                      text: "Name: ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: Constant
                                                              .DEFAULT_FONT,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: appointment
                                                                .other.name,
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal))
                                                      ]),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                width: constraints.maxWidth,
                                                child: RichText(
                                                  overflow: TextOverflow.clip,
                                                  softWrap: false,
                                                  text: TextSpan(
                                                      text: "Relation: ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: Constant
                                                              .DEFAULT_FONT,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: appointment
                                                                .other
                                                                .relationShip,
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal))
                                                      ]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: RichText(
                                      overflow: TextOverflow.clip,
                                      softWrap: false,
                                      text: TextSpan(
                                          text: "Date: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: Constant.DEFAULT_FONT,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: _getAppointmentDate(
                                                    appointment.start),
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.normal))
                                          ]),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: RichText(
                                overflow: TextOverflow.clip,
                                softWrap: false,
                                text: TextSpan(
                                    text: "Start: ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: Constant.DEFAULT_FONT,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: _formatTime(appointment.start),
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.normal))
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: RichText(
                                overflow: TextOverflow.clip,
                                softWrap: false,
                                text: TextSpan(
                                    text: "End: ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: Constant.DEFAULT_FONT,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: _formatTime(appointment.end),
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.normal))
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      appointment.gender == null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Note:",
                                    style: TextStyle(
                                        fontFamily: Constant.DEFAULT_FONT,
                                        color: AppColor.DARK_GRAY,
                                        fontSize: 17),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "1. If you haven't paid then after the allowed time your booking will be automatically cancelled.",
                                      style: TextStyle(
                                          height: 1.5,
                                          fontFamily: Constant.DEFAULT_FONT,
                                          color: AppColor.DARK_GRAY,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 80,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  appointment.gender == null && appointment.isPaid
                      ? PayButtonWidget(
                          createdAt: appointment.createdAt,
                        )
                      : JoinButtonWidget(
                          startTime: appointment.start,
                          endTime: appointment.end,
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAppointmentDate(DateTime time) {
    return (DateFormat("dd-MM-yyyy")).format(time.toLocal());
  }

  String _formatTime(DateTime time) {
    return (DateFormat.jm()).format(time.toLocal());
  }

  _showCancellationAccidentalClickDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are you sure?"),
            content: Text(
              "Do you want to cancel your appointment? Press NO to go back or YES to move on.",
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("NO"),
              ),
              FlatButton(
                onPressed: () {
                  _appointmentDetailsBloc.add(CancelBookingStatusCheckEvent());
                  Navigator.of(context).pop();
                },
                child: Text("YES"),
              )
            ],
          );
        });
  }

  _showCancellationStatusDialog(context, Map<String, dynamic> statusMap) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Warning!"),
            content: Text(
              statusMap['message'],
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              !statusMap['isAllowed']
                  ? FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("CANCEL"),
                    )
                  : Row(
                      children: [
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("CANCEL"),
                        ),
                        FlatButton(
                          onPressed: () {
                            _appointmentDetailsBloc.add(CancelBookingEvent());
                            Navigator.of(context).pop();
                          },
                          child: Text("YES"),
                        )
                      ],
                    ),
            ],
          );
        });
  }
}
