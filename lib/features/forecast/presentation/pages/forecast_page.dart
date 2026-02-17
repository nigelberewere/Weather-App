import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/errors/app_error.dart';
import 'package:weatherly/core/providers/providers.dart';
import 'package:weatherly/core/providers/settings_providers.dart';
import 'package:weatherly/core/widgets/enhanced_states.dart';
import 'package:weatherly/domain/entities/weather.dart';
import 'package:weatherly/core/theme/app_colors.dart';
import 'package:weatherly/core/widgets/weather_background.dart';
import 'package:weatherly/features/forecast/presentation/widgets/forecast_charts.dart';
import 'package:weatherly/features/forecast/presentation/widgets/hourly_forecast_list.dart';
import 'package:weatherly/features/forecast/presentation/widgets/daily_forecast_list.dart';
import 'package:weatherly/core/localization/app_localizations.dart';
import 'package:weatherly/features/home/presentation/providers/weather_provider.dart';

final hourlyForecastProvider =
    FutureProvider.family<List<HourlyForecast>?, Location>((
      ref,
      location,
    ) async {
      final repository = ref.watch(weatherRepositoryProvider);
      final unitsAsync = ref.watch(weatherApiUnitsProvider);
      final units = await unitsAsync.when<Future<String>>(
        data: (u) async => u,
        loading: () async => 'metric',
        error: (error, stack) async => 'metric',
      );
      final result = await repository.getHourlyForecast(
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

final dailyForecastProvider =
    FutureProvider.family<List<DailyForecast>?, Location>((
      ref,
      location,
    ) async {
      final repository = ref.watch(weatherRepositoryProvider);
      final unitsAsync = ref.watch(weatherApiUnitsProvider);
      final units = await unitsAsync.when<Future<String>>(
        data: (u) async => u,
        loading: () async => 'metric',
        error: (error, stack) async => 'metric',
      );
      final result = await repository.getDailyForecast(
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

class ForecastPage extends ConsumerWidget {
  final Location? location;

  const ForecastPage({super.key, this.location});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    if (location == null) {
      return Center(child: Text(l10n.selectLocation));
    }

    final weatherAsync = ref.watch(currentWeatherProvider(location!));
    final condition = weatherAsync.value?.condition ?? _getTimeBasedCondition();

    return WeatherBackground(
      condition: condition,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(location!.name),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            bottom: TabBar(
              indicatorColor: AppColors.accent,
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: [
                Tab(text: l10n.hourlyForecast),
                Tab(text: l10n.dailyForecast),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildHourlyForecast(context, ref, location!),
              _buildDailyForecast(context, ref, location!),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeBasedCondition() {
    final hour = DateTime.now().hour;
    final isNight = hour < 6 || hour >= 18;
    return isNight ? 'clear_night' : 'sunny';
  }

  Widget _buildHourlyForecast(
    BuildContext context,
    WidgetRef ref,
    Location location,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final forecastAsync = ref.watch(hourlyForecastProvider(location));

    return forecastAsync.when(
      data: (forecast) {
        if (forecast == null || forecast.isEmpty) {
          return EmptyStateDisplay(
            title: l10n.noForecastData,
            subtitle: 'Forecast data is not available at this time',
            icon: Icons.cloud_off_outlined,
          );
        }
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: HourlyForecastChart(forecasts: forecast),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 20,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Hourly Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(child: HourlyForecastList(forecasts: forecast)),
          ],
        );
      },
      loading: () =>
          const EnhancedLoadingIndicator(message: 'Loading hourly forecast...'),
      error: (error, stack) =>
          EnhancedErrorDisplay(message: l10n.error, subtitle: error.toString()),
    );
  }

  Widget _buildDailyForecast(
    BuildContext context,
    WidgetRef ref,
    Location location,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final forecastAsync = ref.watch(dailyForecastProvider(location));

    return forecastAsync.when(
      data: (forecast) {
        if (forecast == null || forecast.isEmpty) {
          return EmptyStateDisplay(
            title: l10n.noForecastData,
            subtitle: 'Forecast data is not available at this time',
            icon: Icons.cloud_off_outlined,
          );
        }
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DailyForecastChart(forecasts: forecast),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Daily Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(child: DailyForecastList(forecasts: forecast)),
          ],
        );
      },
      loading: () =>
          const EnhancedLoadingIndicator(message: 'Loading daily forecast...'),
      error: (error, stack) =>
          EnhancedErrorDisplay(message: l10n.error, subtitle: error.toString()),
    );
  }
}
