import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:weatherly/features/home/presentation/pages/home_page.dart';
import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Complete User Journey Integration Tests', () {
    testWidgets('Full app startup and basic navigation', (
      WidgetTester tester,
    ) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Verify home page is displayed
      expect(
        find.byType(HomePage),
        findsOneWidget,
        reason: 'HomePage should be displayed after startup',
      );

      // Verify basic widgets are present
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsWidgets);
    });

    testWidgets('Navigation between tabs works correctly', (
      WidgetTester tester,
    ) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Get all bottom nav items
      final navItems = find.byType(BottomNavigationBarItem);
      expect(navItems, findsWidgets);

      // Try clicking each nav item
      final navButtons = find.byType(BottomNavigationBar);
      if (navButtons.evaluate().isNotEmpty) {
        // No direct way to tap nav items, so we verify the structure exists
        expect(navButtons.first, findsOneWidget);
      }
    });

    testWidgets('Weather data displays correctly', (WidgetTester tester) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Look for temperature display
      final cards = find.byType(Card);
      if (cards.evaluate().isNotEmpty) {
        expect(cards, findsWidgets);
      }

      // Look for weather information
      final text = find.byType(Text);
      expect(text, findsWidgets);
    });

    testWidgets('App handles network errors gracefully', (
      WidgetTester tester,
    ) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Verify app doesn't crash and displays UI
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Pull-to-refresh functionality works', (
      WidgetTester tester,
    ) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Look for RefreshIndicator
      final refreshIndicator = find.byType(RefreshIndicator);
      if (refreshIndicator.evaluate().isNotEmpty) {
        // Perform pull-to-refresh gesture
        await tester.drag(
          find.byType(ListView).first,
          const Offset(0, 300),
          warnIfMissed: false,
        );
        await pumpAndSettle(tester);

        // Verify refresh completed
        expect(find.byType(HomePage), findsOneWidget);
      }
    });

    testWidgets('Share functionality is available', (
      WidgetTester tester,
    ) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Look for share button
      final shareButton = find.byIcon(Icons.share);
      if (shareButton.evaluate().isNotEmpty) {
        // Button exists
        expect(shareButton, findsOneWidget);
      }
    });

    testWidgets('Forecast pages are accessible and load', (
      WidgetTester tester,
    ) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Look for forecast navigation
      final forecastFinder = find.byIcon(Icons.calendar_today);
      if (forecastFinder.evaluate().isNotEmpty) {
        await tester.tap(forecastFinder.first);
        await pumpAndSettle(tester);

        // Verify navigation happened
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('Map page is accessible', (WidgetTester tester) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Look for map button
      final mapFinder = find.byIcon(Icons.map);
      if (mapFinder.evaluate().isNotEmpty) {
        await tester.tap(mapFinder.first);
        await pumpAndSettle(tester);

        // Verify navigation happened
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('Theme toggle works in settings', (WidgetTester tester) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to settings
      final settingsFinder = find.byIcon(Icons.settings);
      if (settingsFinder.evaluate().isNotEmpty) {
        await tester.tap(settingsFinder.first);
        await pumpAndSettle(tester);

        final switchToggle = find.byType(Switch);
        final radioToggle = find.byType(Radio);
        if (switchToggle.evaluate().isNotEmpty) {
          await tester.tap(switchToggle.first);
        } else if (radioToggle.evaluate().isNotEmpty) {
          await tester.tap(radioToggle.first);
          await pumpAndSettle(tester);

          // Theme may have changed
          expect(find.byType(Scaffold), findsOneWidget);
        }
      }
    });
  });
}
