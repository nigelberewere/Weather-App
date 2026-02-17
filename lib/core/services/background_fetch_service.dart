import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherly/core/providers/providers.dart';
import 'package:weatherly/domain/entities/weather.dart';

/// Service to manage background weather refresh tasks
class BackgroundFetchService {
  static const String _taskId = 'weatherly_bg_fetch';
  static const int _minIntervalMinutes =
      15; // Background fetch minimum interval (OS enforced)

  static final _container = ProviderContainer();

  /// Initialize background fetch for weather updates
  static Future<void> initializeBackgroundFetch() async {
    try {
      // Configure background fetch with minimum interval
      final status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: _minIntervalMinutes,
          forceAlarmManager: false,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false,
          startOnBoot: true,
        ),
        _onBackgroundFetch,
        _onBackgroundFetchTimeout,
      );

      debugPrint('🔄 Background fetch initialized with status: $status');
    } catch (e) {
      debugPrint('❌ Error initializing background fetch: $e');
    }
  }

  /// Start background fetch tasks
  static Future<void> startBackgroundFetch() async {
    try {
      await BackgroundFetch.start();
      debugPrint('🔄 Background fetch started');
    } catch (e) {
      debugPrint('❌ Error starting background fetch: $e');
    }
  }

  /// Stop background fetch tasks
  static Future<void> stopBackgroundFetch() async {
    try {
      await BackgroundFetch.stop(_taskId);
      debugPrint('⏹️ Background fetch stopped');
    } catch (e) {
      debugPrint('❌ Error stopping background fetch: $e');
    }
  }

  /// Handle background fetch callback
  static Future<void> _onBackgroundFetch(String taskId) async {
    debugPrint('⏳ Background fetch task executing: $taskId');

    try {
      // Get the last known location from preferences
      final prefs = await SharedPreferences.getInstance();
      final lastLat = prefs.getDouble('last_location_lat');
      final lastLon = prefs.getDouble('last_location_lon');

      if (lastLat != null && lastLon != null) {
        // Create a location object and fetch weather
        final location = Location(
          latitude: lastLat,
          longitude: lastLon,
          name: prefs.getString('last_location_name') ?? 'Unknown',
          country: prefs.getString('last_location_country'),
          state: prefs.getString('last_location_state'),
        );

        // Fetch weather data
        final repository = _container.read(weatherRepositoryProvider);
        final result = await repository.getCurrentWeather(
          latitude: location.latitude,
          longitude: location.longitude,
          units: 'metric',
        );

        if (result.data != null) {
          debugPrint(
            '✅ Background weather fetch successful for ${location.name}',
          );
        } else if (result.error != null) {
          debugPrint('⚠️ Background weather fetch error: ${result.error}');
        }
      }
    } catch (e) {
      debugPrint('❌ Error in background fetch task: $e');
    }

    // IMPORTANT: Must call finish when task is complete
    await BackgroundFetch.finish(taskId);
  }

  /// Handle background fetch timeout
  static Future<void> _onBackgroundFetchTimeout(String taskId) async {
    debugPrint('⏱️ Background fetch task timeout: $taskId');
    await BackgroundFetch.finish(taskId);
  }
}
