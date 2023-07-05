import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sample/Screens/task.dart';
import 'package:sample/Screens/Notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class Home extends StatefulWidget {
  Home({Key? key}) :super (key: key);

  @override
  State<Home> createState() => extraHome();
}

class extraHome extends State<Home> {
  int count = 0;
  late final Notification service;

  final jobList = Job.jobList();
  final addJob = TextEditingController();
  DateTime dateTime = DateTime(1990);
  List<Job> searchBar = [];

  final Stream _myStream =
  Stream.periodic(const Duration(hours: 1), (int count) {
    return count;
  });
  
  late StreamSubscription str;
  

  @override
  void initState() {
    searchBar = jobList;
    sendNotificationAll();
    str = _myStream.listen((event) {
      setState(() {
        sendNotificationAll();
      });
    });
    super.initState();

    Noti.init();
    Noti.notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();

  }

  void listenNotifications() => Noti.onNotifications.stream.listen((event) { });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tasks Alerting App'),
        backgroundColor: Color(0xFF3ac3cb),),
      body: Stack(
          children: [
            Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue, Color(0xFFf85187)])),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    search(),
                    Expanded(
                        child: ListView(
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 20, bottom: 20),
                                child: Text(
                                  'Tasks List :',
                                  style: TextStyle(
                                      fontSize: 30, fontWeight: FontWeight
                                      .w300),
                                )
                            ),
                            for (Job jobb in searchBar.reversed)
                              TaskItem(job: jobb,
                                  taskClick: onTaskBoxClick,
                                  deleteTask: onDeleteClick,
                                  sendNoti: sendNotification,
                              ),
                          ],
                        )
                    )
                  ],
                )
            ),
            Align(alignment: Alignment.bottomCenter,
              child: Row(children: [Expanded(child: Container(
                margin: EdgeInsets.only(bottom: 15, right: 15, left: 15),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: addJob,
                  decoration: InputDecoration(
                      hintText: 'Add a new task',
                      border: InputBorder.none
                  ),
                ),
              )
              ),
                Container(
                  margin: EdgeInsets.only(bottom: 15, right: 15),
                  child: ElevatedButton(
                    child: Text('+', style: TextStyle(fontSize: 30),),
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), padding: EdgeInsets.all(20)),
                    onPressed: () async {
                      final chosenDate = await pickDateAndTime();
                      if (this.dateTime.year > 1999) {
                        addTask(addJob.text, this.dateTime);
                        this.dateTime = new DateTime(1990);
                      }
                    },),
                )
              ]
                ,),)
          ]
      ),
    );
  }

  void addTask(String task, DateTime choseDate) {
    setState(() {
      jobList.add(Job(id: DateTime
          .now()
          .microsecondsSinceEpoch
          .toString(), text: task, date: choseDate));
    });
    addJob.clear();
  }

  Future<DateTime?> dateOnly() =>
      showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100)
      );

  Future<TimeOfDay?> timeOnly() =>
      showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: TimeOfDay
              .now()
              .hour, minute: TimeOfDay
              .now()
              .minute)
      );

  Future pickDateAndTime() async {
    DateTime? dateTime = await dateOnly();
    if (dateTime == null)
      return;

    TimeOfDay? time = await timeOnly();
    if (time == null)
      return;

    final result = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      time.hour,
      time.minute,
    );

    setState(() {
      this.dateTime = result;
    });
  }


  void searchBoxFunction(String s) {
    List<Job> l = [];
    if (s.isEmpty) {
      l = jobList;
    }
    else {
      l = jobList.where((element) =>
          element.text!.toLowerCase().contains(s.toLowerCase())).toList();
    }
    setState(() {
      searchBar = l;
    });
  }

  void onTaskBoxClick(Job job) {
    setState(() {
      job.complete = !job.complete;
    });
  }

  void onDeleteClick(String id) {
    setState(() {
      jobList.removeWhere((element) => element.id == id);
    });
  }

  Widget search() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
      ),
      child: TextField(
        onChanged: (value) => searchBoxFunction(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
            size: 15,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 15,
            minWidth: 20,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  void sendNotification(Job jobb) {
  setState(() {
    if (jobb.complete == false && jobb.date.year == DateTime
        .now()
        .year && jobb.date.month == DateTime
        .now()
        .month && jobb.date.day == DateTime
        .now()
        .day && jobb.date.hour > DateTime.now().hour
        )
      Noti.scheduledNotification( id: count++,
        title: 'Task Due', body: jobb.text, payload: '', d: DateTime.now().add(Duration(seconds: 12)),);
  });


  }

  void sendNotificationAll() {
    for(Job jobb in searchBar.reversed)
      {
        if (jobb.complete == false && jobb.date.year == DateTime
            .now()
            .year && jobb.date.month == DateTime
            .now()
            .month && jobb.date.day == DateTime
            .now()
            .day && jobb.date.hour > DateTime.now().hour
            )
          Noti.scheduledNotification( id: count++,
            title: 'Task Due Today: ', body: jobb.text, payload: '', d: DateTime.now().add(Duration(seconds: 12)),);
      }
  }
}

