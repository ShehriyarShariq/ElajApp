// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'dart:async';
import 'dart:ui';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:elaj/core/firebase/firebase.dart';
import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/ui/overlay_loader.dart' as OverlayLoader;
import 'package:elaj/core/util/agora.dart';
import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/core/util/customer_check_singleton.dart';
import 'package:elaj/features/common/appointment_session/presentation/bloc/bloc/appointment_session_bloc.dart';
import 'package:elaj/features/common/appointment_session/presentation/widgets/appointment_prescription_dialog_content.dart';
import 'package:elaj/features/common/appointment_session/presentation/widgets/appointment_rating_dialog_content.dart';
import 'package:elaj/features/common/appointment_session/presentation/widgets/early_end_session_dialog_content.dart';
import 'package:elaj/features/common/appointment_session/presentation/widgets/session_remaining_time_timer_widget.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record.dart';
import 'package:elaj/features/customer/home_customer/presentation/pages/home_customer.dart';
import 'package:elaj/features/customer/home_customer/presentation/widgets/medical_records_list_item.dart';
import 'package:elaj/features/doctor/home_doctor/presentation/pages/home_doctor.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ntp/ntp.dart';

import '../../../../../injection_container.dart';

class AppointmentSession extends StatefulWidget {
  final String appointmentID;
  final DateTime endTime;
  final List<MedicalRecord> records;

  const AppointmentSession(
      {Key key, this.appointmentID, this.endTime, this.records})
      : super(key: key);

  @override
  _AppointmentSessionState createState() => _AppointmentSessionState();
}

class _AppointmentSessionState extends State<AppointmentSession> {
  AppointmentSessionBloc _appointmentSessionBloc;
  Timer _sessionRemainingTimeTimer;
  bool isToolbarVisible = true,
      muted = false,
      videoDisabled = false,
      isCust,
      isVideoSessionOver = false,
      isSessionEndDialogOpen = false;
  static final _users = <int>[];
  List<AgoraRenderWidget> views = new List<AgoraRenderWidget>();
  StreamSubscription _sessionEndAcknowledgeSubscription;

  @override
  void dispose() {
    // clear users
    _users.clear();

    _sessionEndAcknowledgeSubscription.cancel();

    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    // if (_sessionRemainingTimeTimer != null) _sessionRemainingTimeTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);

    CustomerCheckSingleton customerCheckSingleton =
        new CustomerCheckSingleton();

    isCust = customerCheckSingleton.isCustLoggedIn;

    _appointmentSessionBloc = sl<AppointmentSessionBloc>();

    // initialize agora sdk
    initialize();

    super.initState();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      return;
    }

    List<String> appointmentIDSplit = widget.appointmentID.split("_");
    String id = appointmentIDSplit[3];
    for (int i = 4; i < appointmentIDSplit.length; i++)
      id += appointmentIDSplit[i];

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(null, id, null, 0);
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

  void _getRenderViews() {
    if (views.length == 0) {
      views.add(AgoraRenderWidget(0, local: true, preview: true));
    }

    if (views.length == 1 && _users.length > 0) {
      _users.forEach((int uid) => views.add(AgoraRenderWidget(uid)));
    }
  }

  @override
  Widget build(BuildContext context) {
    _getRenderViews();

    // if (_sessionEndAcknowledgeSubscription == null)
    //   getEarlyEndAcknowledgeStream(
    //           widget.appointmentID, _earlySessionEndAckReq, context)
    //       .then((sub) => _sessionEndAcknowledgeSubscription = sub);

    if (_sessionRemainingTimeTimer == null)
      _startSessionRemainingTimeTimer(context);

    print(views[0] != null && !videoDisabled);
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        body: BlocListener(
          bloc: _appointmentSessionBloc,
          listener: (context, state) {
            if (state is OpenAckDialog) {
              _showEarlyEndSessionDialog();
            } else if (state is DialogOpenError) {
              Fluttertoast.showToast(
                  msg: "Failed to end session",
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.black.withOpacity(0.6),
                  textColor: Colors.white,
                  fontSize: 17);
            } else if (state is Success) {
              Navigator.of(context).popUntil((route) => route.isFirst);

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => isCust ? CustomerHome() : DoctorHome()));
            }
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Container(
                  // color: Colors.black,
                  child: views.length == 2
                      ? views[1]
                      : Container(
                          color: Colors.black.withOpacity(0.6),
                        ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                  child: SessionRemainingTimeTimerWidget(
                    endTime: widget.endTime,
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Waiting for ${!isCust ? "patient" : "doctor"} to connect...",
                      style: TextStyle(
                          color: AppColor.DARK_GRAY,
                          fontSize: 18,
                          fontFamily: Constant.DEFAULT_FONT),
                    ),
                  ),
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
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      color: Colors.white,
                    ),
                    child: views[0] != null ? views[0] : Container(),
                  ),
                ),
                videoDisabled
                    ? Positioned(
                        bottom: isToolbarVisible
                            ? MediaQuery.of(context).size.height * 0.05 +
                                MediaQuery.of(context).size.height * 0.09 +
                                10
                            : 10,
                        right: 0,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: MediaQuery.of(context).size.width *
                                  0.25 *
                                  1.5,
                              margin: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width * 0.05,
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.05),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                color: Colors.grey.shade200.withOpacity(0.8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    size: MediaQuery.of(context).size.width *
                                        0.25 *
                                        0.45,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.25 *
                                                0.05),
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        "Camera Off",
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.7),
                                          fontFamily: Constant.DEFAULT_FONT,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isToolbarVisible = !isToolbarVisible;
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                !isCust
                    ? Positioned(
                        top: MediaQuery.of(context).size.width * 0.03,
                        left: MediaQuery.of(context).size.width * 0.03,
                        child: Material(
                          color: AppColor.DARK_GRAY,
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.075),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * 0.075),
                            onTap: () {
                              _showAllMedicalRecordsDialog(context);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: MediaQuery.of(context).size.width * 0.075,
                              child: Icon(
                                Icons.description,
                                color: AppColor.GRAY,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.05,
                  left: 0,
                  right: 0,
                  child: isToolbarVisible ? _toolbar() : Container(),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  left: 0,
                  child: BlocBuilder(
                    bloc: _appointmentSessionBloc,
                    builder: (context, state) {
                      if (state is OpeningAckDialog) {
                        return OverlayLoader.Overlay();
                      }

                      return Container();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _toolbar() {
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
                  icon: Icons.call_end,
                  color: Colors.red,
                  onPress: _onCallEnd,
                  isVisible: !isCust),
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
      Color color,
      bool isVisible = true}) {
    return GestureDetector(
      onTap: onPress,
      child: isVisible
          ? Container(
              height: !isSideBtn ? height : height * 0.9,
              width: !isSideBtn ? height : height * 0.9,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(height / 2)),
              child: Center(
                child: Icon(
                  isDisabled ? disabledIcon : icon,
                  color: Colors.white,
                  size: height * 0.4,
                ),
              ),
            )
          : SizedBox(
              height: !isSideBtn ? height : height * 0.9,
              width: !isSideBtn ? height : height * 0.9,
            ),
    );
  }

  void _onCallEnd() {
    _showEarlyEndSessionConfirmationDialog(context);
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

      !videoDisabled
          ? AgoraRtcEngine.enableVideo()
          : AgoraRtcEngine.disableVideo();
    });
  }

  _showAllMedicalRecordsDialog(context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: Material(
            child: Container(
              width: MediaQuery.of(context).size.width -
                  MediaQuery.of(context).size.width * 0.07,
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).size.height * 0.15,
              color: AppColor.GRAY,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width * 0.07,
                    color: Theme.of(context).primaryColor,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SizedBox(
                            height: 60,
                            width: 60,
                            child: Icon(
                              Icons.chevron_left,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          "Patient Records",
                          style: TextStyle(
                            fontFamily: Constant.DEFAULT_FONT,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: widget.records.length > 0
                        ? ScrollConfiguration(
                            behavior: NoGlowScrollBehavior(),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                                child: Column(
                                  children: widget.records
                                      .map((record) => MedicalRecordsListItem(
                                            record,
                                            canEdit: false,
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              "No Medical Records Available",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1.3,
                                fontSize: 18,
                                fontFamily: Constant.DEFAULT_FONT,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _showCustomerAppointmentReviewDialog(context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return AppointmentRatingDialogContent(
          _appointmentSessionBloc,
          appointmentID: widget.appointmentID,
          endTime: widget.endTime,
        );
      },
    );
  }

  _showDoctorPrescriptionDialog(context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return AppointmentPrescriptionDialogContent(
          _appointmentSessionBloc,
          appointmentID: widget.appointmentID,
          endTime: widget.endTime,
        );
      },
    );
  }

  _showEarlyEndSessionConfirmationDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are you sure?"),
            content: Text(
              "Are you sure that you want to end the session? Press YES to continue or NO to go back.",
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
                  Navigator.of(context).pop();
                  _appointmentSessionBloc.add(OpenAcknowledgeDialogEvent(
                      appointmentID: widget.appointmentID));
                },
                child: Text("Yes"),
              )
            ],
          );
        });
  }

  _showEarlyEndSessionDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return EarlyEndSessionDialogContent(
          _appointmentSessionBloc,
          appointmentID: widget.appointmentID,
        );
      },
    );
  }

  Future<void> _startSessionRemainingTimeTimer(context) async {
    const oneSec = const Duration(seconds: 1);
    DateTime startTime = DateTime.now();
    await NTP.getNtpOffset().then((int ntpOffset) {
      startTime = startTime.add(Duration(milliseconds: ntpOffset));
    });
    DateTime endTime = widget.endTime.subtract(Duration(minutes: 5));

    _sessionRemainingTimeTimer = new Timer.periodic(oneSec, (timer) {
      if (endTime.difference(startTime).inSeconds < 1) {
        _sessionRemainingTimeTimer.cancel();
        if (isCust) {
          _showCustomerAppointmentReviewDialog(context);
        } else {
          _showDoctorPrescriptionDialog(context);
        }
      } else {
        startTime = startTime.add(Duration(seconds: 1));
      }
    });
  }

  _earlySessionEndAckReq(context, Map<String, bool> data) {
    if (((isCust && data["doctor"]) || !isCust) && !isSessionEndDialogOpen) {
      isSessionEndDialogOpen = true;
      _showEarlyEndSessionConfirmationDialog(context);
    }

    if (data["doctor"] && data["customer"]) {
      // Update end
      isSessionEndDialogOpen = false;
      Navigator.of(context).pop();
      if (isCust) {
        _showCustomerAppointmentReviewDialog(context);
      } else {
        _showDoctorPrescriptionDialog(context);
      }
    } else if (isSessionEndDialogOpen && !data["doctor"]) {
      isSessionEndDialogOpen = false;
      Navigator.of(context).pop();

      if (!isCust) {
        Fluttertoast.showToast(
            msg: "Customer declined session end",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black.withOpacity(0.6),
            textColor: Colors.white,
            fontSize: 17);
      }
    }
  }
}
