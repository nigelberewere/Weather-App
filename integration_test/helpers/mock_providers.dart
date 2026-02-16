import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/domain/entities/weather.dart';

/// Mock providers for integration testing
/// These can be used to override real providers with test data

/// Mock current location provider
final mockCurrentLocationProvider = Provider<Location?>((ref) => null);

/// Mock weather provider
final mockWeatherProvider = FutureProvider<Weather?>((ref) async {
  return null;
});

/// Mock unit preference - defaults to metric
final mockUnitPreferenceProvider = Provider<String>((ref) => 'metric');

/// Mock theme mode preference
final mockThemeModeProvider = Provider<String>((ref) => 'system');

/// Mock has seen onboarding
final mockHasSeenOnboardingProvider = FutureProvider<bool>((ref) async {
  return true;
});

/// Helper to create a test ProviderContainer with mocked providers
ProviderContainer createTestProviderContainer() {
  return ProviderContainer(
    overrides: [
      mockCurrentLocationProvider.overrideWithValue(
        const Location(
          name: 'Test City',
          latitude: 40.7128,
          longitude: -74.0060,
          country: 'Test Country',
          state: 'Test State',
        ),
      ),
      mockUnitPreferenceProvider.overrideWithValue('metric'),
      mockThemeModeProvider.overrideWithValue('light'),
      mockHasSeenOnboardingProvider.overrideWithValue(
        const AsyncValue.data(true),
      ),
    ],
  );
}

/// Extension method for easy provider override in tests
extension ProviderContainerX on ProviderContainer {
  /// Override a location for testing
  /// Note: Providers are immutable, use overrideWithValue at creation instead
  void setTestLocation(Location location) {
    // Provider values cannot be mutated after creation
    // Use overrideWithValue when creating the container
  }

  /// Override temperature unit for testing
  /// Note: Providers are immutable, use overrideWithValue at creation instead
  void setTestUnit(String unit) {
    // Provider values cannot be mutated after creation
    // Use overrideWithValue when creating the container
  }

  /// Override theme mode for testing
  /// Note: Providers are immutable, use overrideWithValue at creation instead
  void setTestTheme(String theme) {
    // Provider values cannot be mutated after creation
    // Use overrideWithValue when creating the container
  }
}
