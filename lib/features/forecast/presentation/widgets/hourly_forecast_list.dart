import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/localization/app_localizations.dart';
import 'package:weatherly/core/utils/date_formatter.dart';
import 'package:weatherly/core/utils/unit_converter.dart';
import 'package:weatherly/core/widgets/weather_icon.dart';
import 'package:weatherly/core/providers/settings_providers.dart';
import 'package:weatherly/domain/entities/weather.dart';

class HourlyForecastList extends ConsumerWidget {
  final List<HourlyForecast> forecasts;

  const HourlyForecastList({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final unitAsync = ref.watch(unitPreferenceProvider);

    return unitAsync.when(
      data: (unit) => _buildList(context, unit),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('${l10n.error}: $error')),
    );
  }

  Widget _buildList(BuildContext context, String unit) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: forecasts.length,
      itemBuilder: (context, index) {
        final forecast = forecasts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    DateFormatter.formatHour(forecast.time),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: WeatherIcon(condition: forecast.condition, size: 24),
                ),
              ],
            ),
            title: Text(
              UnitConverter.formatTemperature(forecast.temperature, unit),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(forecast.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.water_drop, size: 16),
                const SizedBox(width: 4),
                Text('${forecast.precipitationProbability}%'),
              ],
            ),
          ),
        );
      },
    );
  }
}
