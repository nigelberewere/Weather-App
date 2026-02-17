import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weatherly/core/theme/app_colors.dart';
import 'package:weatherly/domain/entities/weather.dart';
import 'package:weatherly/core/localization/app_localizations.dart';

class AirQualityCard extends ConsumerWidget {
  final AirQuality airQuality;

  const AirQualityCard({super.key, required this.airQuality});

  Color _getAQIColor(int aqi) {
    switch (aqi) {
      case 1:
        return const Color(0xFF2ECC71); // Good - Green
      case 2:
        return const Color(0xFFF1C40F); // Fair - Yellow
      case 3:
        return const Color(0xFFE74C3C); // Moderate - Orange/Red
      case 4:
        return const Color(0xFFC0392B); // Poor - Dark Red
      case 5:
        return const Color(0xFF8B0000); // Very Poor - Maroon
      default:
        return AppColors.cardBackground;
    }
  }

  String _getAQILabel(int aqi) {
    switch (aqi) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      case 5:
        return 'Very Poor';
      default:
        return 'Unknown';
    }
  }

  String _getAQIAdvice(int aqi) {
    switch (aqi) {
      case 1:
        return 'Air quality is good. Enjoy outdoor activities.';
      case 2:
        return 'Air quality is acceptable. Sensitive individuals may want to limit outdoor activities.';
      case 3:
        return 'Members of sensitive groups may experience health effects. General public is less affected.';
      case 4:
        return 'Some members of the general public may experience health effects. Members of sensitive groups may experience more serious health effects.';
      case 5:
        return 'Health warning: The risk of health effects is increased for everyone. Limit outdoor activities.';
      default:
        return 'No advice available';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final aqiColor = _getAQIColor(airQuality.aqi);
    final aqiLabel = _getAQILabel(airQuality.aqi);
    final aqiAdvice = _getAQIAdvice(airQuality.aqi);

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
        borderRadius: BorderRadius.circular(20),
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardBackground.withOpacity(0.2),
                ),
                child: SvgPicture.asset(
                  'assets/weather icons/fill/all/air.svg',
                  width: 28,
                  height: 28,
                  colorFilter: ColorFilter.mode(
                    AppColors.textPrimary.withOpacity(0.9),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.airQuality,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AQI',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: aqiColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: aqiColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: aqiColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      aqiLabel,
                      style: TextStyle(
                        color: aqiColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _PollutantInfo(
                    label: l10n.pm25,
                    value: airQuality.pm25.toStringAsFixed(1),
                    unit: 'µg/m³',
                  ),
                  const SizedBox(height: 8),
                  _PollutantInfo(
                    label: l10n.pm10,
                    value: airQuality.pm10.toStringAsFixed(1),
                    unit: 'µg/m³',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: aqiColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              aqiAdvice,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UVHealthGuidanceCard extends ConsumerWidget {
  final double uvIndex;

  const UVHealthGuidanceCard({super.key, required this.uvIndex});

  Color _getUVColor(double uv) {
    if (uv <= 2) return const Color(0xFF2ECC71); // Green
    if (uv <= 5) return const Color(0xFFF1C40F); // Yellow
    if (uv <= 7) return const Color(0xFFE67E22); // Orange
    if (uv <= 10) return const Color(0xFFE74C3C); // Red
    return const Color(0xFF8B0000); // Maroon
  }

  String _getUVLevel(double uv) {
    if (uv <= 2) return 'Low';
    if (uv <= 5) return 'Moderate';
    if (uv <= 7) return 'High';
    if (uv <= 10) return 'Very High';
    return 'Extreme';
  }

  String _getUVRecommendation(double uv) {
    if (uv <= 2) {
      return '🟢 Low UV Index\n• Minimal sun protection needed\n• Reapply sunscreen after activities\n• Enjoy outdoor activities freely';
    } else if (uv <= 5) {
      return '🟡 Moderate UV Index\n• Wear SPF 30+ sunscreen\n• Limit exposure 10 AM - 4 PM\n• Wear protective clothing\n• Use sunglasses';
    } else if (uv <= 7) {
      return '🟠 High UV Index\n• Wear SPF 50+ sunscreen\n• Reduce outdoor exposure\n• Seek shade during midday\n• Protective clothing recommended';
    } else if (uv <= 10) {
      return '🔴 Very High UV Index\n• Extra precautions needed\n• Minimize exposure 10 AM - 4 PM\n• Wear UPF protective clothing\n• Consider staying indoors';
    } else {
      return '⚫ Extreme UV Index\n• Take full precautions\n• Avoid sun exposure\n• Wear protective gear\n• Stay indoors if possible';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final uvColor = _getUVColor(uvIndex);
    final uvLevel = _getUVLevel(uvIndex);
    final uvRecommendation = _getUVRecommendation(uvIndex);

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
        borderRadius: BorderRadius.circular(20),
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardBackground.withOpacity(0.2),
                ),
                child: SvgPicture.asset(
                  'assets/weather icons/fill/all/uv-index.svg',
                  width: 28,
                  height: 28,
                  colorFilter: ColorFilter.mode(
                    AppColors.textPrimary.withOpacity(0.9),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.uvHealthGuidance,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'UV Index',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: uvColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: uvColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: uvColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${uvIndex.toStringAsFixed(1)} - $uvLevel',
                      style: TextStyle(
                        color: uvColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      uvColor.withOpacity(0.3),
                      uvColor.withOpacity(0.1),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: uvColor.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    uvIndex.toStringAsFixed(1),
                    style: TextStyle(
                      color: uvColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: uvColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: uvColor.withOpacity(0.2), width: 1),
            ),
            child: Text(
              uvRecommendation,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PollutantInfo extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _PollutantInfo({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
