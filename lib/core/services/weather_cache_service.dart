import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:weatherly/core/constants/app_constants.dart';
import 'package:weatherly/domain/entities/weather.dart';

class WeatherCacheService {
  static const String _weatherBoxName = 'weather_cache';
  static const String _hourlyBoxName = 'hourly_forecast_cache';
  static const String _dailyBoxName = 'daily_forecast_cache';

  static const String _fieldPayload = 'payload';
  static const String _fieldCachedAt = 'cachedAt';
  static const String _fieldUnits = 'units';

  /// Cache current weather data
  Future<void> cacheCurrentWeather({
    required double latitude,
    required double longitude,
    required Weather weather,
    required String units,
  }) async {
    try {
      final box = await Hive.openBox<Map>(_weatherBoxName);
      final locationKey = _createLocationKey(latitude, longitude);

      // Store as JSON
      final weatherJson = _encodeWeather(weather);
      final key = _createCacheKey(locationKey, units);
      await box.put(key, {
        _fieldPayload: weatherJson,
        _fieldCachedAt: DateTime.now().millisecondsSinceEpoch,
        _fieldUnits: units,
      });

      debugPrint('✓ Cached current weather for $locationKey ($units)');
    } catch (e) {
      debugPrint('✗ Error caching weather: $e');
    }
  }

  /// Get cached current weather if valid
  Future<Weather?> getCachedCurrentWeather({
    required double latitude,
    required double longitude,
    required String units,
  }) async {
    try {
      final box = await Hive.openBox<Map>(_weatherBoxName);
      final locationKey = _createLocationKey(latitude, longitude);
      final key = _createCacheKey(locationKey, units);

      final cached = box.get(key);
      if (cached == null) return null;

      final cachedAtMs = cached[_fieldCachedAt] as int?;
      if (cachedAtMs == null) return null;
      final cachedAt = DateTime.fromMillisecondsSinceEpoch(cachedAtMs);
      if (!_isValid(cachedAt, AppConstants.weatherCacheDuration)) {
        await box.delete(key);
        debugPrint('⏱ Expired weather cache removed');
        return null;
      }

      final payload = cached[_fieldPayload] as String?;
      if (payload == null) return null;
      final weather = _decodeWeather(payload);
      debugPrint(
        '✓ Using cached weather (age: ${DateTime.now().difference(cachedAt).inMinutes}m)',
      );
      return weather;
    } catch (e) {
      debugPrint('✗ Error retrieving cached weather: $e');
      return null;
    }
  }

  /// Cache hourly forecast data
  Future<void> cacheHourlyForecast({
    required double latitude,
    required double longitude,
    required List<HourlyForecast> forecast,
    required String units,
  }) async {
    try {
      final box = await Hive.openBox<Map>(_hourlyBoxName);
      final locationKey = _createLocationKey(latitude, longitude);

      final forecastJson = _encodeHourlyForecast(forecast);
      final key = _createCacheKey(locationKey, units);
      await box.put(key, {
        _fieldPayload: forecastJson,
        _fieldCachedAt: DateTime.now().millisecondsSinceEpoch,
        _fieldUnits: units,
      });

      debugPrint('✓ Cached hourly forecast for $locationKey ($units)');
    } catch (e) {
      debugPrint('✗ Error caching hourly forecast: $e');
    }
  }

  /// Get cached hourly forecast if valid
  Future<List<HourlyForecast>?> getCachedHourlyForecast({
    required double latitude,
    required double longitude,
    required String units,
  }) async {
    try {
      final box = await Hive.openBox<Map>(_hourlyBoxName);
      final locationKey = _createLocationKey(latitude, longitude);
      final key = _createCacheKey(locationKey, units);

      final cached = box.get(key);
      if (cached == null) return null;

      final cachedAtMs = cached[_fieldCachedAt] as int?;
      if (cachedAtMs == null) return null;
      final cachedAt = DateTime.fromMillisecondsSinceEpoch(cachedAtMs);
      if (!_isValid(cachedAt, AppConstants.forecastCacheDuration)) {
        await box.delete(key);
        debugPrint('⏱ Expired hourly forecast cache removed');
        return null;
      }

      final payload = cached[_fieldPayload] as String?;
      if (payload == null) return null;
      final forecast = _decodeHourlyForecast(payload);
      debugPrint(
        '✓ Using cached hourly forecast (age: ${DateTime.now().difference(cachedAt).inMinutes}m)',
      );
      return forecast;
    } catch (e) {
      debugPrint('✗ Error retrieving cached hourly forecast: $e');
      return null;
    }
  }

  /// Cache daily forecast data
  Future<void> cacheDailyForecast({
    required double latitude,
    required double longitude,
    required List<DailyForecast> forecast,
    required String units,
  }) async {
    try {
      final box = await Hive.openBox<Map>(_dailyBoxName);
      final locationKey = _createLocationKey(latitude, longitude);

      final forecastJson = _encodeDailyForecast(forecast);
      final key = _createCacheKey(locationKey, units);
      await box.put(key, {
        _fieldPayload: forecastJson,
        _fieldCachedAt: DateTime.now().millisecondsSinceEpoch,
        _fieldUnits: units,
      });

      debugPrint('✓ Cached daily forecast for $locationKey ($units)');
    } catch (e) {
      debugPrint('✗ Error caching daily forecast: $e');
    }
  }

  /// Get cached daily forecast if valid
  Future<List<DailyForecast>?> getCachedDailyForecast({
    required double latitude,
    required double longitude,
    required String units,
  }) async {
    try {
      final box = await Hive.openBox<Map>(_dailyBoxName);
      final locationKey = _createLocationKey(latitude, longitude);
      final key = _createCacheKey(locationKey, units);

      final cached = box.get(key);
      if (cached == null) return null;

      final cachedAtMs = cached[_fieldCachedAt] as int?;
      if (cachedAtMs == null) return null;
      final cachedAt = DateTime.fromMillisecondsSinceEpoch(cachedAtMs);
      if (!_isValid(cachedAt, AppConstants.forecastCacheDuration)) {
        await box.delete(key);
        debugPrint('⏱ Expired daily forecast cache removed');
        return null;
      }

      final payload = cached[_fieldPayload] as String?;
      if (payload == null) return null;
      final forecast = _decodeDailyForecast(payload);
      debugPrint(
        '✓ Using cached daily forecast (age: ${DateTime.now().difference(cachedAt).inMinutes}m)',
      );
      return forecast;
    } catch (e) {
      debugPrint('✗ Error retrieving cached daily forecast: $e');
      return null;
    }
  }

  /// Clear all weather cache
  Future<void> clearAllCache() async {
    try {
      final weatherBox = await Hive.openBox<Map>(_weatherBoxName);
      final hourlyBox = await Hive.openBox<Map>(_hourlyBoxName);
      final dailyBox = await Hive.openBox<Map>(_dailyBoxName);

      await weatherBox.clear();
      await hourlyBox.clear();
      await dailyBox.clear();

      debugPrint('✓ All weather cache cleared');
    } catch (e) {
      debugPrint('✗ Error clearing cache: $e');
    }
  }

  /// Helper: Encode Weather to JSON string
  static String _encodeWeather(Weather weather) {
    return jsonEncode(weather.toJson());
  }

  /// Helper: Decode Weather from JSON string
  static Weather _decodeWeather(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return Weather.fromJson(map);
  }

  /// Helper: Encode List<HourlyForecast> to JSON string
  static String _encodeHourlyForecast(List<HourlyForecast> forecasts) {
    final list = forecasts.map((f) => f.toJson()).toList();
    return jsonEncode(list);
  }

  /// Helper: Decode List<HourlyForecast> from JSON string
  static List<HourlyForecast> _decodeHourlyForecast(String json) {
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((item) => HourlyForecast.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Helper: Encode List<DailyForecast> to JSON string
  static String _encodeDailyForecast(List<DailyForecast> forecasts) {
    final list = forecasts.map((f) => f.toJson()).toList();
    return jsonEncode(list);
  }

  /// Helper: Decode List<DailyForecast> from JSON string
  static List<DailyForecast> _decodeDailyForecast(String json) {
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((item) => DailyForecast.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static String _createLocationKey(double latitude, double longitude) {
    return '${latitude}_$longitude';
  }

  static String _createCacheKey(String locationKey, String units) {
    return '${locationKey}_$units';
  }

  static bool _isValid(DateTime cachedAt, Duration ttl) {
    return DateTime.now().difference(cachedAt) < ttl;
  }
}
