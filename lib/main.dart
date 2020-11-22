import 'package:emp_recog_plat/core/firebase/firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'features/splash/presentation/pages/splash.dart';
import 'injection_container.dart' as di;

Future<dynamic> showNotification(Map<String, dynamic> message) async {
  FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidSettings =
      new AndroidInitializationSettings("@mipmap/ic_launcher");
  _localNotificationsPlugin.initialize(new InitializationSettings(
      android: androidSettings, iOS: new IOSInitializationSettings()));

  if (message.containsKey('notification')) {
    AndroidNotificationDetails androidNotifDetails =
        new AndroidNotificationDetails("channelId", "NOTIFICATION", "GENERAL");
    await _localNotificationsPlugin.show(
        0,
        message['notification']['title'],
        message['notification']['body'],
        NotificationDetails(
            android: androidNotifDetails, iOS: new IOSNotificationDetails()));
  }
  return Future<void>.value();
}
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Firebase.initializeApp();
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
        android: androidSettings, iOS: new IOSInitializationSettings()));

    Future.delayed(Duration.zero, () {
      FirebaseInit.fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print(message);
          showNotification(message);
        },
        // onBackgroundMessage: showNotification,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cheerio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(0, 96, 255, 1),
        accentColor: Colors.white,
        errorColor: Color.fromRGBO(254, 95, 85, 1),
      ),
      home: Splash(),
    );
  }
}
