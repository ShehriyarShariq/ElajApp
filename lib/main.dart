import 'package:elaj/features/common/splash/presentation/pages/splash.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'core/firebase/firebase.dart';
import 'features/common/appointment_details/presentation/pages/appointment_details.dart';
import 'features/common/appointment_session/presentation/pages/appointment_session.dart';
import 'injection_container.dart' as di;

Future<dynamic> showNotification(Map<String, dynamic> message) async {
  FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidSettings =
      new AndroidInitializationSettings("@mipmap/ic_launcher");
  _localNotificationsPlugin.initialize(new InitializationSettings(
      androidSettings, new IOSInitializationSettings()));

  if (message.containsKey('notification')) {
    AndroidNotificationDetails androidNotifDetails =
        new AndroidNotificationDetails("channelId", "NOTIFICATION", "GENERAL");
    await _localNotificationsPlugin.show(
        0,
        message['notification']['title'],
        message['notification']['body'],
        NotificationDetails(androidNotifDetails, new IOSNotificationDetails()));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  @override
  void initState() {
    super.initState();

    _localNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidSettings =
        new AndroidInitializationSettings("@mipmap/ic_launcher");
    _localNotificationsPlugin.initialize(new InitializationSettings(
        androidSettings, new IOSInitializationSettings()));

    FirebaseInit.fcm.configure(
        onMessage: (Map<String, dynamic> message) async {},
        onBackgroundMessage: showNotification);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elaj',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(0, 96, 255, 1),
        accentColor: Colors.white,
        errorColor: Color.fromRGBO(254, 95, 85, 1),
      ),
      home: SafeArea(child: AppointmentDetails()),
    );
  }
}
