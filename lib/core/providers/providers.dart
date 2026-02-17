import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/constants/app_constants.dart';
import 'package:weatherly/core/services/weather_cache_service.dart';
import 'package:weatherly/data/datasources/weather_api_client.dart';
import 'package:weatherly/data/repositories/location_repository_impl.dart';
import 'package:weatherly/data/repositories/weather_repository_impl.dart';
import 'package:weatherly/domain/repositories/location_repository.dart';
import 'package:weatherly/domain/repositories/weather_repository.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.weatherApiBaseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
    ),
  );
  return dio;
});

final weatherApiClientProvider = Provider<WeatherApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return WeatherApiClient(dio);
});

final weatherCacheServiceProvider = Provider<WeatherCacheService>((ref) {
  return WeatherCacheService();
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final apiClient = ref.watch(weatherApiClientProvider);
  final cacheService = ref.watch(weatherCacheServiceProvider);
  return WeatherRepositoryImpl(apiClient, cacheService);
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final apiClient = ref.watch(weatherApiClientProvider);
  return LocationRepositoryImpl(apiClient);
});
