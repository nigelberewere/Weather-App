import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherly/core/providers/providers.dart';
import 'package:weatherly/core/services/notification_service.dart';
import 'package:weatherly/core/services/weather_alert_service.dart';

// Notification Service Provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

// Weather Alert Service Provider
final weatherAlertServiceProvider = Provider<WeatherAlertService>((ref) {
  final weatherRepository = ref.watch(weatherRepositoryProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  
  return WeatherAlertService(
    weatherRepository: weatherRepository,
    notificationService: notificationService,
  );
});

// Notification Settings Provider
class NotificationSettings {
  final bool alertsEnabled;
  final bool dailySummaryEnabled;
  final bool severeWeatherOnly;
  final String dailySummaryTime; // In HH:mm format

  const NotificationSettings({
    this.alertsEnabled = true,
    this.dailySummaryEnabled = false,
    this.severeWeatherOnly = false,
    this.dailySummaryTime = '08:00',
  });

  NotificationSettings copyWith({
    bool? alertsEnabled,
    bool? dailySummaryEnabled,
    bool? severeWeatherOnly,
    String? dailySummaryTime,
  }) {
    return NotificationSettings(
      alertsEnabled: alertsEnabled ?? this.alertsEnabled,
      dailySummaryEnabled: dailySummaryEnabled ?? this.dailySummaryEnabled,
      severeWeatherOnly: severeWeatherOnly ?? this.severeWeatherOnly,
      dailySummaryTime: dailySummaryTime ?? this.dailySummaryTime,
    );
  }
}

final notificationSettingsProvider = 
    NotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  NotificationSettingsNotifier.new,
);

class NotificationSettingsNotifier extends Notifier<NotificationSettings> {
  @override
  NotificationSettings build() {
    _loadSettings();
    return const NotificationSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = NotificationSettings(
      alertsEnabled: prefs.getBool('notifications_enabled') ?? true,
      dailySummaryEnabled: prefs.getBool('daily_summary_enabled') ?? false,
      severeWeatherOnly: prefs.getBool('severe_weather_only') ?? false,
      dailySummaryTime: prefs.getString('daily_summary_time') ?? '08:00',
    );
  }

  Future<void> setAlertsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
    state = state.copyWith(alertsEnabled: enabled);
  }

  Future<void> setDailySummaryEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_summary_enabled', enabled);
    state = state.copyWith(dailySummaryEnabled: enabled);
  }

  Future<void> setSevereWeatherOnly(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('severe_weather_only', enabled);
    state = state.copyWith(severeWeatherOnly: enabled);
  }

  Future<void> setDailySummaryTime(String time) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getString('daily_summary_time');
    state = state.copyWith(dailySummaryTime: time);
  }
}
