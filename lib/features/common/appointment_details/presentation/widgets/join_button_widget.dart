import 'dart:async';

import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/appointment_session/presentation/pages/appointment_session.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart';

class JoinButtonWidget extends StatefulWidget {
  final DateTime startTime, endTime;

  const JoinButtonWidget({Key key, this.startTime, this.endTime})
      : super(key: key);

  @override
  _JoinButtonWidgetState createState() => _JoinButtonWidgetState();
}

class _JoinButtonWidgetState extends State<JoinButtonWidget> {
  Timer _sessionStartRemainingTimeTimer, _sessionRemainingTimeTimer;
  String _sessionStartRemainingTime = "", _sessionRemainingTime = "";
  bool _sessionStarted = false;

  @override
  void initState() {
    _startSessionStartRemainingTimeTimer();

    super.initState();
  }

  @override
  void dispose() {
    if (_sessionStartRemainingTimeTimer != null)
      _sessionStartRemainingTimeTimer.cancel();

    if (_sessionRemainingTimeTimer != null) _sessionRemainingTimeTimer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onJoin();
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Join Session",
                  style: TextStyle(
                      fontFamily: Constant.DEFAULT_FONT,
                      color: Colors.white,
                      fontSize: 20),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.12),
                  margin: const EdgeInsets.only(top: 10),
                  child: FittedBox(
                    fit: _sessionStarted ? BoxFit.none : BoxFit.fitWidth,
                    child: Text(
                      _sessionStarted
                          ? "$_sessionRemainingTime"
                          : "$_sessionStartRemainingTime",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: Constant.DEFAULT_FONT,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _startSessionStartRemainingTimeTimer() async {
    const oneSec = const Duration(seconds: 1);
    DateTime startTime = DateTime.now();
    await NTP.getNtpOffset().then((int ntpOffset) {
      startTime = startTime.add(Duration(milliseconds: ntpOffset));
    });
    DateTime endTime = widget.startTime;

    _sessionStartRemainingTimeTimer = new Timer.periodic(oneSec, (timer) {
      setState(() {
        if (endTime.difference(startTime).inSeconds < 1) {
          _sessionStartRemainingTimeTimer.cancel();
          _sessionStarted = true;
          _startSessionRemainingTimeTimer();
        } else {
          startTime = startTime.add(Duration(seconds: 1));
          Duration remTime = endTime.difference(startTime);
          String days = "${remTime.inDays.remainder(365).toString()} day" +
              (remTime.inDays.remainder(365) != 1 ? "s, " : ", ");
          String hours = "${remTime.inHours.remainder(24).toString()} hour" +
              (remTime.inHours.remainder(24) != 1 ? "s, " : ", ");
          String mins = "${remTime.inMinutes.remainder(60).toString()} min" +
              (remTime.inMinutes.remainder(60) != 1 ? "s, " : ", ");
          String secs = "${remTime.inSeconds.remainder(60).toString()} sec" +
              (remTime.inSeconds.remainder(60) != 1 ? "s " : " ");
          _sessionStartRemainingTime = "Starts in $days$hours$mins$secs";
        }
      });
    });
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
          _sessionRemainingTime = "Session has ended";
        } else {
          startTime = startTime.add(Duration(seconds: 1));
          Duration remTime = endTime.difference(startTime);
          String mins = "${remTime.inMinutes.remainder(60).toString()} min" +
              (remTime.inMinutes.remainder(60) != 1 ? "s, " : ", ");
          String secs = "${remTime.inSeconds.remainder(60).toString()} sec" +
              (remTime.inSeconds.remainder(60) != 1 ? "s " : " ");
          _sessionRemainingTime = "Ends in $mins$secs";
        }
      });
    });
  }

  Future<void> onJoin() async {
    bool allGranted = await _handleCameraAndMic();

    if (allGranted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppointmentSession(),
        ),
      );
    }
  }

  Future<bool> _handleCameraAndMic() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.camera, Permission.microphone].request();

    Iterable<Permission> permissions = statuses.keys;
    bool _allGranted = true;
    for (int i = 0; i < statuses.length; i++) {
      if (statuses[permissions.elementAt(i)].isDenied) {
        _allGranted = false;
        Fluttertoast.showToast(
            msg: "Camera/Microphone permission required",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black.withOpacity(0.6),
            textColor: Colors.white,
            fontSize: 17);
        break;
      } else if (statuses[permissions.elementAt(i)].isPermanentlyDenied) {
        _allGranted = false;
        openAppSettings();
        break;
      }
    }

    return _allGranted;
  }
}
