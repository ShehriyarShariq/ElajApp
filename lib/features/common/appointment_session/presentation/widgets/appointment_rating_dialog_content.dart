import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../../../../core/ui/overlay_loader.dart' as OverlayLoader;
import '../../../../../core/util/colors.dart';
import '../../../../../core/util/constants.dart';
import '../../domain/entities/review.dart';
import '../bloc/bloc/appointment_session_bloc.dart';

class AppointmentRatingDialogContent extends StatefulWidget {
  final AppointmentSessionBloc bloc;
  final String appointmentID;
  final DateTime endTime;

  const AppointmentRatingDialogContent(this.bloc,
      {Key key, this.endTime, this.appointmentID})
      : super(key: key);

  @override
  _AppointmentRatingDialogContentState createState() =>
      _AppointmentRatingDialogContentState();
}

class _AppointmentRatingDialogContentState
    extends State<AppointmentRatingDialogContent> {
  String _serviceRatingDesc = "";
  TextEditingController _message = new TextEditingController();
  Timer _sessionRemainingTimeTimer;
  double _rating;
  String _remainingTime = "05:00";
  bool _isBtnEnabled = true;

  @override
  void dispose() {
    if (_sessionRemainingTimeTimer != null) _sessionRemainingTimeTimer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_sessionRemainingTimeTimer == null) _startSessionRemainingTimeTimer();

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
                            margin: const EdgeInsets.only(bottom: 30),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            alignment: Alignment.center,
                            color: Theme.of(context).primaryColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Service Review",
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
                                SmoothStarRating(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.7),
                                  borderColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.2),
                                  size: ((MediaQuery.of(context).size.width -
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07) -
                                          30) /
                                      5.5,
                                  onRated: (rating) {
                                    setState(() {
                                      _rating = rating;
                                      if (rating == 5) {
                                        _serviceRatingDesc = "Excellent";
                                      } else if (rating == 0) {
                                        _serviceRatingDesc = "";
                                      } else if (rating < 1) {
                                        _serviceRatingDesc = "Very Poor";
                                      } else if (rating < 2) {
                                        _serviceRatingDesc = "Poor";
                                      } else if (rating < 3) {
                                        _serviceRatingDesc = "Satisfactory";
                                      } else if (rating < 4) {
                                        _serviceRatingDesc = "Good";
                                      } else if (rating < 5) {
                                        _serviceRatingDesc = "Very Good";
                                      }
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  _serviceRatingDesc,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
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
                                      controller: _message,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                          hintText: "Enter Review Message",
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    widget.bloc.add(GiveAppointmentRatingEvent(
                                      review: Review(
                                        appointmentID: widget.appointmentID,
                                      ),
                                    ));
                                  },
                                  child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Skip",
                                      style: TextStyle(
                                          fontFamily: Constant.DEFAULT_FONT,
                                          fontSize: 17,
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.8)),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  color: Theme.of(context).primaryColor,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        if (_isBtnEnabled) {
                                          if (_rating == null) {
                                            Fluttertoast.showToast(
                                                msg: "Please rate the service",
                                                toastLength: Toast.LENGTH_SHORT,
                                                backgroundColor: Colors.black
                                                    .withOpacity(0.6),
                                                textColor: Colors.white,
                                                fontSize: 17);
                                          } else if (_message.text == "") {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Please give a review of the service",
                                                toastLength: Toast.LENGTH_SHORT,
                                                backgroundColor: Colors.black
                                                    .withOpacity(0.6),
                                                textColor: Colors.white,
                                                fontSize: 17);
                                          } else {
                                            widget.bloc
                                                .add(GiveAppointmentRatingEvent(
                                              review: Review(
                                                  appointmentID:
                                                      widget.appointmentID,
                                                  message: _message.text.trim(),
                                                  star: _rating),
                                            ));
                                          }
                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        width: MediaQuery.of(context)
                                                .size
                                                .width -
                                            MediaQuery.of(context).size.width *
                                                0.07,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Finish",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: Constant.DEFAULT_FONT,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
