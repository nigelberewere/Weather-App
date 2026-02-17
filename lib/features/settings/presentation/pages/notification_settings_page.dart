import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/localization/app_localizations.dart';
import 'package:weatherly/core/providers/notification_providers.dart';

class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState
    extends ConsumerState<NotificationSettingsPage> {
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    // Request notification permissions on first access
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationSettings)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.alerts,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.warning_amber_outlined),
            title: Text(l10n.alerts),
            subtitle: Text(l10n.alerts),
            value: settings.alertsEnabled,
            onChanged: (value) async {
              await notifier.setAlertsEnabled(value);
              if (value && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.alerts),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          if (settings.alertsEnabled) ...[
            SwitchListTile(
              secondary: const Icon(Icons.priority_high_outlined),
              title: Text(l10n.severeWeatherOnly),
              subtitle: Text(l10n.onlyNotifySevere),
              value: settings.severeWeatherOnly,
              onChanged: (value) async {
                await notifier.setSevereWeatherOnly(value);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.alertTypes),
              subtitle: const Text(
                'You\'ll receive alerts for:\n'
                '• Extreme temperatures\n'
                '• High winds\n'
                '• Thunderstorms\n'
                '• Heavy snow\n'
                '• Low visibility',
              ),
              isThreeLine: true,
            ),
          ],
          const Divider(thickness: 2),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.dailyWeatherSummary,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.wb_sunny_outlined),
            title: Text(l10n.dailyWeatherSummary),
            subtitle: Text(l10n.morningForecast),
            value: settings.dailySummaryEnabled,
            onChanged: (value) async {
              await notifier.setDailySummaryEnabled(value);
            },
          ),
          if (settings.dailySummaryEnabled) ...[
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(l10n.summaryTime),
              subtitle: Text(settings.dailySummaryTime),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: int.parse(settings.dailySummaryTime.split(':')[0]),
                    minute: int.parse(settings.dailySummaryTime.split(':')[1]),
                  ),
                );
                if (time != null) {
                  final formattedTime =
                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                  await notifier.setDailySummaryTime(formattedTime);
                }
              },
            ),
          ],
          const Divider(thickness: 2),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Test Notifications',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    final notificationService = ref.read(
                      notificationServiceProvider,
                    );
                    await notificationService.showDailySummary(
                      locationName: 'Test Location',
                      condition: 'Partly Cloudy',
                      temperature: 22,
                      tempHigh: 25,
                      tempLow: 18,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.testNotificationSent)),
                      );
                    }
                  },
                  icon: const Icon(Icons.notification_add),
                  label: Text(l10n.sendTestNotification),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
