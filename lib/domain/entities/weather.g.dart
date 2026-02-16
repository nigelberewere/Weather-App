// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Weather _$WeatherFromJson(Map<String, dynamic> json) => _Weather(
  temperature: (json['temperature'] as num).toDouble(),
  feelsLike: (json['feelsLike'] as num).toDouble(),
  description: json['description'] as String,
  icon: json['icon'] as String,
  humidity: (json['humidity'] as num).toInt(),
  windSpeed: (json['windSpeed'] as num).toDouble(),
  windDegree: (json['windDegree'] as num).toInt(),
  pressure: (json['pressure'] as num).toInt(),
  visibility: (json['visibility'] as num).toInt(),
  dewPoint: (json['dewPoint'] as num).toDouble(),
  uvIndex: (json['uvIndex'] as num).toInt(),
  sunrise: DateTime.parse(json['sunrise'] as String),
  sunset: DateTime.parse(json['sunset'] as String),
  timestamp: DateTime.parse(json['timestamp'] as String),
  condition: json['condition'] as String?,
);

Map<String, dynamic> _$WeatherToJson(_Weather instance) => <String, dynamic>{
  'temperature': instance.temperature,
  'feelsLike': instance.feelsLike,
  'description': instance.description,
  'icon': instance.icon,
  'humidity': instance.humidity,
  'windSpeed': instance.windSpeed,
  'windDegree': instance.windDegree,
  'pressure': instance.pressure,
  'visibility': instance.visibility,
  'dewPoint': instance.dewPoint,
  'uvIndex': instance.uvIndex,
  'sunrise': instance.sunrise.toIso8601String(),
  'sunset': instance.sunset.toIso8601String(),
  'timestamp': instance.timestamp.toIso8601String(),
  'condition': instance.condition,
};

_HourlyForecast _$HourlyForecastFromJson(Map<String, dynamic> json) =>
    _HourlyForecast(
      time: DateTime.parse(json['time'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      precipitationProbability: (json['precipitationProbability'] as num)
          .toInt(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      description: json['description'] as String,
      icon: json['icon'] as String,
      condition: json['condition'] as String?,
      precipitationAmount: (json['precipitationAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$HourlyForecastToJson(_HourlyForecast instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'temperature': instance.temperature,
      'feelsLike': instance.feelsLike,
      'precipitationProbability': instance.precipitationProbability,
      'windSpeed': instance.windSpeed,
      'description': instance.description,
      'icon': instance.icon,
      'condition': instance.condition,
      'precipitationAmount': instance.precipitationAmount,
    };

_DailyForecast _$DailyForecastFromJson(Map<String, dynamic> json) =>
    _DailyForecast(
      date: DateTime.parse(json['date'] as String),
      tempMax: (json['tempMax'] as num).toDouble(),
      tempMin: (json['tempMin'] as num).toDouble(),
      description: json['description'] as String,
      icon: json['icon'] as String,
      condition: json['condition'] as String?,
      precipitationProbability: (json['precipitationProbability'] as num)
          .toInt(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      uvIndex: (json['uvIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DailyForecastToJson(_DailyForecast instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'tempMax': instance.tempMax,
      'tempMin': instance.tempMin,
      'description': instance.description,
      'icon': instance.icon,
      'condition': instance.condition,
      'precipitationProbability': instance.precipitationProbability,
      'windSpeed': instance.windSpeed,
      'humidity': instance.humidity,
      'uvIndex': instance.uvIndex,
    };

_WeatherAlert _$WeatherAlertFromJson(Map<String, dynamic> json) =>
    _WeatherAlert(
      event: json['event'] as String,
      description: json['description'] as String,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      severity: json['severity'] as String,
      senderName: json['senderName'] as String?,
    );

Map<String, dynamic> _$WeatherAlertToJson(_WeatherAlert instance) =>
    <String, dynamic>{
      'event': instance.event,
      'description': instance.description,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'severity': instance.severity,
      'senderName': instance.senderName,
    };

_Location _$LocationFromJson(Map<String, dynamic> json) => _Location(
  name: json['name'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  country: json['country'] as String?,
  state: json['state'] as String?,
  isFavorite: json['isFavorite'] as bool? ?? false,
);

Map<String, dynamic> _$LocationToJson(_Location instance) => <String, dynamic>{
  'name': instance.name,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'country': instance.country,
  'state': instance.state,
  'isFavorite': instance.isFavorite,
};

_AirQuality _$AirQualityFromJson(Map<String, dynamic> json) => _AirQuality(
  aqi: (json['aqi'] as num).toInt(),
  pm25: (json['pm25'] as num).toDouble(),
  pm10: (json['pm10'] as num).toDouble(),
  no2: (json['no2'] as num).toDouble(),
  so2: (json['so2'] as num).toDouble(),
  o3: (json['o3'] as num).toDouble(),
  co: (json['co'] as num).toDouble(),
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$AirQualityToJson(_AirQuality instance) =>
    <String, dynamic>{
      'aqi': instance.aqi,
      'pm25': instance.pm25,
      'pm10': instance.pm10,
      'no2': instance.no2,
      'so2': instance.so2,
      'o3': instance.o3,
      'co': instance.co,
      'timestamp': instance.timestamp.toIso8601String(),
    };
