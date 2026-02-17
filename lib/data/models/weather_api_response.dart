import 'package:json_annotation/json_annotation.dart';

part 'weather_api_response.g.dart';

@JsonSerializable()
class WeatherApiResponse {
  final Map<String, dynamic>? location;
  final Map<String, dynamic>? current;
  final Map<String, dynamic>? forecast;

  WeatherApiResponse({this.location, this.current, this.forecast});

  factory WeatherApiResponse.fromJson(Map<String, dynamic> json) =>
      _$WeatherApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherApiResponseToJson(this);
}
