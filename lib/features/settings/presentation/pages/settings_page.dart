import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/app.dart';
import 'package:weatherly/core/localization/app_localizations.dart';
import 'package:weatherly/core/widgets/app_icon.dart';
import 'package:weatherly/core/providers/settings_providers.dart';
import 'package:weatherly/core/providers/app_providers.dart';
import 'package:weatherly/features/settings/presentation/pages/notification_settings_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final unitPreferenceAsync = ref.watch(unitPreferenceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: unitPreferenceAsync.when(
        data: (unitPreference) =>
            _buildSettings(context, ref, l10n, themeMode, unitPreference),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('${l10n.error}: $error')),
      ),
    );
  }

  Widget _buildSettings(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ThemeMode themeMode,
    String unitPreference,
  ) {
    final appVersionAsync = ref.watch(appVersionProvider);
    return ListView(
      children: [
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: Text(l10n.theme),
          subtitle: Text(_getThemeModeLabel(themeMode)),
          onTap: () {
            _showThemeDialog(context, ref);
          },
        ),

        const Divider(),
        ListTile(
          leading: const Icon(Icons.thermostat_outlined),
          title: Text(l10n.temperatureUnit),
          subtitle: Text(_getUnitLabel(unitPreference)),
          onTap: () {
            _showUnitDialog(context, ref);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: const Text('Notifications'),
          subtitle: const Text('Manage weather alerts and notifications'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NotificationSettingsPage(),
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.location_on_outlined),
          title: const Text('Location'),
          subtitle: const Text('Manage location permissions'),
          onTap: () {
            // Navigate to location settings
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Privacy'),
          subtitle: const Text('Privacy policy and data usage'),
          onTap: () {
            // Show privacy policy
          },
        ),
        const Divider(),
        appVersionAsync.when(
          data: (version) => ListTile(
            leading: const Icon(Icons.info_outlined),
            title: const Text('About'),
            subtitle: Text('Version $version'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Weatherly',
                applicationVersion: version,
                applicationLegalese: '© 2025 Weatherly',
                applicationIcon: const AppIcon(size: 48),
              );
            },
          ),
          loading: () => const ListTile(
            leading: Icon(Icons.info_outlined),
            title: Text('About'),
            subtitle: Text('Loading version...'),
          ),
          error: (_, __) => const ListTile(
            leading: Icon(Icons.info_outlined),
            title: Text('About'),
            subtitle: Text('Version unavailable'),
            onTap: null,
          ),
        ),
      ],
    );
  }

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  String _getUnitLabel(String unit) {
    switch (unit) {
      case 'metric':
        return 'Celsius (°C)';
      case 'imperial':
        return 'Fahrenheit (°F)';
      case 'kelvin':
        return 'Kelvin (K)';
      default:
        return 'Celsius (°C)';
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: StatefulBuilder(
          builder: (context, setState) {
            final currentTheme = ref.watch(themeModeProvider);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Light'),
                  leading: Radio<ThemeMode>(
                    value: ThemeMode.light,
                    groupValue: currentTheme,
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(themeModeProvider.notifier).set(value);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  onTap: () {
                    ref.read(themeModeProvider.notifier).set(ThemeMode.light);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Dark'),
                  leading: Radio<ThemeMode>(
                    value: ThemeMode.dark,
                    groupValue: currentTheme,
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(themeModeProvider.notifier).set(value);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  onTap: () {
                    ref.read(themeModeProvider.notifier).set(ThemeMode.dark);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('System'),
                  leading: Radio<ThemeMode>(
                    value: ThemeMode.system,
                    groupValue: currentTheme,
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(themeModeProvider.notifier).set(value);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  onTap: () {
                    ref.read(themeModeProvider.notifier).set(ThemeMode.system);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showUnitDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Temperature Unit'),
        content: StatefulBuilder(
          builder: (context, setState) {
            final currentUnitAsync = ref.watch(unitPreferenceProvider);
            return currentUnitAsync.when(
              data: (currentUnit) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Celsius (°C)'),
                    leading: Radio<String>(
                      value: 'metric',
                      groupValue: currentUnit,
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(unitPreferenceProvider.notifier)
                              .setUnit(value);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    onTap: () {
                      ref
                          .read(unitPreferenceProvider.notifier)
                          .setUnit('metric');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Fahrenheit (°F)'),
                    leading: Radio<String>(
                      value: 'imperial',
                      groupValue: currentUnit,
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(unitPreferenceProvider.notifier)
                              .setUnit(value);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    onTap: () {
                      ref
                          .read(unitPreferenceProvider.notifier)
                          .setUnit('imperial');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Kelvin (K)'),
                    leading: Radio<String>(
                      value: 'kelvin',
                      groupValue: currentUnit,
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(unitPreferenceProvider.notifier)
                              .setUnit(value);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    onTap: () {
                      ref
                          .read(unitPreferenceProvider.notifier)
                          .setUnit('kelvin');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Text('${l10n.error}: $error'),
            );
          },
        ),
      ),
    );
  }
}
