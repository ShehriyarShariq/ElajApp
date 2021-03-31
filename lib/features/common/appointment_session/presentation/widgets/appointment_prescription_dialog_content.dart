import 'dart:async';

import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/appointment_session/domain/entities/prescription.dart';
import 'package:elaj/features/common/appointment_session/presentation/bloc/bloc/appointment_session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ntp/ntp.dart';
import 'package:intl/intl.dart';
import 'package:elaj/core/ui/overlay_loader.dart' as OverlayLoader;

class AppointmentPrescriptionDialogContent extends StatefulWidget {
  final AppointmentSessionBloc bloc;
  final String appointmentID;
  final DateTime endTime;

  const AppointmentPrescriptionDialogContent(this.bloc,
      {Key key, this.endTime, this.appointmentID})
      : super(key: key);

  @override
  _AppointmentPrescriptionDialogContentState createState() =>
      _AppointmentPrescriptionDialogContentState();
}

class _AppointmentPrescriptionDialogContentState
    extends State<AppointmentPrescriptionDialogContent> {
  TextEditingController _prescription = new TextEditingController();
  Timer _sessionRemainingTimeTimer;
  String _remainingTime = "05:00";
  bool _isBtnEnabled = true;

  @override
  void initState() {
    _startSessionRemainingTimeTimer();

    super.initState();
  }

  @override
  void dispose() {
    if (_sessionRemainingTimeTimer != null) _sessionRemainingTimeTimer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          width: MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width * 0.07,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).size.height * 0.15,
          color: AppColor.GRAY,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width -
                                MediaQuery.of(context).size.width * 0.07,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            color: Theme.of(context).primaryColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Prescription",
                                  style: TextStyle(
                                    fontFamily: Constant.DEFAULT_FONT,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.timelapse, color: Colors.white),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      _remainingTime,
                                      style: TextStyle(
                                        fontFamily: Constant.DEFAULT_FONT,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width -
                                MediaQuery.of(context).size.width * 0.07,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                Text(
                                  "Prescribe any necessary medications to the customer",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 18,
                                      fontFamily: Constant.DEFAULT_FONT),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColor.DARK_GRAY),
                                        borderRadius: BorderRadius.circular(3)),
                                    padding: const EdgeInsets.all(5),
                                    child: TextField(
                                      controller: _prescription,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                          hintText: "Enter Prescription",
                                          hintStyle: TextStyle(
                                              fontSize: 17,
                                              fontFamily: Constant.DEFAULT_FONT,
                                              color: AppColor.DARK_GRAY),
                                          disabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.all(0)),
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: Constant.DEFAULT_FONT,
                                          height: 1.5),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                          color: Theme.of(context).primaryColor,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (_isBtnEnabled) {
                                  if (_prescription.text == "") {
                                    Fluttertoast.showToast(
                                        msg: "Please write a prescription",
                                        toastLength: Toast.LENGTH_SHORT,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.6),
                                        textColor: Colors.white,
                                        fontSize: 17);
                                  } else {
                                    widget.bloc.add(GivePrescriptionEvent(
                                        prescription: Prescription(
                                            appointmentID: widget.appointmentID,
                                            message: _prescription.text)));
                                  }
                                }
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width -
                                    MediaQuery.of(context).size.width * 0.07,
                                alignment: Alignment.center,
                                child: Text(
                                  "Finish",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: Constant.DEFAULT_FONT,
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              BlocBuilder(
                bloc: widget.bloc,
                builder: (context, state) {
                  if (state is Rating) {
                    return OverlayLoader.Overlay();
                  }

                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startSessionRemainingTimeTimer() async {
    const oneSec = const Duration(seconds: 1);
    DateTime startTime = DateTime.now();
    await NTP.getNtpOffset().then((int ntpOffset) {
      startTime = startTime.add(Duration(milliseconds: ntpOffset));
    });
    DateTime endTime = startTime.add(Duration(minutes: 5)); // widget.endTime;

    _sessionRemainingTimeTimer = new Timer.periodic(oneSec, (timer) {
      setState(() {
        if (endTime.difference(startTime).inSeconds < 1) {
          _sessionRemainingTimeTimer.cancel();
          _remainingTime = "Finished";
        } else {
          startTime = startTime.add(Duration(seconds: 1));
          Duration remTime = endTime.difference(startTime);
          _remainingTime = DateFormat("hh:mm").format(DateTime(
              0,
              1,
              1,
              remTime.inMinutes.remainder(60),
              remTime.inSeconds.remainder(60)));
        }
      });
    });
  }
}
