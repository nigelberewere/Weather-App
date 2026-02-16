import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather.freezed.dart';
part 'weather.g.dart';

@freezed
abstract class Weather with _$Weather {
  const factory Weather({
    required double temperature,
    required double feelsLike,
    required String description,
    required String icon,
    required int humidity,
    required double windSpeed,
    required int windDegree,
    required int pressure,
    required int visibility,
    required double dewPoint,
    required int uvIndex,
    required DateTime sunrise,
    required DateTime sunset,
    required DateTime timestamp,
    String? condition,
  }) = _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}

@freezed
abstract class HourlyForecast with _$HourlyForecast {
  const factory HourlyForecast({
    required DateTime time,
    required double temperature,
    required double feelsLike,
    required int precipitationProbability,
    required double windSpeed,
    required String description,
    required String icon,
    String? condition,
    double? precipitationAmount,
  }) = _HourlyForecast;

  factory HourlyForecast.fromJson(Map<String, dynamic> json) =>
      _$HourlyForecastFromJson(json);
}

@freezed
abstract class DailyForecast with _$DailyForecast {
  const factory DailyForecast({
    required DateTime date,
    required double tempMax,
    required double tempMin,
    required String description,
    required String icon,
    String? condition,
    required int precipitationProbability,
    required double windSpeed,
    required int humidity,
    int? uvIndex,
  }) = _DailyForecast;

  factory DailyForecast.fromJson(Map<String, dynamic> json) =>
      _$DailyForecastFromJson(json);
}

@freezed
abstract class WeatherAlert with _$WeatherAlert {
  const factory WeatherAlert({
    required String event,
    required String description,
    required DateTime start,
    required DateTime end,
    required String severity,
    String? senderName,
  }) = _WeatherAlert;

  factory WeatherAlert.fromJson(Map<String, dynamic> json) =>
      _$WeatherAlertFromJson(json);
}

@freezed
abstract class Location with _$Location {
  const factory Location({
    required String name,
    required double latitude,
    required double longitude,
    String? country,
    String? state,
    @Default(false) bool isFavorite,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}

@freezed
abstract class AirQuality with _$AirQuality {
  const factory AirQuality({
    required int aqi,
    required double pm25,
    required double pm10,
    required double no2,
    required double so2,
    required double o3,
    required double co,
    required DateTime timestamp,
  }) = _AirQuality;

  factory AirQuality.fromJson(Map<String, dynamic> json) =>
      _$AirQualityFromJson(json);
}
