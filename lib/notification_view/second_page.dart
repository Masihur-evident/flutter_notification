import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  static final String id = "NotificationPage";
  const SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("SecondPge")),
    );
  }
}
