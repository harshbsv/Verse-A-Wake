import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/alarm.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped with payload: ${response.payload}');
  }

  Future<void> scheduleAlarm(Alarm alarm) async {
    if (!alarm.isActive) return;

    const androidDetails = AndroidNotificationDetails(
      'alarm_channel_id',
      'Alarms',
      channelDescription: 'Channel for alarm clock notifications',
      importance: Importance.max,
      priority: Priority.high,
      sound: UriAndroidNotificationSound(
        'content://settings/system/alarm_alert',
      ),
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,

      sound: 'default',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    if (alarm.repeatDays.isEmpty) {
      await _scheduleOneTimeAlarm(alarm, notificationDetails);
    } else {
      await _scheduleRecurringAlarm(alarm, notificationDetails);
    }
  }

  Future<void> _scheduleOneTimeAlarm(
    Alarm alarm,
    NotificationDetails details,
  ) async {
    final tz.TZDateTime scheduledTime = _nextInstanceOfTime(
      alarm.hour,
      alarm.minute,
    );

    await _notifications.zonedSchedule(
      alarm.id.hashCode,
      'Alarm',
      alarm.label.isEmpty ? 'Time to wake up!' : alarm.label,
      scheduledTime,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: alarm.id,
    );
  }

  Future<void> _scheduleRecurringAlarm(
    Alarm alarm,
    NotificationDetails details,
  ) async {
    for (final day in alarm.repeatDays) {
      final scheduledTime = _nextInstanceOfTime(
        alarm.hour,
        alarm.minute,
        dayOfWeek: day,
      );

      final uniqueId = alarm.id.hashCode + day;

      await _notifications.zonedSchedule(
        uniqueId,
        'Alarm',
        alarm.label.isEmpty ? 'Time to wake up!' : alarm.label,
        scheduledTime,
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: alarm.id,
      );
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute, {int? dayOfWeek}) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (dayOfWeek == null) {
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    } else {
      int daysToAdd = (dayOfWeek - scheduledDate.weekday + 7) % 7;
      scheduledDate = scheduledDate.add(Duration(days: daysToAdd));

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 7));
      }
    }
    return scheduledDate;
  }

  Future<void> cancelAlarm(Alarm alarm) async {
    await _notifications.cancel(alarm.id.hashCode);

    for (int day = 0; day < 7; day++) {
      await _notifications.cancel(alarm.id.hashCode + day);
    }
  }

  Future<void> cancelAllAlarms() async {
    await _notifications.cancelAll();
  }
}
