import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (kIsWeb) {
      debugPrint(
        'Notifications: Running on Web, skipping local notifications initialization.',
      );
      return;
    }

    try {
      tz.initializeTimeZones();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
          );

      await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          debugPrint('Notification tapped: ${details.payload}');
        },
      );
    } catch (e) {
      debugPrint('Notifications Initialization Error: $e');
    }
  }

  static Future<void> requestPermissions() async {
    if (kIsWeb) return;

    try {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin != null) {
        await androidPlugin.requestNotificationsPermission();
      }

      final iosPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      if (iosPlugin != null) {
        await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
    }
  }

  static Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _notificationsPlugin.cancelAll();
  }

  static Future<void> scheduleReminders({
    required String frequency,
    required int customHour,
    required int customMinute,
  }) async {
    if (kIsWeb) {
      debugPrint('Notifications: Scheduled mock reminder on web.');
      return;
    }

    await cancelAll();

    final androidDetails = AndroidNotificationDetails(
      'interview_buddy_reminders',
      'Daily Study Reminders',
      channelDescription: 'Reminders to study interview questions daily',
      importance: Importance.high,
      priority: Priority.high,
    );

    final iosDetails = const DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );


    if (frequency == 'Once daily') {
      await _scheduleAtTime(
        1,
        'Interview Revision Time!',
        'Ready to build your coding streak? Read today\'s revision card!',
        customHour,
        customMinute,
        details,
      );
    } else if (frequency == 'Twice daily') {
      // 9:00 AM and 6:00 PM
      await _scheduleAtTime(
        1,
        'Morning Coding Boost!',
        'Start your morning with a 2-minute interview card!',
        9,
        0,
        details,
      );
      await _scheduleAtTime(
        2,
        'Evening Review!',
        'Quick revision! Review one interview question now.',
        18,
        0,
        details,
      );
    } else if (frequency == 'Three times daily') {
      // 9:00 AM, 2:00 PM, and 8:00 PM
      await _scheduleAtTime(
        1,
        'Morning Boost!',
        'Start your day with a quick revision card!',
        9,
        0,
        details,
      );
      await _scheduleAtTime(
        2,
        'Mid-day Brain Spark!',
        'Take a 2-minute break and learn something new!',
        14,
        0,
        details,
      );
      await _scheduleAtTime(
        3,
        'Night Recap!',
        'Read one final card before sleeping to boost retention!',
        20,
        0,
        details,
      );
    } else {
      // Fallback
      await _scheduleAtTime(
        1,
        'Interview Revision!',
        'Take 2 minutes to study a revision card.',
        customHour,
        customMinute,
        details,
      );
    }
  }

  static Future<void> _scheduleAtTime(
    int id,
    String title,
    String body,
    int hour,
    int minute,
    NotificationDetails details,
  ) async {
    final tz.TZDateTime scheduledDate = _nextInstanceOfTime(hour, minute);
    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint('Scheduled notification ID $id at $hour:$minute');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
