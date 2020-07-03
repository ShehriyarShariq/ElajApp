// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:elaj/core/util/agora.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';

class AppointmentSession extends StatefulWidget {
  final String appointmentID;
  final DateTime endTime;

  const AppointmentSession({Key key, this.appointmentID = "abc", this.endTime})
      : super(key: key);

  @override
  _AppointmentSessionState createState() => _AppointmentSessionState();
}

class _AppointmentSessionState extends State<AppointmentSession> {
  Timer _sessionRemainingTimeTimer;
  bool isToolbarVisible = true, muted = false, videoDisabled = false;
  static final _users = <int>[];

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();

    if (_sessionRemainingTimeTimer != null) _sessionRemainingTimeTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _startSessionRemainingTimeTimer();

    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(null, widget.appointmentID, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {};

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {};

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {};
  }

  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final views = _getRenderViews();
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            isToolbarVisible = !isToolbarVisible;
          });
        },
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    // color: Colors.black,
                    child: views.length == 2 ? views[1] : Container(),
                  ),
                  Positioned(
                    bottom: isToolbarVisible
                        ? MediaQuery.of(context).size.height * 0.05 +
                            MediaQuery.of(context).size.height * 0.09 +
                            10
                        : 10,
                    right: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.width * 0.25 * 1.5,
                      margin: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.05,
                          bottom: MediaQuery.of(context).size.width * 0.05),
                      color: Colors.white,
                      child: views[0] != null ? views[0] : Container(),
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.05,
                    left: 0,
                    right: 0,
                    child: isToolbarVisible ? _toolbar(context) : Container(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _toolbar(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _toolbarButton(constraints.maxHeight,
                  isSideBtn: true,
                  icon: Icons.videocam,
                  disabledIcon: Icons.videocam_off,
                  onPress: _onToggleVideo,
                  isDisabled: videoDisabled),
              _toolbarButton(constraints.maxHeight,
                  icon: Icons.call_end, color: Colors.red, onPress: _onCallEnd),
              _toolbarButton(constraints.maxHeight,
                  isSideBtn: true,
                  icon: Icons.mic,
                  disabledIcon: Icons.mic_off,
                  onPress: _onToggleMute)
            ],
          );
        },
      ),
    );
  }

  Widget _toolbarButton(num height,
      {IconData icon,
      IconData disabledIcon,
      Function onPress,
      bool isSideBtn = false,
      bool isDisabled = false,
      Color color}) {
    return Container(
      height: !isSideBtn ? height : height * 0.9,
      width: !isSideBtn ? height : height * 0.9,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(height / 2)),
      child: Center(
        child: Icon(
          isDisabled ? disabledIcon : icon,
          color: Colors.white,
          size: height * 0.4,
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onToggleVideo() {
    setState(() {
      videoDisabled = !videoDisabled;
    });
    videoDisabled
        ? AgoraRtcEngine.enableVideo()
        : AgoraRtcEngine.disableVideo();
  }

  _showAfterSessionCustomerReviewDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Session Finished"),
            content: Text(
              "Do you want to cancel your appointment? Press NO to go back or YES to move on.",
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Done"),
              ),
            ],
          );
        });
  }

  Future<void> _startSessionRemainingTimeTimer() async {
    const oneSec = const Duration(seconds: 1);
    DateTime startTime = DateTime.now();
    await NTP.getNtpOffset().then((int ntpOffset) {
      startTime = startTime.add(Duration(milliseconds: ntpOffset));
    });
    DateTime endTime = DateTime.now().add(Duration(minutes: 2));
    // widget.endTime;

    _sessionRemainingTimeTimer = new Timer.periodic(oneSec, (timer) {
      if (endTime.difference(startTime).inSeconds < 1) {
        _sessionRemainingTimeTimer.cancel();
        // _sessionRemainingTime = "Session has ended";
      } else {
        startTime = startTime.add(Duration(seconds: 1));
      }
    });
  }
}
