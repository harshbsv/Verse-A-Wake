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

  // Initialize the notification service
  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
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

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - you can navigate to a specific screen here
    // Log or handle the notification tap event
  }

  // Schedule an alarm notification
  Future<void> scheduleAlarm(Alarm alarm) async {
    if (!alarm.isActive) return;

    await _notifications.cancel(alarm.id.hashCode);

    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      alarm.hour,
      alarm.minute,
    );

    // If the alarm time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );

    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarms',
      channelDescription: 'Alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('alarm_sound'),
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'alarm_sound.aiff',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    if (alarm.repeatDays.isEmpty) {
      // One-time alarm
      await _notifications.zonedSchedule(
        alarm.id.hashCode,
        'Alarm',
        alarm.label.isEmpty ? 'Time to wake up!' : alarm.label,
        scheduledTime,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: alarm.id,
      );
    } else {
      // Recurring alarm - schedule for each selected day
      for (final day in alarm.repeatDays) {
        final daysUntilAlarm = (day - scheduledDate.weekday + 7) % 7;
        var nextAlarmDate = scheduledDate.add(Duration(days: daysUntilAlarm));
        
        if (nextAlarmDate.isBefore(now)) {
          nextAlarmDate = nextAlarmDate.add(const Duration(days: 7));
        }

        final tz.TZDateTime nextScheduledTime = tz.TZDateTime.from(
          nextAlarmDate,
          tz.local,
        );

        await _notifications.zonedSchedule(
          alarm.id.hashCode + day,
          'Alarm',
          alarm.label.isEmpty ? 'Time to wake up!' : alarm.label,
          nextScheduledTime,
          notificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          payload: alarm.id,
        );
      }
    }
  }

  // Cancel an alarm notification
  Future<void> cancelAlarm(Alarm alarm) async {
    await _notifications.cancel(alarm.id.hashCode);
    
    // Cancel all recurring notifications for this alarm
    for (int day = 0; day < 7; day++) {
      await _notifications.cancel(alarm.id.hashCode + day);
    }
  }

  // Cancel all alarms
  Future<void> cancelAllAlarms() async {
    await _notifications.cancelAll();
  }

  // Request notification permissions (mainly for iOS)
  Future<bool> requestPermissions() async {
    if (!_initialized) await initialize();

    final result = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    return result ?? true;
  }
}
