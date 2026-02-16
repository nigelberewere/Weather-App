import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:weatherly/data/models/open_weather_map_response.dart';
import 'package:weatherly/data/models/air_quality_response.dart';

part 'weather_api_client.g.dart';

@RestApi()
abstract class WeatherApiClient {
  factory WeatherApiClient(Dio dio, {String baseUrl}) = _WeatherApiClient;

  @GET('/weather')
  Future<OpenWeatherCurrentResponse> getCurrentWeather({
    @Query('lat') required double lat,
    @Query('lon') required double lon,
    @Query('appid') required String apiKey,
    @Query('units') String units = 'metric',
  });

  @GET('/forecast')
  Future<OpenWeatherForecastResponse> getForecast({
    @Query('lat') required double lat,
    @Query('lon') required double lon,
    @Query('appid') required String apiKey,
    @Query('units') String units = 'metric',
  });

  @GET('https://api.openweathermap.org/geo/1.0/reverse')
  Future<List<OpenWeatherLocation>> searchLocations({
    @Query('lat') required double lat,
    @Query('lon') required double lon,
    @Query('limit') int limit = 1,
    @Query('appid') required String apiKey,
  });

  @GET('https://api.openweathermap.org/geo/1.0/direct')
  Future<List<OpenWeatherLocation>> getDirectGeocoding({
    @Query('q') required String query,
    @Query('limit') int limit = 5,
    @Query('appid') required String apiKey,
  });

  @GET('https://api.openweathermap.org/data/3.0/air_pollution')
  Future<AirQualityResponse> getAirQuality({
    @Query('lat') required double lat,
    @Query('lon') required double lon,
    @Query('appid') required String apiKey,
  });
}
