import 'package:flutter/material.dart';
import 'package:weatherly/domain/entities/weather.dart';
import 'package:weatherly/core/localization/app_localizations.dart';

class WeatherAlertBanner extends StatelessWidget {
  final List<WeatherAlert> alerts;
  final VoidCallback? onTap;

  const WeatherAlertBanner({
    super.key,
    required this.alerts,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) return const SizedBox.shrink();

    final mostSevere = _getMostSevereAlert(alerts);

    return Material(
      color: _getSeverityColor(mostSevere.severity),
      child: InkWell(
        onTap: onTap ?? () => _showAlertDialog(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                _getSeverityIcon(mostSevere.severity),
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mostSevere.event,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (alerts.length > 1) ...[
                      const SizedBox(height: 4),
                      Text(
                        '+${alerts.length - 1} more alert${alerts.length > 2 ? 's' : ''}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  WeatherAlert _getMostSevereAlert(List<WeatherAlert> alerts) {
    final severityOrder = ['Extreme', 'Severe', 'Moderate', 'Minor'];
    
    alerts.sort((a, b) {
      final aIndex = severityOrder.indexOf(a.severity);
      final bIndex = severityOrder.indexOf(b.severity);
      return aIndex.compareTo(bIndex);
    });
    
    return alerts.first;
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'extreme':
        return Colors.red.shade800;
      case 'severe':
        return Colors.orange.shade800;
      case 'moderate':
        return Colors.amber.shade700;
      default:
        return Colors.blue.shade700;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'extreme':
        return Icons.error;
      case 'severe':
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  void _showAlertDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.orange),
            const SizedBox(width: 8),
            Text(l10n.alerts),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: alerts.map((alert) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getSeverityColor(alert.severity).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getSeverityColor(alert.severity),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getSeverityIcon(alert.severity),
                          color: _getSeverityColor(alert.severity),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            alert.event,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      alert.description,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Valid until ${_formatTime(alert.end)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours';
    } else {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} on ${dateTime.day}/${dateTime.month}';
    }
  }
}
