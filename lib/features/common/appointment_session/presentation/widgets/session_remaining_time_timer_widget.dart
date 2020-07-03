import 'dart:async';

import 'package:elaj/core/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';

class SessionRemainingTimeTimerWidget extends StatefulWidget {
  final DateTime endTime;

  const SessionRemainingTimeTimerWidget({Key key, this.endTime})
      : super(key: key);

  @override
  _SessionRemainingTimeTimerWidgetState createState() =>
      _SessionRemainingTimeTimerWidgetState();
}

class _SessionRemainingTimeTimerWidgetState
    extends State<SessionRemainingTimeTimerWidget> {
  Timer _sessionRemainingTimeTimer;
  String _sessionRemainingTime = "";

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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7.5),
      width: MediaQuery.of(context).size.width * 0.25,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(5)),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          _sessionRemainingTime,
          style: TextStyle(
            color: Colors.white,
            fontFamily: Constant.DEFAULT_FONT,
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
    DateTime endTime = widget.endTime;

    _sessionRemainingTimeTimer = new Timer.periodic(oneSec, (timer) {
      setState(() {
        if (endTime.difference(startTime).inSeconds < 1) {
          _sessionRemainingTimeTimer.cancel();
          _sessionRemainingTime = "Finished";
        } else {
          startTime = startTime.add(Duration(seconds: 1));
          Duration remTime = endTime.difference(startTime);
          String mins = "${remTime.inMinutes.remainder(60).toString()}";
          String secs = "${remTime.inSeconds.remainder(60).toString()}";
          _sessionRemainingTime = "$mins:$secs";
        }
      });
    });
  }
}
