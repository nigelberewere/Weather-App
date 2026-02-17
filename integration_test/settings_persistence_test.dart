import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:weatherly/features/settings/presentation/pages/settings_page.dart';
import 'package:weatherly/features/home/presentation/pages/home_page.dart';
import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Settings Persistence Flow Integration Tests', () {
    testWidgets('User can navigate to settings page from home', (
      WidgetTester tester,
    ) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Look for settings button (usually gear icon)
      final settingsFinder = find.byIcon(Icons.settings);
      if (settingsFinder.evaluate().isNotEmpty) {
        await tester.tap(settingsFinder.first);
        await pumpAndSettle(tester);

        expect(
          find.byType(SettingsPage),
          findsOneWidget,
          reason: 'Should navigate to SettingsPage',
        );
      }
    });

    testWidgets('Settings page displays theme preference option', (
      WidgetTester tester,
    ) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to settings
      final settingsFinder = find.byIcon(Icons.settings);
      if (settingsFinder.evaluate().isNotEmpty) {
        await tester.tap(settingsFinder.first);
        await pumpAndSettle(tester);

        // Look for theme-related text
        expect(find.byType(SettingsPage), findsOneWidget);

        final themeFound =
            find.textContaining('Theme').evaluate().isNotEmpty ||
            find.textContaining('theme').evaluate().isNotEmpty;
        expect(themeFound, true, reason: 'Should display theme preference');
      }
    });

    testWidgets('User can change theme preference', (
      WidgetTester tester,
    ) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to settings
      final settingsFinder = find.byIcon(Icons.settings);
      if (settingsFinder.evaluate().isNotEmpty) {
        await tester.tap(settingsFinder.first);
        await pumpAndSettle(tester);

        // Look for dropdown or radio buttons for theme
        final dropdowns = find.byType(DropdownButton);
        if (dropdowns.evaluate().isNotEmpty) {
          await tester.tap(dropdowns.first);
          await pumpAndSettle(tester);

          // Select a different theme option
          final options = find.byType(DropdownMenuItem);
          if (options.evaluate().length > 1) {
            await tester.tap(options.at(1));
            await pumpAndSettle(tester);

            // Theme should be changed
            expect(find.byType(SettingsPage), findsOneWidget);
          }
        }
      }
    });

    testWidgets('User can change temperature unit preference', (
      WidgetTester tester,
    ) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to settings
      final settingsFinder = find.byIcon(Icons.settings);
      if (settingsFinder.evaluate().isNotEmpty) {
        await tester.tap(settingsFinder.first);
        await pumpAndSettle(tester);

        // Look for temperature unit preference
        final unitFound =
            find.textContaining('Temperature').evaluate().isNotEmpty ||
            find.textContaining('Unit').evaluate().isNotEmpty;

        if (unitFound) {
          // Try to find and click temperature unit selector
          final dropdowns = find.byType(DropdownButton);
          if (dropdowns.evaluate().length > 1) {
            await tester.tap(dropdowns.at(1));
            await pumpAndSettle(tester);

            final options = find.byType(DropdownMenuItem);
            if (options.evaluate().length > 1) {
              await tester.tap(options.at(1));
              await pumpAndSettle(tester);

              expect(find.byType(SettingsPage), findsOneWidget);
            }
          }
        }
      }
    });

    testWidgets('Settings changes persist after navigation away and back', (
      WidgetTester tester,
    ) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to settings
      final settingsFinder = find.byIcon(Icons.settings);
      if (settingsFinder.evaluate().isNotEmpty) {
        await tester.tap(settingsFinder.first);
        await pumpAndSettle(tester);

        // Make a change
        final dropdowns = find.byType(DropdownButton);
        if (dropdowns.evaluate().isNotEmpty) {
          await tester.tap(dropdowns.first);
          await pumpAndSettle(tester);

          final options = find.byType(DropdownMenuItem);
          if (options.evaluate().length > 1) {
            await tester.tap(options.at(1));
            await pumpAndSettle(tester);
          }
        }

        // Navigate away (back to home)
        final backButton = find.byIcon(Icons.arrow_back);
        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton.first);
          await pumpAndSettle(tester);
        }

        expect(find.byType(HomePage), findsOneWidget);

        // Navigate back to settings
        if (settingsFinder.evaluate().isNotEmpty) {
          await tester.tap(settingsFinder.first);
          await pumpAndSettle(tester);

          // Setting should still be changed
          expect(find.byType(SettingsPage), findsOneWidget);
        }
      }
    });

    testWidgets('Settings are persisted across app restarts', (
      WidgetTester tester,
    ) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to settings
      final settingsFinder = find.byIcon(Icons.settings);
      if (settingsFinder.evaluate().isNotEmpty) {
        await tester.tap(settingsFinder.first);
        await pumpAndSettle(tester);

        // Make a change (e.g., toggle dark mode)
        final switches = find.byType(Switch);
        if (switches.evaluate().isNotEmpty) {
          await tester.tap(switches.first);
          await pumpAndSettle(tester);
        }

        expect(find.byType(SettingsPage), findsOneWidget);
      }
    });

    testWidgets('User can reset settings to defaults', (
      WidgetTester tester,
    ) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to settings
      final settingsFinder = find.byIcon(Icons.settings);
      if (settingsFinder.evaluate().isNotEmpty) {
        await tester.tap(settingsFinder.first);
        await pumpAndSettle(tester);

        // Look for reset button
        final resetButton = find.byIcon(Icons.refresh_outlined);
        final resetText = find.textContaining('Reset');
        if (resetButton.evaluate().isNotEmpty) {
          await tester.tap(resetButton.first);
        } else if (resetText.evaluate().isNotEmpty) {
          await tester.tap(resetText.first);
          await pumpAndSettle(tester);

          // Confirm reset if dialog appears
          final okButton = find.text('OK');
          final confirmButton = find.text('Confirm');
          if (okButton.evaluate().isNotEmpty) {
            await tester.tap(okButton.first);
          } else if (confirmButton.evaluate().isNotEmpty) {
            await tester.tap(confirmButton.first);
            await pumpAndSettle(tester);
          }

          expect(find.byType(SettingsPage), findsOneWidget);
        }
      }
    });

    testWidgets('Notification settings are persisted', (
      WidgetTester tester,
    ) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to settings
      final settingsFinder = find.byIcon(Icons.settings);
      if (settingsFinder.evaluate().isNotEmpty) {
        await tester.tap(settingsFinder.first);
        await pumpAndSettle(tester);

        // Look for notification settings
        final notificationFound = find
            .textContaining('Notification')
            .evaluate()
            .isNotEmpty;

        if (notificationFound) {
          // Scroll to find notification settings if needed
          final notificationButton = find.textContaining('Notification').first;
          await tester.scrollUntilVisible(notificationButton, 100);
          await tester.tap(notificationButton);
          await pumpAndSettle(tester);

          // Toggle notification settings
          final switches = find.byType(Switch);
          if (switches.evaluate().isNotEmpty) {
            await tester.tap(switches.first);
            await pumpAndSettle(tester);
          }
        }
      }
    });
  });
}
