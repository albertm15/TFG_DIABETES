import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/dietDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/insulinDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/reminderDAO.dart';
import 'package:diabetes_tfg_app/database/local/dietDAO.dart';
import 'package:diabetes_tfg_app/database/local/insulinDAO.dart';
import 'package:diabetes_tfg_app/database/local/reminderDAO.dart';
import 'package:diabetes_tfg_app/models/dietModel.dart';
import 'package:diabetes_tfg_app/models/insulinModel.dart';
import 'package:diabetes_tfg_app/models/reminderModel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class InsulinNotifications {
  static int nextInsulinId = 0;
  static int nextDietId = 2;
  static int nextReminderId = 7;
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

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> scheduleInsulinNotification(
      int hour, int minute, String typeInjection) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      nextInsulinId++,
      'Hora de insulina lenta',
      'Es hora de ponerte la $typeInjection inyección de insulina de absorción lenta.',
      scheduledDate,
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
  }

  static Future<void> scheduleDietNotification(
      int hour, int minute, String typeMeal) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      nextDietId++,
      'Hora de comer',
      'Es la hora $typeMeal.',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'diet_channel',
          'Notificación de dieta',
          channelDescription: 'Notificaciones diarias para la comida',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> schedulePuctualReminderNotification(int day, int month,
      int year, int hour, int minute, String message) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, year, month, day, hour, minute);

    if (!scheduledDate.isBefore(now)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        nextReminderId++,
        'Recodatorio',
        '$message.',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_channel',
            'Notificación de reocrdatorio',
            channelDescription: 'Notificaciones de recordatorio',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  static Future<void> scheduleDailyReminderNotification(int day, int month,
      int year, int hour, int minute, String message) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, year, month, day, hour, minute);

    if (!scheduledDate.isBefore(now)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        nextReminderId++,
        'Recodatorio',
        '$message.',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_channel',
            'Notificación de reocrdatorio',
            channelDescription: 'Notificaciones de recordatorio',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static Future<void> scheduleWeeklyReminderNotification(int day, int month,
      int year, int hour, int minute, String message) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, year, month, day, hour, minute);

    if (!scheduledDate.isBefore(now)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          nextReminderId++,
          'Recodatorio',
          '$message.',
          scheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'reminder_channel',
              'Notificación de reocrdatorio',
              channelDescription: 'Notificaciones de recordatorio',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
    }
  }

  static Future<void> scheduleMonthlyReminderNotification(int day, int month,
      int year, int hour, int minute, String message) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, year, month, day, hour, minute);

    if (!scheduledDate.isBefore(now)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          nextReminderId++,
          'Recodatorio',
          '$message.',
          scheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'reminder_channel',
              'Notificación de reocrdatorio',
              channelDescription: 'Notificaciones de recordatorio',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime);
    }
  }

  static Future<void> scheduleAllReminders() async {
    List<ReminderModel> reminders;

    if (AuthServiceManager.checkIfLogged()) {
      ReminderDAOFB dao = ReminderDAOFB();
      reminders = await dao.getAllSinceToday();
    } else {
      ReminderDAO dao = ReminderDAO();
      reminders = await dao.getAllSinceToday();
    }

    for (ReminderModel reminder in reminders) {
      switch (reminder.repeatConfig) {
        case 'Cada día':
          InsulinNotifications.scheduleDailyReminderNotification(
              int.parse(reminder.date.split("-")[2]),
              int.parse(reminder.date.split("-")[1]),
              int.parse(reminder.date.split("-")[0]),
              int.parse(reminder.time.split(":")[0]),
              int.parse(reminder.time.split(":")[1]),
              "Recordatorio: ${reminder.title}");
        case 'Cada semana':
          InsulinNotifications.scheduleWeeklyReminderNotification(
              int.parse(reminder.date.split("-")[2]),
              int.parse(reminder.date.split("-")[1]),
              int.parse(reminder.date.split("-")[0]),
              int.parse(reminder.time.split(":")[0]),
              int.parse(reminder.time.split(":")[1]),
              "Recordatorio: ${reminder.title}");
        case 'Cada mes':
          InsulinNotifications.scheduleMonthlyReminderNotification(
              int.parse(reminder.date.split("-")[2]),
              int.parse(reminder.date.split("-")[1]),
              int.parse(reminder.date.split("-")[0]),
              int.parse(reminder.time.split(":")[0]),
              int.parse(reminder.time.split(":")[1]),
              "Recordatorio: ${reminder.title}");
        default:
          InsulinNotifications.schedulePuctualReminderNotification(
              int.parse(reminder.date.split("-")[2]),
              int.parse(reminder.date.split("-")[1]),
              int.parse(reminder.date.split("-")[0]),
              int.parse(reminder.time.split(":")[0]),
              int.parse(reminder.time.split(":")[1]),
              "Recordatorio: ${reminder.title}");
      }
      nextReminderId += 1;
    }
  }

  static Future<void> scheduleAllInsulinNotifications() async {
    List<InsulinModel> notifications;

    if (AuthServiceManager.checkIfLogged()) {
      InsulinDAOFB dao = InsulinDAOFB();
      notifications = await dao.getAll();
    } else {
      InsulinDAO dao = InsulinDAO();
      notifications = await dao.getAll();
    }
    if (notifications.isNotEmpty) {
      scheduleInsulinNotification(
          int.parse(notifications[0].firstInjectionSchedule.split(":")[0]),
          int.parse(notifications[0].firstInjectionSchedule.split(":")[1]),
          "primera");
      scheduleInsulinNotification(
          int.parse(notifications[0].secondInjectionSchedule.split(":")[0]),
          int.parse(notifications[0].secondInjectionSchedule.split(":")[1]),
          "segunda");
    }
  }

  static Future<void> scheduleAllDietNotifications() async {
    List<DietModel> notifications;

    if (AuthServiceManager.checkIfLogged()) {
      DietDAOFB dao = DietDAOFB();
      notifications = await dao.getAll();
    } else {
      DietDAO dao = DietDAO();
      notifications = await dao.getAll();
    }

    if (notifications.isNotEmpty) {
      scheduleInsulinNotification(
          int.parse(notifications[0].breakfastSchedule.split(":")[0]),
          int.parse(notifications[0].breakfastSchedule.split(":")[1]),
          "del desayuno");
      scheduleInsulinNotification(
          int.parse(notifications[0].snackSchedule.split(":")[0]),
          int.parse(notifications[0].snackSchedule.split(":")[1]),
          "del tente en pié");
      scheduleInsulinNotification(
          int.parse(notifications[0].lunchSchedule.split(":")[0]),
          int.parse(notifications[0].lunchSchedule.split(":")[1]),
          "de la comida");
      scheduleInsulinNotification(
          int.parse(notifications[0].afternoonSnackSchedule.split(":")[0]),
          int.parse(notifications[0].afternoonSnackSchedule.split(":")[1]),
          "de la merienda");
      scheduleInsulinNotification(
          int.parse(notifications[0].dinnerSchedule.split(":")[0]),
          int.parse(notifications[0].dinnerSchedule.split(":")[1]),
          "de la cena");
    }
  }

  static void scheduleAll() {
    scheduleAllInsulinNotifications();
    scheduleAllDietNotifications();
    scheduleAllReminders();
  }

  static Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    nextInsulinId = 0;
    nextDietId = 2;
    nextReminderId = 7;
  }

  static Future<void> cancelInsulinNotifications() async {
    await flutterLocalNotificationsPlugin.cancel(0);
    await flutterLocalNotificationsPlugin.cancel(1);
  }

  static Future<void> cancelDietNotifications() async {
    await flutterLocalNotificationsPlugin.cancel(2);
    await flutterLocalNotificationsPlugin.cancel(3);
    await flutterLocalNotificationsPlugin.cancel(4);
    await flutterLocalNotificationsPlugin.cancel(5);
    await flutterLocalNotificationsPlugin.cancel(6);
    nextDietId = 2;
  }

  static Future<void> cancelRemindersNotifications() async {
    while (nextReminderId > 7) {
      await flutterLocalNotificationsPlugin.cancel(nextReminderId - 1);
    }
    nextReminderId = 7;
  }
}
