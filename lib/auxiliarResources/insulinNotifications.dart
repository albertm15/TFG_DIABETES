import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class InsulinNotifications {
  static int nextId = 0;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotificationConfig() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    InitializationSettings initSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // 🚨 Solicitar permisos explícitamente en iOS
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> scheduleInsulinNotification(int hour, int minute) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    var scheduledDate2 = tz.TZDateTime.now(tz.local).add(Duration(seconds: 10));
    var scheduledDate3 = tz.TZDateTime.now(tz.local);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    print(scheduledDate);
    print(scheduledDate2);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      nextId++,
      'Hora de insulina lenta',
      'Es hora de ponerte la insulina de absorción lenta. $hour:$minute',
      scheduledDate2,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'insulin_channel',
          'Notificación de insulina',
          channelDescription: 'Notificaciones diarias para la insulina',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    print("Notification scheduled for $scheduledDate");
  }

  static Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    nextId = 0;
  }
}
