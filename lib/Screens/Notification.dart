import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/src/subjects/behavior_subject.dart';
import 'package:timezone/timezone.dart' as tz;


class Noti{

  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();
  final localNoti = FlutterLocalNotificationsPlugin();

  static Future scheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime d,
}) async =>{
    notifications.zonedSchedule(
      id, title, body,tz.TZDateTime.from(d,tz.local),
      await detail(),
      payload: payload,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,

    ),
    notifications.show(id, title, body, await detail())

  };

  static Future init({ bool Schedule = false}) async{
    final android = AndroidInitializationSettings('assets/icon.png');
    final iOS = DarwinInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);
    await notifications.initialize(
      settings, onDidReceiveNotificationResponse: (payload) async{
        onNotifications.add(payload.toString());
    } );

    //when app is close
    final details = await notifications.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){
      onNotifications.add(details.notificationResponse?.payload);
    }
  }

  static Future detail() async{
    print('why');
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'chanel id',
        'chanel name',
        importance: Importance.max,


      ),
      iOS: DarwinNotificationDetails(),
    );
  }

}