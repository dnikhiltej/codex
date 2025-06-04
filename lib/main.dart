import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard_screen.dart';
import 'providers/card_provider.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initNotifications();
  runApp(const MyApp());
}

Future<void> _initNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();
  const settings = InitializationSettings(android: android, iOS: ios);
  await notificationsPlugin.initialize(settings);
  _scheduleDailyNotification();
}

void _scheduleDailyNotification() async {
  const android = AndroidNotificationDetails('daily_id', 'Daily Reminder');
  const ios = DarwinNotificationDetails();
  const details = NotificationDetails(android: android, iOS: ios);
  await notificationsPlugin.zonedSchedule(
    0,
    'CPR Reminder',
    'You have pending card payments',
    _nextInstanceOfNoon(),
    details,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

DateTime _nextInstanceOfNoon() {
  final now = DateTime.now();
  final tomorrow = DateTime(now.year, now.month, now.day, 12);
  return now.isAfter(tomorrow)
      ? tomorrow.add(const Duration(days: 1))
      : tomorrow;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CardProvider(),
      child: MaterialApp(
        title: 'CPR - Card Payment Reminder',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const DashboardScreen(),
      ),
    );
  }
}
