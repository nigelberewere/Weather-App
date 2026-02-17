import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/providers/providers.dart';
import 'package:weatherly/core/providers/settings_providers.dart';
import 'package:weatherly/domain/entities/weather.dart';

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  @override
  String toString() => message;
}

final currentLocationProvider = FutureProvider<Location?>((ref) async {
  try {
    final repository = ref.watch(locationRepositoryProvider);
    final result = await repository.getCurrentLocation();
    if (result.error != null) {
      // Return a fallback location if permission/service is denied
      return const Location(
        name: 'Mountain View',
        latitude: 37.4419,
        longitude: -122.1430,
        country: 'United States',
        state: 'California',
      );
    }
    return result.data;
  } catch (e) {
    // Fallback location on any error
    return const Location(
      name: 'Mountain View',
      latitude: 37.4419,
      longitude: -122.1430,
      country: 'United States',
      state: 'California',
    );
  }
});

final currentWeatherProvider = FutureProvider.family<Weather?, Location>((
  ref,
  location,
) async {
  try {
    final repository = ref.watch(weatherRepositoryProvider);
    final unitsAsync = ref.watch(weatherApiUnitsProvider);

    final units = await unitsAsync.when<Future<String>>(
      data: (u) async => u,
      loading: () async => 'metric',
      error: (error, stack) async => 'metric',
    );

    final result = await repository
        .getCurrentWeather(
          latitude: location.latitude,
          longitude: location.longitude,
          units: units,
        )
        .timeout(
          const Duration(seconds: 45),
          onTimeout: () => throw TimeoutException('Weather fetch timed out'),
        );

    if (result.error != null) {
      // Return null instead of throwing to show loading state
      return null;
    }
    return result.data;
  } on TimeoutException catch (_) {
    return null; // Show loading state instead of error
  } catch (e) {
    return null; // Show loading state instead of crashing
  }
});

final airQualityProvider = FutureProvider.family<AirQuality?, Location>((
  ref,
  location,
) async {
  try {
    final repository = ref.watch(weatherRepositoryProvider);

    final result = await repository
        .getAirQuality(
          latitude: location.latitude,
          longitude: location.longitude,
        )
        .timeout(
          const Duration(seconds: 45),
          onTimeout: () =>
              throw TimeoutException('Air quality fetch timed out'),
        );

    if (result.error != null) {
      return null; // Show loading state
    }
    return result.data;
  } on TimeoutException catch (_) {
    return null; // Timeout - show loading state
  } catch (e) {
    return null; // Error - show loading state
  }
});
