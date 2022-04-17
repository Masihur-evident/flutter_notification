import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_notification/model/local_push_notification.dart';
import 'package:flutter_notification/notification_view/login_screen.dart';

import 'notification_view/second_page.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "high_performance_channel", "High Importance Notification",
    description: "This Channel is used for important notification",
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

//  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'image_tests',
            channelKey: 'big_picture',
            channelName: 'Big pictures',
            channelDescription: 'Notification channel for big pictures',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white,
            channelShowBadge: true,
            defaultRingtoneType: DefaultRingtoneType.Ringtone,
            playSound: true,
            enableLights: true,
            enableVibration: true,
            importance: NotificationImportance.High),
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'image_tests', channelGroupName: 'Images tests'),
      ],
      debug: true);

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {
      Navigator.of(context).pushNamed('/NotificationPage', arguments: {
        // your page params. I recommend you to pass the
        // entire *receivedNotification* object
        receivedNotification.id,

        print(' fffffffffffffffffff${receivedNotification.id}'),
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        SecondPage.id: (context) => const SecondPage(),
      },
      home: const LoginScreen(),
    );
  }
}
