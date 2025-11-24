import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

class NotificationService {
  static Future<void> showInstantNotification(String title, String body) async {
    await notificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'med_channel',
          'Medication Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  static Future<void> scheduleNotification(
      String title, String body, DateTime date) async {
    await notificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(date, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'med_channel',
          'Medication Reminders',
          importance: Importance.max,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

