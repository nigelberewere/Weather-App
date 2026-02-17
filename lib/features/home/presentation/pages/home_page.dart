import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:weatherly/core/utils/date_formatter.dart';
import 'package:weatherly/core/utils/unit_converter.dart';
import 'package:weatherly/core/utils/page_transitions.dart';
import 'package:weatherly/core/widgets/enhanced_states.dart';
import 'package:weatherly/domain/entities/weather.dart';
import 'package:weatherly/features/forecast/presentation/pages/forecast_page.dart';
import 'package:weatherly/features/map/presentation/pages/map_page.dart';
import 'package:weatherly/features/favorites/presentation/pages/favorites_page.dart';
import 'package:weatherly/features/settings/presentation/pages/settings_page.dart';
import 'package:weatherly/features/home/presentation/widgets/current_weather_card.dart';
import 'package:weatherly/features/home/presentation/widgets/weather_details_card.dart';
import 'package:weatherly/features/home/presentation/widgets/health_cards.dart';
import 'package:weatherly/features/search/presentation/pages/search_page.dart';
import 'package:weatherly/core/localization/app_localizations.dart';
import 'package:weatherly/core/widgets/weather_background.dart';
import 'package:weatherly/features/home/presentation/providers/weather_provider.dart';
import 'package:weatherly/features/home/presentation/providers/alert_provider.dart';
import 'package:weatherly/features/home/presentation/widgets/weather_alert_banner.dart';
import 'package:weatherly/core/providers/settings_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  Location? _selectedLocation;
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    // Set up auto-refresh timer: refresh weather every 5 minutes
    _autoRefreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (_selectedLocation != null && mounted) {
        ref.invalidate(currentWeatherProvider(_selectedLocation!));
        ref.invalidate(airQualityProvider(_selectedLocation!));
        debugPrint('⏰ Auto-refresh triggered');
      }
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final locationAsync = ref.watch(currentLocationProvider);

    // Initialize alert monitoring
    ref.watch(alertMonitoringProvider);

    return Scaffold(
      body: _selectedIndex == 0
          ? locationAsync.when(
              data: (location) {
                if (location == null) {
                  return EnhancedErrorDisplay(
                    message: l10n.locationPermissionDenied,
                    subtitle: 'Please enable location access to view weather',
                    icon: Icons.location_off,
                    onRetry: () {
                      ref.invalidate(currentLocationProvider);
                    },
                  );
                }

                _selectedLocation ??= location;
                return _buildWeatherContent(_selectedLocation!);
              },
              loading: () => const EnhancedLoadingIndicator(
                message: 'Getting your location...',
              ),
              error: (error, stack) => EnhancedErrorDisplay(
                message: l10n.error,
                subtitle: error.toString(),
                onRetry: () {
                  ref.invalidate(currentLocationProvider);
                },
              ),
            )
          : _getPageForIndex(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          elevation: 0,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: l10n.home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_today_outlined),
              selectedIcon: const Icon(Icons.calendar_today),
              label: l10n.forecast,
            ),
            NavigationDestination(
              icon: const Icon(Icons.map_outlined),
              selectedIcon: const Icon(Icons.map),
              label: l10n.map,
            ),
            NavigationDestination(
              icon: const Icon(Icons.favorite_outline),
              selectedIcon: const Icon(Icons.favorite),
              label: l10n.favorites,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: l10n.settings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent(Location location) {
    final l10n = AppLocalizations.of(context)!;
    final weatherAsync = ref.watch(currentWeatherProvider(location));
    final unitAsync = ref.watch(unitPreferenceProvider);

    return weatherAsync.when(
      data: (weather) {
        if (weather == null) {
          return Center(child: Text(l10n.noDataAvailable));
        }

        return WeatherBackground(
          condition: weather.condition ?? 'sunny',
          child: RefreshIndicator(
            displacement: 40,
            onRefresh: () async {
              // Force refresh both weather and air quality data
              ref.invalidate(currentWeatherProvider(location));
              ref.invalidate(airQualityProvider(location));
              // Wait for the refresh to complete
              await ref.read(currentWeatherProvider(location).future);
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 100,
                  floating: true,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: FlexibleSpaceBar(
                        title: Text(location.name),
                        centerTitle: true,
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          PageTransitions.slideFromRight<Location>(
                            SearchPage(currentCondition: weather.condition),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            _selectedLocation = result;
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        ref.invalidate(currentWeatherProvider(location));
                        ref.invalidate(airQualityProvider(location));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: unitAsync.maybeWhen(
                        data: (unit) => () {
                          final text = _buildShareText(
                            location: location,
                            weather: weather,
                            unit: unit,
                          );
                          Share.share(
                            text,
                            subject: 'Weather in ${location.name}',
                          );
                        },
                        orElse: () => null,
                      ),
                    ),
                  ],
                ),
                // Weather alerts banner
                SliverToBoxAdapter(
                  child: ref
                      .watch(weatherAlertsProvider(location))
                      .when(
                        data: (alerts) => WeatherAlertBanner(alerts: alerts),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      CurrentWeatherCard(weather: weather),
                      const SizedBox(height: 32),
                      WeatherDetailsCard(weather: weather),
                      const SizedBox(height: 32),
                      // Air Quality and UV Health Guidance Cards
                      ref
                          .watch(airQualityProvider(location))
                          .when(
                            data: (airQuality) {
                              if (airQuality != null) {
                                return Column(
                                  children: [
                                    AirQualityCard(airQuality: airQuality),
                                    const SizedBox(height: 20),
                                    UVHealthGuidanceCard(
                                      uvIndex: weather.uvIndex,
                                    ),
                                    const SizedBox(height: 80),
                                  ],
                                );
                              }
                              return UVHealthGuidanceCard(
                                uvIndex: weather.uvIndex,
                              );
                            },
                            loading: () =>
                                UVHealthGuidanceCard(uvIndex: weather.uvIndex),
                            error: (_, __) =>
                                UVHealthGuidanceCard(uvIndex: weather.uvIndex),
                          ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () =>
          const EnhancedLoadingIndicator(message: 'Loading weather data...'),
      error: (error, stack) => EnhancedErrorDisplay(
        message: l10n.error,
        subtitle: error.toString(),
        onRetry: () {
          ref.invalidate(currentWeatherProvider(location));
        },
      ),
    );
  }

  String _buildShareText({
    required Location location,
    required Weather weather,
    required String unit,
  }) {
    final temp = UnitConverter.formatTemperature(weather.temperature, unit);
    final feelsLike = UnitConverter.formatTemperature(weather.feelsLike, unit);
    final wind = UnitConverter.formatWindSpeed(weather.windSpeed, unit);
    final visibility = UnitConverter.formatVisibility(weather.visibility, unit);
    final updatedAt = DateFormatter.formatDateTime(weather.timestamp.toLocal());

    return 'Weather in ${location.name}\n'
        '$temp, ${weather.description}\n'
        'Feels like: $feelsLike\n'
        'Humidity: ${weather.humidity}%\n'
        'Wind: $wind\n'
        'Visibility: $visibility\n'
        'Updated: $updatedAt\n'
        '#Weatherly';
  }

  Widget _getPageForIndex(int index) {
    switch (index) {
      case 1:
        return ForecastPage(location: _selectedLocation);
      case 2:
        return MapPage(location: _selectedLocation);
      case 3:
        return FavoritesPage(
          onLocationSelected: (location) {
            setState(() {
              _selectedLocation = location;
              _selectedIndex = 0;
            });
          },
        );
      case 4:
        return const SettingsPage();
      default:
        return const Center(child: Text('Home'));
    }
  }
}
