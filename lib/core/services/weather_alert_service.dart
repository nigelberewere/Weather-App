import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherly/domain/repositories/weather_repository.dart';
import 'package:weatherly/core/services/notification_service.dart';

class WeatherAlertService {
  final WeatherRepository _weatherRepository;
  final NotificationService _notificationService;

  Timer? _checkTimer;
  final Set<String> _shownAlerts = {};

  WeatherAlertService({
    required WeatherRepository weatherRepository,
    required NotificationService notificationService,
  }) : _weatherRepository = weatherRepository,
       _notificationService = notificationService;

  Future<void> startMonitoring({
    required double latitude,
    required double longitude,
    Duration interval = const Duration(minutes: 30),
  }) async {
    debugPrint('WeatherAlertService: Starting monitoring');

    // Check immediately
    await _checkForAlerts(latitude, longitude);

    // Then check periodically
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(interval, (_) {
      _checkForAlerts(latitude, longitude);
    });
  }

  Future<void> _checkForAlerts(double latitude, double longitude) async {
    final prefs = await SharedPreferences.getInstance();
    final alertsEnabled = prefs.getBool('notifications_enabled') ?? true;

    if (!alertsEnabled) {
      debugPrint('WeatherAlertService: Alerts disabled in settings');
      return;
    }

    debugPrint('WeatherAlertService: Checking for alerts...');

    final result = await _weatherRepository.getWeatherAlerts(
      latitude: latitude,
      longitude: longitude,
    );

    if (result.error != null) {
      debugPrint('WeatherAlertService: Error fetching alerts: ${result.error}');
      return;
    }

    final alerts = result.data ?? [];
    debugPrint('WeatherAlertService: Found ${alerts.length} alerts');

    for (final alert in alerts) {
      final alertKey = '${alert.event}_${alert.start.millisecondsSinceEpoch}';

      // Only show each unique alert once
      if (!_shownAlerts.contains(alertKey)) {
        await _notificationService.showWeatherAlert(alert);
        _shownAlerts.add(alertKey);

        // Keep cache size manageable
        if (_shownAlerts.length > 50) {
          _shownAlerts.clear();
        }
      }
    }
  }

  void stopMonitoring() {
    debugPrint('WeatherAlertService: Stopping monitoring');
    _checkTimer?.cancel();
    _checkTimer = null;
  }

  void dispose() {
    stopMonitoring();
  }
}
