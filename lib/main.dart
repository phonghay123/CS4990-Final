import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Screens/home.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async{
  tz.initializeTimeZones();
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({Key? key}) :super (key: key);

   @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Tasks Alerting",
      home: Home(),
    );
  }
}