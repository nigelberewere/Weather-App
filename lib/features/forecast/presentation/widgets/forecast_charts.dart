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
    // Limit to 12 hours for better readability
    final displayForecasts = forecasts.take(12).toList();
    final tempSpots = <FlSpot>[];
    final precipSpots = <BarChartRodData>[];

    for (var i = 0; i < displayForecasts.length; i++) {
      final forecast = displayForecasts[i];
      tempSpots.add(FlSpot(i.toDouble(), forecast.temperature));
      precipSpots.add(
        BarChartRodData(
          toY: forecast.precipitationProbability.toDouble(),
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade600],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: 8,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      );
    }

    final temps = displayForecasts.map((f) => f.temperature).toList();
    final minTemp = temps.reduce((a, b) => a < b ? a : b);
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final padding = (maxTemp - minTemp) * 0.2;
    final minY = minTemp - padding;
    final maxY = maxTemp + padding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(
                Icons.thermostat,
                size: 20,
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(width: 8),
              const Text(
                'Temperature',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: LineChart(
            LineChartData(
              minY: minY,
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.white.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
              ),
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
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: (displayForecasts.length / 6).clamp(1, 6),
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= displayForecasts.length) {
                        return const SizedBox.shrink();
                      }
                      final label = DateFormatter.formatHour(
                        displayForecasts[index].time,
                      );
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: tempSpots,
                  isCurved: true,
                  barWidth: 3.5,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: Colors.orangeAccent,
                      );
                    },
                  ),
                  gradient: const LinearGradient(
                    colors: [Colors.orangeAccent, Colors.deepOrangeAccent],
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.orangeAccent.withOpacity(0.3),
                        Colors.orangeAccent.withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(
                Icons.water_drop,
                size: 20,
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(width: 8),
              const Text(
                'Precipitation Probability',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: BarChart(
            BarChartData(
              maxY: 100,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.white.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
              ),
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
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                    interval: 25,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: (displayForecasts.length / 6).clamp(1, 6),
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= displayForecasts.length) {
                        return const SizedBox.shrink();
                      }
                      final label = DateFormatter.formatHour(
                        displayForecasts[index].time,
                      );
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: List.generate(
                precipSpots.length,
                (index) =>
                    BarChartGroupData(x: index, barRods: [precipSpots[index]]),
              ),
            ),
          ),
        ),
      ],
    );
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
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade700],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: 10,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
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
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(
                Icons.thermostat,
                size: 20,
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(width: 8),
              const Text(
                'Daily Temperature',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: LineChart(
            LineChartData(
              minY: minY,
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.white.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
              ),
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
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      );
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
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: maxTempSpots,
                  isCurved: true,
                  barWidth: 3.2,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: Colors.redAccent,
                      );
                    },
                  ),
                  gradient: LinearGradient(
                    colors: [Colors.redAccent, Colors.deepOrangeAccent],
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.redAccent.withOpacity(0.3),
                        Colors.redAccent.withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                LineChartBarData(
                  spots: minTempSpots,
                  isCurved: true,
                  barWidth: 3.0,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 3,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: Colors.blueAccent,
                      );
                    },
                  ),
                  gradient: LinearGradient(
                    colors: [Colors.lightBlueAccent, Colors.blueAccent],
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent.withOpacity(0.25),
                        Colors.blueAccent.withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(
                Icons.water_drop,
                size: 20,
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(width: 8),
              const Text(
                'Daily Precipitation Probability',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: BarChart(
            BarChartData(
              maxY: 100,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.white.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
              ),
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
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      );
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
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: List.generate(
                precipBars.length,
                (index) =>
                    BarChartGroupData(x: index, barRods: [precipBars[index]]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
