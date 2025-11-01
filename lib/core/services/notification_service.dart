import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show UILocalNotificationDateInterpretation;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

typedef NotificationTapCallback = void Function(String taskId);


class NotificationService {
  //create a singleton NotificationService
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationTapCallback? onNotificationTap;

  Future<void> init({NotificationTapCallback? onTap}) async {
    tz.initializeTimeZones();

    onNotificationTap = onTap;

    const AndroidInitializationSettings androidSetting =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSetting =
        DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint("Notification tapped: ${response.payload}");
    // Handle navigation or actions based on notification payload
  }

  Future<void> scheduleDeadlineNotification({
    required int id,
    required String title,
    required String description,
    required DateTime deadline,
  }) async {
    if (Platform.isAndroid) {
      final androidInfo = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.areNotificationsEnabled();

      if (androidInfo == false) {
        return;
      }

      // Kiểm tra exact alarm permission (Android 12+)
      if (await Permission.scheduleExactAlarm.isDenied) {
        await openAppSettings(); // yêu cầu user bật trong Settings
        return;
      }
    }

    final scheduledTime = deadline.subtract(const Duration(minutes: 10));

    if (scheduledTime.isBefore(DateTime.now())) {
      debugPrint('Skipping notification for past time: $title');
      return;
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      description,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_deadline_channel',
          'Task Deadlines',
          channelDescription: 'Notifications for task deadlines',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: id.toString(),
    );
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
