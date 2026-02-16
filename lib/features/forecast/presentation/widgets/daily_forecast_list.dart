import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/localization/app_localizations.dart';
import 'package:weatherly/core/utils/date_formatter.dart';
import 'package:weatherly/core/utils/unit_converter.dart';
import 'package:weatherly/core/widgets/weather_icon.dart';
import 'package:weatherly/core/providers/settings_providers.dart';
import 'package:weatherly/domain/entities/weather.dart';

class DailyForecastList extends ConsumerWidget {
  final List<DailyForecast> forecasts;

  const DailyForecastList({super.key, required this.forecasts});

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
            leading: SizedBox(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormatter.formatShortDay(forecast.date),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    DateFormatter.formatDate(forecast.date).split(',')[0],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            title: Row(
              children: [
                WeatherIcon(condition: forecast.condition, size: 32),
                const SizedBox(width: 8),
                Text(
                  UnitConverter.formatTemperature(forecast.tempMax, unit),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '/',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(width: 4),
                Text(
                  UnitConverter.formatTemperature(forecast.tempMin, unit),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
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
