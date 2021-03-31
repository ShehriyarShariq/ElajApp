import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'features/common/splash/presentation/pages/splash.dart';
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

    // Fireb-dMessage: showNotification);
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
      home: SafeArea(child: Splash()),
    );
  }
}
