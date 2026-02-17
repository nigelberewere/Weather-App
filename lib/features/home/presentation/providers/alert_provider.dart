import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/errors/app_error.dart';
import 'package:weatherly/core/providers/notification_providers.dart';
import 'package:weatherly/core/providers/providers.dart';
import 'package:weatherly/domain/entities/weather.dart';
import 'package:weatherly/features/home/presentation/providers/weather_provider.dart';

// Provider to monitor weather alerts for the current location
final weatherAlertsProvider =
    FutureProvider.family<List<WeatherAlert>, Location>((ref, location) async {
      final repository = ref.watch(weatherRepositoryProvider);

      final result = await repository.getWeatherAlerts(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      if (result.error != null) {
        // Simply throw the error message
        final errorMessage = switch (result.error!) {
          NetworkError(:final message) => message,
          ServerError(:final message) => message,
          LocationError(:final message) => message,
          PermissionError(:final message) => message,
          CacheError(:final message) => message,
          UnknownError(:final message) => message,
        };
        throw Exception(errorMessage);
      }

      return result.data ?? [];
    });

// Provider to start alert monitoring when location is available
final alertMonitoringProvider = Provider<void>((ref) {
  final locationAsync = ref.watch(currentLocationProvider);
  final alertService = ref.watch(weatherAlertServiceProvider);
  final settings = ref.watch(notificationSettingsProvider);

  locationAsync.whenData((location) {
    if (location != null && settings.alertsEnabled) {
      // Start monitoring with the current location
      alertService.startMonitoring(
        latitude: location.latitude,
        longitude: location.longitude,
      );
    } else {
      alertService.stopMonitoring();
    }
  });
});
