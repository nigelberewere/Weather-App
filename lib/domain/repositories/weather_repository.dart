import 'package:weatherly/core/errors/app_error.dart';
import 'package:weatherly/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<({Weather? data, AppError? error})> getCurrentWeather({
    required double latitude,
    required double longitude,
    String units = 'metric',
  });

  Future<({List<HourlyForecast>? data, AppError? error})> getHourlyForecast({
    required double latitude,
    required double longitude,
    String units = 'metric',
  });

  Future<({List<DailyForecast>? data, AppError? error})> getDailyForecast({
    required double latitude,
    required double longitude,
    String units = 'metric',
  });

  Future<({List<WeatherAlert>? data, AppError? error})> getWeatherAlerts({
    required double latitude,
    required double longitude,
  });

  Future<({AirQuality? data, AppError? error})> getAirQuality({
    required double latitude,
    required double longitude,
  });
}
