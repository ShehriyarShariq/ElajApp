import 'dart:async';

import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/core/util/customer_check_singleton.dart';
import 'package:elaj/features/common/appointment_session/domain/entities/review.dart';
import 'package:elaj/features/common/appointment_session/presentation/bloc/bloc/appointment_session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntp/ntp.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:intl/intl.dart';
import 'package:elaj/core/ui/overlay_loader.dart' as OverlayLoader;

class EarlyEndSessionDialogContent extends StatefulWidget {
  final AppointmentSessionBloc bloc;
  final String appointmentID;

  const EarlyEndSessionDialogContent(this.bloc, {Key key, this.appointmentID})
      : super(key: key);

  @override
  _EarlyEndSessionDialogContentState createState() =>
      _EarlyEndSessionDialogContentState();
}

class _EarlyEndSessionDialogContentState
    extends State<EarlyEndSessionDialogContent> {
  // Timer _acknowledgeRemainingTimeTimer;
  // String _remainingTime = "05:00";
  bool _isCust;

  @override
  void initState() {
    // _startAcknowledgeRemainingTimeTimer();

    CustomerCheckSingleton customerCheckSingleton =
        new CustomerCheckSingleton();
    _isCust = customerCheckSingleton.isCustLoggedIn;

    super.initState();
  }

  // @override
  // void dispose() {
  //   if (_acknowledgeRemainingTimeTimer != null)
  //     _acknowledgeRemainingTimeTimer.cancel();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          width: MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width * 0.07,
          height: MediaQuery.of(context).size.height * 0.5,
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
                          alignment: Alignment.center,
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            "End Session?",
                            style: TextStyle(
                              fontFamily: Constant.DEFAULT_FONT,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width -
                                MediaQuery.of(context).size.width * 0.07,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            alignment: Alignment.center,
                            child: Text(
                              _isCust
                                  ? "Doctor wants to end the session early. Press ACCEPT if you want to end the session or DECLINE to keep it going on."
                                  : "You have started a request to end the session early. Please wait for the customer to make their decision.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1.2,
                                fontFamily: Constant.DEFAULT_FONT,
                                fontSize: 19,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width -
                              MediaQuery.of(context).size.width * 0.07,
                          margin: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  child: InkWell(
                                    onTap: () {
                                      widget.bloc.add(AcknowledgeEarlyEndEvent(
                                          appointmentID: widget.appointmentID,
                                          isEnd: false));
                                    },
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Theme.of(context).errorColor),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Decline",
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).errorColor,
                                              fontSize: 18,
                                              fontFamily: Constant.DEFAULT_FONT,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Material(
                                  color: Colors.green.shade400,
                                  borderRadius: BorderRadius.circular(5),
                                  child: InkWell(
                                    onTap: () {
                                      widget.bloc.add(AcknowledgeEarlyEndEvent(
                                          appointmentID: widget.appointmentID,
                                          isEnd: true));
                                    },
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          "Accept",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: Constant.DEFAULT_FONT,
                                              fontWeight: FontWeight.bold),
                                        ),
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

  // Future<void> _startAcknowledgeRemainingTimeTimer() async {
  //   const oneSec = const Duration(seconds: 1);
  //   DateTime startTime = DateTime.now();
  //   await NTP.getNtpOffset().then((int ntpOffset) {
  //     startTime = startTime.add(Duration(milliseconds: ntpOffset));
  //   });
  //   DateTime endTime = startTime.add(Duration(seconds: 10));

  //   _acknowledgeRemainingTimeTimer = new Timer.periodic(oneSec, (timer) {
  //     setState(() {
  //       if (endTime.difference(startTime).inSeconds < 1) {
  //         _acknowledgeRemainingTimeTimer.cancel();
  //       } else {
  //         startTime = startTime.add(Duration(seconds: 1));
  //         Duration remTime = endTime.difference(startTime);
  //         _remainingTime = "${remTime.inSeconds}s";
  //       }
  //     });
  //   });
  // }
}
