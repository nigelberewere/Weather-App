import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:weatherly/domain/entities/weather.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      const initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/launcher_icon',
      );

      const initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _notifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _isInitialized = true;
      debugPrint('NotificationService initialized successfully');
    } catch (e) {
      debugPrint('NotificationService initialization failed: $e');
      // Fail silently on web or unsupported platforms
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Handle notification tap - could navigate to specific screen
  }

  Future<bool> requestPermission() async {
    if (!_isInitialized) await initialize();

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidImplementation = _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        return await androidImplementation?.requestNotificationsPermission() ??
            false;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosImplementation = _notifications
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        return await iosImplementation?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      }
      return true; // Other platforms
    } catch (e) {
      debugPrint('Failed to request notification permission: $e');
      return false;
    }
  }

  Future<void> showWeatherAlert(WeatherAlert alert) async {
    if (!_isInitialized) await initialize();

    try {
      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'weather_alerts',
          'Weather Alerts',
          channelDescription: 'Notifications for severe weather alerts',
          importance: _getImportance(alert.severity),
          priority: Priority.high,
          showWhen: true,
          largeIcon: const DrawableResourceAndroidBitmap(
            'ic_launcher_foreground',
          ),
          enableLights: true,
          enableVibration: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notifications.show(
        alert.hashCode,
        '⚠️ ${alert.event}',
        alert.description,
        notificationDetails,
        payload: 'alert:${alert.event}',
      );

      debugPrint('Weather alert notification shown: ${alert.event}');
    } catch (e) {
      debugPrint('Failed to show weather alert: $e');
    }
  }

  Future<void> showDailySummary({
    required String locationName,
    required String condition,
    required double temperature,
    required double tempHigh,
    required double tempLow,
  }) async {
    if (!_isInitialized) await initialize();

    try {
      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_summary',
          'Daily Weather Summary',
          channelDescription: 'Daily weather forecast summary',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,

          largeIcon: DrawableResourceAndroidBitmap('ic_launcher_foreground'),
          enableLights: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notifications.show(
        1, // Fixed ID for daily summary
        '🌤️ $locationName Weather',
        '$condition • ${temperature.round()}° High: ${tempHigh.round()}° Low: ${tempLow.round()}°',
        notificationDetails,
        payload: 'daily_summary',
      );

      debugPrint('Daily summary notification shown');
    } catch (e) {
      debugPrint('Failed to show daily summary: $e');
    }
  }

  Future<void> cancelAll() async {
    try {
      await _notifications.cancelAll();
    } catch (e) {
      debugPrint('Failed to cancel notifications: $e');
    }
  }

  Future<void> cancel(int id) async {
    try {
      await _notifications.cancel(id);
    } catch (e) {
      debugPrint('Failed to cancel notification $id: $e');
    }
  }

  Importance _getImportance(String severity) {
    switch (severity.toLowerCase()) {
      case 'extreme':
        return Importance.max;
      case 'severe':
        return Importance.high;
      case 'moderate':
        return Importance.defaultImportance;
      default:
        return Importance.low;
    }
  }
}
