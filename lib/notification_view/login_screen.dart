import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            //with image from URL
            id: 12345,
            channelKey: 'image',
            title: 'Simple Notification with Network Image',
            body: 'This simple notification is from Flutter App',
            bigPicture: 'https://www.fluttercampus.com/img/logo_small.webp',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {"name": "flutter"}));
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
