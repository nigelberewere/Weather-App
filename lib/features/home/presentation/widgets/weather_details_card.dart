import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weatherly/core/theme/app_colors.dart';
import 'package:weatherly/core/utils/date_formatter.dart';
import 'package:weatherly/core/utils/unit_converter.dart';
import 'package:weatherly/core/providers/settings_providers.dart';
import 'package:weatherly/core/localization/app_localizations.dart';
import 'package:weatherly/domain/entities/weather.dart';

class WeatherDetailsCard extends ConsumerWidget {
  final Weather weather;

  const WeatherDetailsCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final unitAsync = ref.watch(unitPreferenceProvider);

    return unitAsync.when(
      data: (unit) => _buildDetails(context, l10n, unit),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(child: Text('${l10n.error}: $error')),
    );
  }

  Widget _buildDetails(
    BuildContext context,
    AppLocalizations l10n,
    String unit,
  ) {
    final details = [
      _WeatherDetail(
        label: l10n.humidity,
        value: '${weather.humidity}%',
        iconPath: 'assets/weather icons/fill/all/humidity.svg',
      ),
      _WeatherDetail(
        label: l10n.windSpeed,
        value: UnitConverter.formatWindSpeed(weather.windSpeed, unit),
        iconPath: 'assets/weather icons/fill/all/wind.svg',
      ),
      _WeatherDetail(
        label: l10n.pressure,
        value: '${weather.pressure} hPa',
        iconPath: 'assets/weather icons/fill/all/barometer.svg',
      ),
      _WeatherDetail(
        label: l10n.uvIndex,
        value: weather.uvIndex.toStringAsFixed(1),
        iconPath: 'assets/weather icons/fill/all/uv-index.svg',
      ),
      _WeatherDetail(
        label: l10n.dewPoint,
        value: UnitConverter.formatTemperature(weather.dewPoint, unit),
        iconPath: 'assets/weather icons/fill/all/thermometer-glass.svg',
      ),
      _WeatherDetail(
        label: l10n.visibility,
        value: UnitConverter.formatVisibility(weather.visibility, unit),
        iconPath: 'assets/weather icons/fill/all/mist.svg',
      ),
      _WeatherDetail(
        label: l10n.sunrise,
        value: DateFormatter.formatTime(weather.sunrise),
        iconPath: 'assets/weather icons/fill/all/sunrise.svg',
      ),
      _WeatherDetail(
        label: l10n.sunset,
        value: DateFormatter.formatTime(weather.sunset),
        iconPath: 'assets/weather icons/fill/all/sunset.svg',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: details.length,
      itemBuilder: (context, index) {
        final detail = details[index];
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.cardBackground.withOpacity(0.2),
                AppColors.cardBackground.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.cardBorder.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Icon with subtle background glow
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardBackground.withOpacity(0.2),
                ),
                child: SvgPicture.asset(
                  detail.iconPath,
                  width: 26,
                  height: 26,
                  colorFilter: ColorFilter.mode(
                    AppColors.textPrimary.withOpacity(0.9),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              // Label
              Text(
                detail.label.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              // Value
              Text(
                detail.value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WeatherDetail {
  final String label;
  final String value;
  final String iconPath;

  const _WeatherDetail({
    required this.label,
    required this.value,
    required this.iconPath,
  });
}
