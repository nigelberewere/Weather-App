import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Unit preference persistent provider
final unitPreferenceProvider =
    AsyncNotifierProvider<UnitPreferenceNotifier, String>(
      UnitPreferenceNotifier.new,
    );

class UnitPreferenceNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    return _loadUnitPreference();
  }

  Future<String> _loadUnitPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('unit_preference') ?? 'metric';
    } catch (e) {
      return 'metric'; // Default if error
    }
  }

  Future<void> setUnit(String unit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('unit_preference', unit);
      state = AsyncValue.data(unit);
    } catch (e) {
      // Keep current state on error
    }
  }
}

// Temperature display format provider
final temperatureFormatProvider = FutureProvider<String>((ref) async {
  final unitAsync = ref.watch(unitPreferenceProvider);
  return unitAsync.when(
    data: (u) => u == 'metric' ? '°C' : '°F',
    loading: () => '°C',
    error: (error, stack) => '°C',
  );
});

// Weather API units provider - maps preference to OpenWeatherMap units
final weatherApiUnitsProvider = FutureProvider<String>((ref) async {
  final unitAsync = ref.watch(unitPreferenceProvider);
  return unitAsync.when(
    data: (u) => u,
    loading: () => 'metric',
    error: (error, stack) => 'metric',
  );
});

// Wind speed display format provider
final windSpeedFormatProvider = FutureProvider<String>((ref) async {
  final unitAsync = ref.watch(unitPreferenceProvider);
  return unitAsync.when(
    data: (u) => u == 'metric' ? 'km/h' : 'mph',
    loading: () => 'km/h',
    error: (error, stack) => 'km/h',
  );
});

// Visibility format provider
final visibilityFormatProvider = FutureProvider<String>((ref) async {
  final unitAsync = ref.watch(unitPreferenceProvider);
  return unitAsync.when(
    data: (u) => u == 'metric' ? 'km' : 'mi',
    loading: () => 'km',
    error: (error, stack) => 'km',
  );
});
