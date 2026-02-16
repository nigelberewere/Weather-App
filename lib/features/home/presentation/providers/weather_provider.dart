import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/errors/app_error.dart';
import 'package:weatherly/core/providers/providers.dart';
import 'package:weatherly/core/providers/settings_providers.dart';
import 'package:weatherly/domain/entities/weather.dart';

final currentLocationProvider = FutureProvider<Location?>((ref) async {
  final repository = ref.watch(locationRepositoryProvider);
  final result = await repository.getCurrentLocation();
  return result.data;
});

final currentWeatherProvider = FutureProvider.family<Weather?, Location>((
  ref,
  location,
) async {
  final repository = ref.watch(weatherRepositoryProvider);
  final unitsAsync = ref.watch(weatherApiUnitsProvider);
  
  final units = await unitsAsync.when<Future<String>>(
    data: (u) async => u,
    loading: () async => 'metric',
    error: (_, __) async => 'metric',
  );
  
  final result = await repository.getCurrentWeather(
    latitude: location.latitude,
    longitude: location.longitude,
    units: units,
  );
  if (result.error != null) {
    throw result.error!.when(
      network: (message) => message,
      server: (message) => message,
      location: (message) => message,
      permission: (message) => message,
      cache: (message) => message,
      unknown: (message) => message,
    );
  }
  return result.data;
});

final airQualityProvider = FutureProvider.family<AirQuality?, Location>((
  ref,
  location,
) async {
  final repository = ref.watch(weatherRepositoryProvider);
  
  final result = await repository.getAirQuality(
    latitude: location.latitude,
    longitude: location.longitude,
  );
  if (result.error != null) {
    throw result.error!.when(
      network: (message) => message,
      server: (message) => message,
      location: (message) => message,
      permission: (message) => message,
      cache: (message) => message,
      unknown: (message) => message,
    );
  }
  return result.data;
});
