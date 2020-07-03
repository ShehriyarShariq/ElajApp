import 'dart:async';

import 'package:elaj/core/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';

class PayButtonWidget extends StatefulWidget {
  final DateTime createdAt;

  const PayButtonWidget({Key key, this.createdAt}) : super(key: key);

  @override
  _PayButtonWidgetState createState() => _PayButtonWidgetState();
}

class _PayButtonWidgetState extends State<PayButtonWidget> {
  Timer _payRemainingTimeTimer;
  String _payRemainingTime = "";

  @override
  void initState() {
    _startPayRemainingTimeTimer();

    super.initState();
  }

  @override
  void dispose() {
    if (_payRemainingTimeTimer != null) _payRemainingTimeTimer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.8),
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Pay",
                style: TextStyle(
                    fontFamily: Constant.DEFAULT_FONT,
                    color: Colors.white,
                    fontSize: 20),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.15),
                margin: const EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width - 30,
                child: Text(
                  "$_payRemainingTime",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: Constant.DEFAULT_FONT,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startPayRemainingTimeTimer() async {
    const oneSec = const Duration(seconds: 1);
    DateTime startTime = DateTime.now();
    await NTP.getNtpOffset().then((int ntpOffset) {
      startTime = startTime.add(Duration(milliseconds: ntpOffset));
    });
    DateTime endTime = widget.createdAt
        .add(Duration(hours: Constant.MAX_ALLOWED_PAY_TIME_IN_HOURS));

    _payRemainingTimeTimer = new Timer.periodic(oneSec, (timer) {
      setState(() {
        if (endTime.difference(startTime).inSeconds < 1) {
          _payRemainingTimeTimer.cancel();
          _payRemainingTime = "Appointment has been cancelled";
        } else {
          startTime = startTime.add(Duration(seconds: 1));
          Duration remTime = endTime.difference(startTime);
          String mins = "${remTime.inMinutes.remainder(60).toString()} min" +
              (remTime.inMinutes.remainder(60) != 1 ? "s, " : ", ");
          String secs = "${remTime.inSeconds.remainder(60).toString()} sec" +
              (remTime.inSeconds.remainder(60) != 1 ? "s " : " ");
          _payRemainingTime = "$mins$secs left";
        }
      });
    });
  }
}
