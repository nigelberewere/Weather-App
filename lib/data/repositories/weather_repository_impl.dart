import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weatherly/core/errors/app_error.dart';
import 'package:weatherly/core/services/weather_cache_service.dart';
import 'package:weatherly/data/datasources/weather_api_client.dart';
import 'package:weatherly/data/models/open_weather_map_response.dart';
import 'package:weatherly/domain/entities/weather.dart';
import 'package:weatherly/domain/repositories/weather_repository.dart';
import 'package:collection/collection.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiClient _apiClient;
  final WeatherCacheService _cacheService;
  
  String get _apiKey {
    try {
      final key = dotenv.env['OPENWEATHER_API_KEY'];
      if (key == null || key.isEmpty) {
        debugPrint(
          '❌ API Key Missing! Get a free API key from: https://openweathermap.org/api',
        );
        return '';
      }
      if (key.startsWith('your_') ||
          key == 'demo_key_for_testing' ||
          key == 'b6907d289e10d714a6e88b30761fae22') {
        debugPrint(
          '❌ Please add your real OpenWeatherMap API key to the .env file',
        );
        return '';
      }
      return key;
    } catch (e) {
      debugPrint('⚠️ Error reading API key: $e');
      return '';
    }
  }

  WeatherRepositoryImpl(this._apiClient, this._cacheService);

  @override
  Future<({Weather? data, AppError? error})> getCurrentWeather({
    required double latitude,
    required double longitude,
    String units = 'metric',
  }) async {
    try {
      final response = await _apiClient.getCurrentWeather(
        lat: latitude,
        lon: longitude,
        apiKey: _apiKey,
        units: units,
      );

      final weather = Weather(
        temperature: response.main.temp,
        feelsLike: response.main.feelsLike,
        description: response.weather.first.description,
        icon: _getIconUrl(response.weather.first.icon),
        humidity: response.main.humidity,
        windSpeed: response.wind.speed * 3.6, // m/s to km/h
        windDegree: response.wind.deg,
        pressure: response.main.pressure,
        visibility: (response.visibility / 1000).round(), // meters to km
        dewPoint: 0.0, // Not provided in standard current weather
        uvIndex: 0, // Not provided in standard current weather
        sunrise: DateTime.fromMillisecondsSinceEpoch(
          response.sys.sunrise! * 1000,
        ),
        sunset: DateTime.fromMillisecondsSinceEpoch(
          response.sys.sunset! * 1000,
        ),
        timestamp: DateTime.fromMillisecondsSinceEpoch(response.dt * 1000),
        condition: _mapConditionCode(
          response.weather.first.id,
          icon: response.weather.first.icon,
        ),
      );

      // Cache successful response
      await _cacheService.cacheCurrentWeather(
        latitude: latitude,
        longitude: longitude,
        weather: weather,
        units: units,
      );

      return (data: weather, error: null);
    } on DioException catch (e) {
      // Try to get cached data if network error
      final cachedWeather = await _cacheService.getCachedCurrentWeather(
        latitude: latitude,
        longitude: longitude,
        units: units,
      );
      
      if (cachedWeather != null) {
        debugPrint('📦 Returning cached weather due to network error');
        return (data: cachedWeather, error: null);
      }
      
      return (data: null, error: _handleDioError(e));
    } catch (e) {
      // Try to get cached data on unknown error
      final cachedWeather = await _cacheService.getCachedCurrentWeather(
        latitude: latitude,
        longitude: longitude,
        units: units,
      );
      
      if (cachedWeather != null) {
        return (data: cachedWeather, error: null);
      }
      
      return (data: null, error: AppError.unknown(e.toString()));
    }
  }

  @override
  Future<({List<HourlyForecast>? data, AppError? error})> getHourlyForecast({
    required double latitude,
    required double longitude,
    String units = 'metric',
  }) async {
    try {
      final response = await _apiClient.getForecast(
        lat: latitude,
        lon: longitude,
        apiKey: _apiKey,
        units: units,
      );

      final hourlyForecasts = response.list.take(16).map((item) {
        // 16 items * 3 hours = 48 hours
        return HourlyForecast(
          time: DateTime.fromMillisecondsSinceEpoch(item.dt * 1000),
          temperature: item.main.temp,
          feelsLike: item.main.feelsLike,
          precipitationProbability: (item.pop * 100).round(),
          windSpeed: item.wind.speed * 3.6,
          description: item.weather.first.description,
          icon: _getIconUrl(item.weather.first.icon),
          condition: _mapConditionCode(
            item.weather.first.id,
            icon: item.weather.first.icon,
          ),
          precipitationAmount:
              0.0, // Not easily available in standard forecast list
        );
      }).toList();

      // Cache successful response
      await _cacheService.cacheHourlyForecast(
        latitude: latitude,
        longitude: longitude,
        forecast: hourlyForecasts,
        units: units,
      );

      return (data: hourlyForecasts, error: null);
    } on DioException catch (e) {
      // Try to get cached data if network error
      final cachedForecast = await _cacheService.getCachedHourlyForecast(
        latitude: latitude,
        longitude: longitude,
        units: units,
      );
      
      if (cachedForecast != null) {
        debugPrint('📦 Returning cached hourly forecast due to network error');
        return (data: cachedForecast, error: null);
      }
      
      return (data: null, error: _handleDioError(e));
    } catch (e) {
      // Try to get cached data on unknown error
      final cachedForecast = await _cacheService.getCachedHourlyForecast(
        latitude: latitude,
        longitude: longitude,
        units: units,
      );
      
      if (cachedForecast != null) {
        return (data: cachedForecast, error: null);
      }
      
      return (data: null, error: AppError.unknown(e.toString()));
    }
  }

  @override
  Future<({List<DailyForecast>? data, AppError? error})> getDailyForecast({
    required double latitude,
    required double longitude,
    String units = 'metric',
  }) async {
    try {
      final response = await _apiClient.getForecast(
        lat: latitude,
        lon: longitude,
        apiKey: _apiKey,
        units: units,
      );

      // Group by day
      final grouped = groupBy(response.list, (ForecastItem item) {
        final date = DateTime.fromMillisecondsSinceEpoch(item.dt * 1000);
        return DateTime(date.year, date.month, date.day);
      });

      final dailyForecasts = <DailyForecast>[];

      grouped.forEach((date, items) {
        if (dailyForecasts.length >= 7) return;

        final tempMax = items
            .map((e) => e.main.tempMax)
            .reduce((a, b) => a > b ? a : b);
        final tempMin = items
            .map((e) => e.main.tempMin)
            .reduce((a, b) => a < b ? a : b);
        final maxWind =
            items.map((e) => e.wind.speed).reduce((a, b) => a > b ? a : b) *
            3.6;
        final avgHumidity = items.map((e) => e.main.humidity).average.round();
        final maxPop = items.map((e) => e.pop).reduce((a, b) => a > b ? a : b);

        // Pick the weather condition from the middle of the day (around noon)
        // or the first item if noon is not available
        final noonItem = items.firstWhere(
          (e) {
            final t = DateTime.fromMillisecondsSinceEpoch(e.dt * 1000);
            return t.hour >= 11 && t.hour <= 14;
          },
          orElse: () => items.length > items.length ~/ 2
              ? items[items.length ~/ 2]
              : items.first,
        );

        dailyForecasts.add(
          DailyForecast(
            date: date,
            tempMax: tempMax,
            tempMin: tempMin,
            description: noonItem.weather.first.description,
            icon: _getIconUrl(noonItem.weather.first.icon),
            condition: _mapConditionCode(
              noonItem.weather.first.id,
              icon: noonItem.weather.first.icon,
            ),
            precipitationProbability: (maxPop * 100).round(),
            windSpeed: maxWind,
            humidity: avgHumidity,
          ),
        );
      });

      // Cache successful response
      await _cacheService.cacheDailyForecast(
        latitude: latitude,
        longitude: longitude,
        forecast: dailyForecasts,
        units: units,
      );

      return (data: dailyForecasts, error: null);
    } on DioException catch (e) {
      // Try to get cached data if network error
      final cachedForecast = await _cacheService.getCachedDailyForecast(
        latitude: latitude,
        longitude: longitude,
        units: units,
      );

      if (cachedForecast != null) {
        debugPrint('📦 Returning cached daily forecast due to network error');
        return (data: cachedForecast, error: null);
      }

      return (data: null, error: _handleDioError(e));
    } catch (e) {
      // Try to get cached data on unknown error
      final cachedForecast = await _cacheService.getCachedDailyForecast(
        latitude: latitude,
        longitude: longitude,
        units: units,
      );

      if (cachedForecast != null) {
        return (data: cachedForecast, error: null);
      }

      return (data: null, error: AppError.unknown(e.toString()));
    }
  }

  String _getIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  String _mapConditionCode(int code, {String? icon}) {
    // https://openweathermap.org/weather-conditions
    final isNight = icon?.endsWith('n') ?? false;

    if (code == 800) return isNight ? 'clear_night' : 'sunny';

    // Clouds
    if (code == 801) return isNight ? 'partly_cloudy_night' : 'partly_cloudy';
    if (code == 802) return 'cloudy'; // Scattered clouds
    if (code == 803 || code == 804) return 'overcast'; // Broken/Overcast clouds

    // Rain
    if (code >= 500 && code < 600) return 'rain';

    // Drizzle
    if (code >= 300 && code < 400) return 'drizzle';

    // Thunderstorm
    if (code >= 200 && code < 300) return 'thunderstorm';

    // Snow
    if (code >= 600 && code < 700) return 'snow';

    // Atmosphere
    if (code >= 700 && code < 800) {
      if (code == 701) return 'mist';
      if (code == 741) return 'fog';
      if (code == 721) return 'haze';
      if (code == 761 || code == 731 || code == 751) return 'dust';
      return 'fog'; // Default for others like smoke, sand, ash, squall, tornado
    }

    return isNight ? 'clear_night' : 'sunny'; // Default
  }

  @override
  Future<({List<WeatherAlert>? data, AppError? error})> getWeatherAlerts({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Generate alerts based on current weather conditions
      // This provides intelligent alerts based on severe weather patterns
      // without requiring a paid subscription to OpenWeatherMap's One Call API
      
      final currentWeatherResult = await getCurrentWeather(
        latitude: latitude,
        longitude: longitude,
      );

      if (currentWeatherResult.error != null) {
        return (data: null, error: currentWeatherResult.error);
      }

      final weather = currentWeatherResult.data!;
      final alerts = <WeatherAlert>[];
      final now = DateTime.now();

      // Extreme temperature alerts
      if (weather.temperature > 40) {
        alerts.add(WeatherAlert(
          event: 'Extreme Heat Warning',
          description: 'Temperature is ${weather.temperature.round()}°C. '
              'Stay hydrated and avoid prolonged sun exposure.',
          start: now,
          end: now.add(const Duration(hours: 6)),
          severity: 'Extreme',
          senderName: 'Weatherly Alert System',
        ));
      } else if (weather.temperature < -20) {
        alerts.add(WeatherAlert(
          event: 'Extreme Cold Warning',
          description: 'Temperature is ${weather.temperature.round()}°C. '
              'Dress warmly and limit time outdoors.',
          start: now,
          end: now.add(const Duration(hours: 6)),
          severity: 'Extreme',
          senderName: 'Weatherly Alert System',
        ));
      }

      // High wind alerts
      if (weather.windSpeed > 50) {
        alerts.add(WeatherAlert(
          event: 'High Wind Warning',
          description: 'Wind speed is ${weather.windSpeed.round()} km/h. '
              'Secure loose objects and avoid outdoor activities.',
          start: now,
          end: now.add(const Duration(hours: 3)),
          severity: 'Severe',
          senderName: 'Weatherly Alert System',
        ));
      }

      // Severe weather condition alerts
      if (weather.condition != null) {
        final condition = weather.condition!.toLowerCase();
        
        if (condition.contains('thunderstorm')) {
          alerts.add(WeatherAlert(
            event: 'Thunderstorm Alert',
            description: 'Thunderstorms in the area. Seek shelter indoors '
                'and avoid open areas.',
            start: now,
            end: now.add(const Duration(hours: 2)),
            severity: 'Moderate',
            senderName: 'Weatherly Alert System',
          ));
        }
        
        if (condition.contains('snow')) {
          alerts.add(WeatherAlert(
            event: 'Snow Alert',
            description: 'Snowfall expected. Drive carefully and prepare '
                'for slippery conditions.',
            start: now,
            end: now.add(const Duration(hours: 4)),
            severity: 'Moderate',
            senderName: 'Weatherly Alert System',
          ));
        }
      }

      // Poor visibility alert
      if (weather.visibility < 1) {
        alerts.add(WeatherAlert(
          event: 'Low Visibility Warning',
          description: 'Visibility is less than 1km. Exercise caution '
              'when traveling.',
          start: now,
          end: now.add(const Duration(hours: 2)),
          severity: 'Moderate',
          senderName: 'Weatherly Alert System',
        ));
      }

      return (data: alerts, error: null);
    } on DioException catch (e) {
      return (data: null, error: _handleDioError(e));
    } catch (e) {
      return (
        data: null,
        error: AppError.unknown('Failed to fetch weather alerts: $e'),
      );
    }
  }

  @override
  Future<({AirQuality? data, AppError? error})> getAirQuality({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _apiClient.getAirQuality(
        lat: latitude,
        lon: longitude,
        apiKey: _apiKey,
      );

      if (response.list.isEmpty) {
        return (
          data: null,
          error: const AppError.unknown('No air quality data available'),
        );
      }

      final item = response.list.first;
      final airQuality = AirQuality(
        aqi: item.main.aqi,
        pm25: item.components.pm2_5,
        pm10: item.components.pm10,
        no2: item.components.no2,
        so2: item.components.so2,
        o3: item.components.o3,
        co: item.components.co,
        timestamp: DateTime.fromMillisecondsSinceEpoch(item.dt * 1000),
      );

      return (data: airQuality, error: null);
    } on DioException catch (e) {
      return (data: null, error: _handleDioError(e));
    } catch (e) {
      return (
        data: null,
        error: AppError.unknown('Failed to fetch air quality: $e'),
      );
    }
  }

  AppError _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const AppError.network('Connection timeout');
    } else if (error.type == DioExceptionType.connectionError) {
      return const AppError.network('No internet connection');
    } else if (error.response != null) {
      return AppError.server('Server error: ${error.response?.statusCode}');
    }
    return AppError.unknown(error.message ?? 'Unknown error');
  }
}
