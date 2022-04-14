import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification/main.dart';
import 'package:flutter_notification/notification_view/second_page.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        // largeIcon: const DrawableResourceAndroidBitmap('sample_large_icon'),
        styleInformation: DefaultStyleInformation(true, true),
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(settings, onSelectNotification: (payload) {
      onNotifications.add(payload);
    });
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
  }) async =>
      _notifications.show(id, title, body, await _notificationDetails(),
          payload: payLoad);

  @override
  void initState() {
    // TODO: implement initState
    init();
    listenNotifications();
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher'),
          ),
        );
      }
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                notification!.title!,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              Text(
                notification.body!,
                style: TextStyle(color: Colors.black, fontSize: 10),
              )
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          dismissDirection: DismissDirection.up,
        ));

        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  void listenNotifications() =>
      onNotifications.stream.listen(onClickNotification);
  void onClickNotification(String? payLoad) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => SecondPage()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        height: double.infinity,
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 40),
              TextFormField(
                controller: emailcontroller,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: passwordcontroller,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Sign in'),
              ),
              MaterialButton(
                onPressed: () {},
                child: const Text('Do not have account'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
