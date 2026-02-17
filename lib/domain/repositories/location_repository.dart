import 'package:weatherly/core/errors/app_error.dart';
import 'package:weatherly/domain/entities/weather.dart';

abstract class LocationRepository {
  Future<({Location? data, AppError? error})> getCurrentLocation();

  Future<({List<Location>? data, AppError? error})> searchLocations(
    String query,
  );

  Future<({List<Location>? data, AppError? error})> getFavoriteLocations();

  Future<({bool success, AppError? error})> addFavoriteLocation(
    Location location,
  );

  Future<({bool success, AppError? error})> removeFavoriteLocation(
    Location location,
  );

  Future<({Location? data, AppError? error})> reverseGeocode({
    required double latitude,
    required double longitude,
  });
}
