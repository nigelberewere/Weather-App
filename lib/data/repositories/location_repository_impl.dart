import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:hive/hive.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherly/core/errors/app_error.dart';
import 'package:weatherly/data/datasources/weather_api_client.dart';
import 'package:weatherly/domain/entities/weather.dart';
import 'package:weatherly/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  static const String _favoritesBoxName = 'favorites';
  final WeatherApiClient _apiClient;

  String get _apiKey {
    try {
      return dotenv.env['OPENWEATHER_API_KEY'] ?? 'demo_key_for_testing';
    } catch (e) {
      return 'demo_key_for_testing';
    }
  }

  LocationRepositoryImpl(this._apiClient);

  @override
  Future<({Location? data, AppError? error})> getCurrentLocation() async {
    try {
      debugPrint('LocationRepository: Getting current location...');
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      debugPrint('LocationRepository: Service enabled: $serviceEnabled');
      if (!serviceEnabled) {
        return (
          data: null,
          error: const AppError.location('Location services are disabled'),
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('LocationRepository: Initial permission: $permission');
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        debugPrint('LocationRepository: Requested permission: $permission');
        if (permission == LocationPermission.denied) {
          return (
            data: null,
            error: const AppError.permission('Location permission denied'),
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('LocationRepository: Permission denied forever');
        return (
          data: null,
          error: const AppError.permission(
            'Location permission permanently denied',
          ),
        );
      }

      debugPrint('LocationRepository: Fetching position...');
      final position =
          await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 30),
          ).timeout(
            const Duration(seconds: 35),
            onTimeout: () => throw AppError.location('Location fetch timeout'),
          );
      debugPrint(
        'LocationRepository: Position fetched: ${position.latitude}, ${position.longitude}',
      );

      String locationName = 'Current Location';
      String? country;
      String? state;

      try {
        debugPrint('LocationRepository: Reverse geocoding...');
        final placemarks = await geo.placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        debugPrint(
          'LocationRepository: Placemarks found: ${placemarks.length}',
        );

        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          locationName =
              placemark.locality ??
              placemark.subLocality ??
              placemark.name ??
              'Unknown Location';
          country = placemark.country;
          state = placemark.administrativeArea;
        }
      } catch (e) {
        debugPrint('LocationRepository: Reverse geocoding failed: $e');

        // Fallback to API search
        try {
          debugPrint(
            'LocationRepository: Attempting API fallback for reverse geocoding...',
          );
          final results = await _apiClient
              .searchLocations(
                lat: position.latitude,
                lon: position.longitude,
                apiKey: _apiKey,
              )
              .timeout(const Duration(seconds: 20));

          if (results.isNotEmpty) {
            final result = results.first;
            locationName = result.name;
            country = result.country;
            state = result.state;
            debugPrint(
              'LocationRepository: API fallback successful: $locationName',
            );
          }
        } catch (apiError) {
          debugPrint('LocationRepository: API fallback failed: $apiError');
          // Use a sensible fallback name based on coordinates
          locationName =
              'Location (${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)})';
        }
      }

      final location = Location(
        name: locationName,
        latitude: position.latitude,
        longitude: position.longitude,
        country: country,
        state: state,
      );
      debugPrint(
        'LocationRepository: Location object created: ${location.name}',
      );

      // Save location for background fetch
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('last_location_lat', location.latitude);
        await prefs.setDouble('last_location_lon', location.longitude);
        await prefs.setString('last_location_name', location.name);
        if (location.country != null) {
          await prefs.setString('last_location_country', location.country!);
        }
        if (location.state != null) {
          await prefs.setString('last_location_state', location.state!);
        }
        debugPrint('✅ Location saved for background fetch');
      } catch (e) {
        debugPrint('⚠️ Failed to save location for background fetch: $e');
      }

      return (data: location, error: null);
    } catch (e) {
      debugPrint('LocationRepository: Error getting location: $e');
      return (data: null, error: AppError.location(e.toString()));
    }
  }

  @override
  Future<({List<Location>? data, AppError? error})> searchLocations(
    String query,
  ) async {
    try {
      final results = await _apiClient.getDirectGeocoding(
        query: query,
        apiKey: _apiKey,
      );

      final locations = results.map((data) {
        return Location(
          name: data.name,
          latitude: data.lat,
          longitude: data.lon,
          country: data.country,
          state: data.state,
        );
      }).toList();

      return (data: locations, error: null);
    } catch (e) {
      return (
        data: null,
        error: AppError.location('Search failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<({List<Location>? data, AppError? error})>
  getFavoriteLocations() async {
    try {
      final box = await Hive.openBox<Map>(_favoritesBoxName);
      final favorites = box.values.map((map) {
        return Location.fromJson(Map<String, dynamic>.from(map));
      }).toList();
      return (data: favorites, error: null);
    } catch (e) {
      return (
        data: null,
        error: AppError.cache('Failed to load favorites: ${e.toString()}'),
      );
    }
  }

  @override
  Future<({bool success, AppError? error})> addFavoriteLocation(
    Location location,
  ) async {
    try {
      final box = await Hive.openBox<Map>(_favoritesBoxName);
      final key = '${location.latitude}_${location.longitude}';
      await box.put(key, location.toJson());
      return (success: true, error: null);
    } catch (e) {
      return (
        success: false,
        error: AppError.cache('Failed to add favorite: ${e.toString()}'),
      );
    }
  }

  @override
  Future<({bool success, AppError? error})> removeFavoriteLocation(
    Location location,
  ) async {
    try {
      final box = await Hive.openBox<Map>(_favoritesBoxName);
      final key = '${location.latitude}_${location.longitude}';
      await box.delete(key);
      return (success: true, error: null);
    } catch (e) {
      return (
        success: false,
        error: AppError.cache('Failed to remove favorite: ${e.toString()}'),
      );
    }
  }

  @override
  Future<({Location? data, AppError? error})> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks = await geo.placemarkFromCoordinates(
        latitude,
        longitude,
      );
      final placemark = placemarks.first;

      final location = Location(
        name: placemark.locality ?? placemark.name ?? 'Unknown',
        latitude: latitude,
        longitude: longitude,
        country: placemark.country,
        state: placemark.administrativeArea,
      );

      return (data: location, error: null);
    } catch (e) {
      return (
        data: null,
        error: AppError.location('Reverse geocode failed: ${e.toString()}'),
      );
    }
  }
}
