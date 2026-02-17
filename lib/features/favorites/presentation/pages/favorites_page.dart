import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/localization/app_localizations.dart';
import 'package:weatherly/core/providers/providers.dart';
import 'package:weatherly/core/providers/settings_providers.dart';
import 'package:weatherly/core/utils/unit_converter.dart';
import 'package:weatherly/core/widgets/weather_icon.dart';
import 'package:weatherly/domain/entities/weather.dart';
import 'package:weatherly/features/home/presentation/providers/weather_provider.dart';

final favoritesProvider = FutureProvider<List<Location>>((ref) async {
  final repository = ref.watch(locationRepositoryProvider);
  final result = await repository.getFavoriteLocations();
  return result.data ?? [];
});

class FavoritesPage extends ConsumerWidget {
  final ValueChanged<Location> onLocationSelected;

  const FavoritesPage({super.key, required this.onLocationSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.favorites)),
      body: favoritesAsync.when(
        data: (favorites) {
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noFavoriteLocations,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.addLocationsToFavorites,
                    style: TextStyle(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(favoritesProvider);
              for (final location in favorites) {
                ref.invalidate(currentWeatherProvider(location));
              }
            },
            child: ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final location = favorites[index];
                return FavoriteWeatherTile(
                  location: location,
                  onRemove: () async {
                    final repository = ref.read(locationRepositoryProvider);
                    await repository.removeFavoriteLocation(location);
                    ref.invalidate(favoritesProvider);
                  },
                  onTap: () {
                    onLocationSelected(location);
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('${l10n.error}: $error')),
      ),
    );
  }
}

class FavoriteWeatherTile extends ConsumerWidget {
  final Location location;
  final VoidCallback onTap;
  final Future<void> Function() onRemove;

  const FavoriteWeatherTile({
    super.key,
    required this.location,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitAsync = ref.watch(unitPreferenceProvider);
    final weatherAsync = ref.watch(currentWeatherProvider(location));
    final subtitle = '${location.state ?? ''} ${location.country ?? ''}'.trim();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: weatherAsync.when(
          data: (weather) {
            if (weather?.condition == null) {
              return const Icon(Icons.cloud, color: Colors.blueGrey);
            }
            return WeatherIcon(condition: weather!.condition, size: 32);
          },
          loading: () => const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          error: (_, __) => const Icon(Icons.cloud_off, color: Colors.grey),
        ),
        title: Text(location.name),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            weatherAsync.when(
              data: (weather) {
                if (weather == null) {
                  return const SizedBox.shrink();
                }
                return unitAsync.when(
                  data: (unit) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        UnitConverter.formatTemperature(
                          weather.temperature,
                          unit,
                        ),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        weather.description,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  loading: () => const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                );
              },
              loading: () => const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
            IconButton(icon: const Icon(Icons.delete), onPressed: onRemove),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
