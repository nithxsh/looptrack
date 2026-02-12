import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';
import '../models/models.dart';

class ResetService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    await _scheduleMidnightReset();
    _initialized = true;
  }

  static Future<void> _scheduleMidnightReset() async {
    final prefs = await SharedPreferences.getInstance();
    final lastScheduled = prefs.getInt('last_midnight_reset_key');
    final now = DateTime.now();
    final todayKey = now.year * 10000 + now.month * 100 + now.day;

    // Get next midnight
    var nextMidnight = DateTime(now.year, now.month, now.day, 0, 0, 1);
    if (now.isAfter(nextMidnight)) {
      nextMidnight = nextMidnight.add(const Duration(days: 1));
    }

    final scheduledDate = tz.TZDateTime.from(nextMidnight, tz.local);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'midnight_reset',
      'Midnight Reset',
      channelDescription: 'Resets daily tasks at midnight',
      importance: Importance.low,
      priority: Priority.low,
      showWhen: false,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      999,
      'LoopTrack Daily Reset',
      'Daily tasks have been reset for a new day',
      scheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'midnight_reset',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    debugPrint('✓ Midnight reset scheduled for: $scheduledDate');
  }

  static Future<void> _onNotificationTap(
      NotificationResponse response) async {
    if (response.payload == 'midnight_reset') {
      await performReset();
    }
  }

  static Future<void> performReset() async {
    debugPrint('🔄 Executing midnight reset...');

    final db = DatabaseHelper.instance;

    // Save history before reset
    final tasks = await db.getDailyTasks();
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((t) => t.isCompleted).length;

    final now = DateTime.now();
    final dateString = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // Calculate consistency score
    final prefs = await SharedPreferences.getInstance();
    int streak = prefs.getInt('streak_count') ?? 0;
    if (completedTasks == totalTasks && totalTasks > 0) {
      streak++;
    } else if (completedTasks < totalTasks / 2 && totalTasks > 0) {
      streak = 0;
    }

    final consistencyScore = totalTasks > 0
        ? ((completedTasks / totalTasks) * streak).round()
        : 0;

    final entry = HistoryEntry(
      date: dateString,
      completedTasks: completedTasks,
      totalTasks: totalTasks,
      consistencyScore: consistencyScore,
    );

    await db.insertOrUpdateHistoryEntry(entry);
    await prefs.setInt('streak_count', streak);

    // Reset all tasks
    final resetCount = await db.resetAllDailyTasks();

    debugPrint('✓ Reset $resetCount tasks for $dateString');
    debugPrint('✓ History saved: $completedTasks/$totalTasks completed');
    debugPrint('✓ Current streak: $streak days');
  }

  static Future<void> manualReset() async {
    await performReset();
  }

  static Future<int> getStreakCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('streak_count') ?? 0;
  }
}