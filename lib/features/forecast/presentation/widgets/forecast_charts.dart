import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/providers/settings_providers.dart';
import 'package:weatherly/core/utils/date_formatter.dart';
import 'package:weatherly/core/localization/app_localizations.dart';
import 'package:weatherly/domain/entities/weather.dart';

class HourlyForecastChart extends ConsumerWidget {
  final List<HourlyForecast> forecasts;

  const HourlyForecastChart({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final unitAsync = ref.watch(unitPreferenceProvider);

    return unitAsync.when(
      data: (unit) => _buildChart(context, unit),
      loading: () => const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => SizedBox(
        height: 180,
        child: Center(child: Text('${l10n.error}: $error')),
      ),
    );
  }

  Widget _buildChart(BuildContext context, String unit) {
    final tempSpots = <FlSpot>[];
    final precipSpots = <BarChartRodData>[];

    for (var i = 0; i < forecasts.length; i++) {
      final forecast = forecasts[i];
      tempSpots.add(FlSpot(i.toDouble(), forecast.temperature));
      precipSpots.add(
        BarChartRodData(
          toY: forecast.precipitationProbability.toDouble(),
          color: Colors.lightBlueAccent,
          width: 6,
          borderRadius: BorderRadius.circular(2),
        ),
      );
    }

    final temps = forecasts.map((f) => f.temperature).toList();
    final minTemp = temps.reduce((a, b) => a < b ? a : b);
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final padding = (maxTemp - minTemp) * 0.2;
    final minY = minTemp - padding;
    final maxY = maxTemp + padding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'Temperature',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              minY: minY,
              maxY: maxY,
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (value, meta) {
                      return Text(value.toStringAsFixed(0));
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: (forecasts.length / 4).clamp(1, 6),
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= forecasts.length) {
                        return const SizedBox.shrink();
                      }
                      final label = DateFormatter.formatHour(
                        forecasts[index].time,
                      );
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(label, style: const TextStyle(fontSize: 10)),
                      );
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: tempSpots,
                  isCurved: true,
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                  color: Colors.orangeAccent,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'Precipitation Probability',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 140,
          child: BarChart(
            BarChartData(
              maxY: 100,
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (value, meta) {
                      return Text('${value.toInt()}%');
                    },
                    interval: 25,
                  ),
                ),
                bottomTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              barGroups: List.generate(
                precipSpots.length,
                (index) => BarChartGroupData(
                  x: index,
                  barRods: [precipSpots[index]],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            'Units: ${_unitLabel(unit)}',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ),
      ],
    );
  }

  String _unitLabel(String unit) {
    switch (unit) {
      case 'imperial':
        return 'F';
      case 'kelvin':
        return 'K';
      case 'metric':
      default:
        return 'C';
    }
  }
}

class DailyForecastChart extends ConsumerWidget {
  final List<DailyForecast> forecasts;

  const DailyForecastChart({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final unitAsync = ref.watch(unitPreferenceProvider);

    return unitAsync.when(
      data: (unit) => _buildChart(context, unit),
      loading: () => const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => SizedBox(
        height: 180,
        child: Center(child: Text('${l10n.error}: $error')),
      ),
    );
  }

  Widget _buildChart(BuildContext context, String unit) {
    final maxTempSpots = <FlSpot>[];
    final minTempSpots = <FlSpot>[];
    final precipBars = <BarChartRodData>[];

    for (var i = 0; i < forecasts.length; i++) {
      final forecast = forecasts[i];
      maxTempSpots.add(FlSpot(i.toDouble(), forecast.tempMax));
      minTempSpots.add(FlSpot(i.toDouble(), forecast.tempMin));
      precipBars.add(
        BarChartRodData(
          toY: forecast.precipitationProbability.toDouble(),
          color: Colors.lightBlueAccent,
          width: 10,
          borderRadius: BorderRadius.circular(2),
        ),
      );
    }

    final temps = <double>[
      ...forecasts.map((f) => f.tempMax),
      ...forecasts.map((f) => f.tempMin),
    ];
    final minTemp = temps.reduce((a, b) => a < b ? a : b);
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final padding = (maxTemp - minTemp) * 0.2;
    final minY = minTemp - padding;
    final maxY = maxTemp + padding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'Daily Temperature',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              minY: minY,
              maxY: maxY,
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (value, meta) {
                      return Text(value.toStringAsFixed(0));
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= forecasts.length) {
                        return const SizedBox.shrink();
                      }
                      final label = DateFormatter.formatShortDay(
                        forecasts[index].date,
                      );
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(label, style: const TextStyle(fontSize: 10)),
                      );
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: maxTempSpots,
                  isCurved: true,
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                  color: Colors.redAccent,
                ),
                LineChartBarData(
                  spots: minTempSpots,
                  isCurved: true,
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'Daily Precipitation Probability',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 140,
          child: BarChart(
            BarChartData(
              maxY: 100,
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (value, meta) {
                      return Text('${value.toInt()}%');
                    },
                    interval: 25,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= forecasts.length) {
                        return const SizedBox.shrink();
                      }
                      final label = DateFormatter.formatShortDay(
                        forecasts[index].date,
                      );
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(label, style: const TextStyle(fontSize: 10)),
                      );
                    },
                  ),
                ),
              ),
              barGroups: List.generate(
                precipBars.length,
                (index) => BarChartGroupData(
                  x: index,
                  barRods: [precipBars[index]],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            'Units: ${_unitLabel(unit)}',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ),
      ],
    );
  }

  String _unitLabel(String unit) {
    switch (unit) {
      case 'imperial':
        return 'F';
      case 'kelvin':
        return 'K';
      case 'metric':
      default:
        return 'C';
    }
  }
}
