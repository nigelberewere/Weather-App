import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/localization/app_localizations.dart';
import 'package:weatherly/core/utils/date_formatter.dart';
import 'package:weatherly/core/utils/unit_converter.dart';
import 'package:weatherly/core/widgets/weather_icon.dart';
import 'package:weatherly/core/providers/settings_providers.dart';
import 'package:weatherly/domain/entities/weather.dart';
import 'dart:ui';

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
      error: (error, stackTrace) =>
          Center(child: Text('${l10n.error}: $error')),
    );
  }

  Widget _buildList(BuildContext context, String unit) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: forecasts.length,
      itemBuilder: (context, index) {
        final forecast = forecasts[index];
        final isNow = index == 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Time and weather icon
                    SizedBox(
                      width: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isNow
                                ? 'Now'
                                : DateFormatter.formatHour(forecast.time),
                            style: TextStyle(
                              fontSize: isNow ? 18 : 16,
                              fontWeight: isNow
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          WeatherIcon(condition: forecast.condition, size: 40),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Temperature and description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            UnitConverter.formatTemperature(
                              forecast.temperature,
                              unit,
                            ),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            forecast.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Weather details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildDetailRow(
                          Icons.water_drop_outlined,
                          '${forecast.precipitationProbability}%',
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          Icons.air,
                          '${forecast.windSpeed.toStringAsFixed(0)} ${_getWindUnit(unit)}',
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          Icons.thermostat_outlined,
                          UnitConverter.formatTemperature(
                            forecast.feelsLike,
                            unit,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.white.withOpacity(0.7)),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getWindUnit(String unit) {
    switch (unit) {
      case 'imperial':
        return 'mph';
      case 'metric':
      default:
        return 'm/s';
    }
  }
}
