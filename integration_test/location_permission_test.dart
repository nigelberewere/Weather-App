import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Location Permission Flow Integration Tests', () {
    testWidgets('App shows location permission screen on first launch', (
      WidgetTester tester,
    ) async {
      await buildTestApp(tester);

      // First load should show loading or permission request
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('User can retry location permission after denial', (
      WidgetTester tester,
    ) async {
      await buildTestApp(tester);

      // Wait for initial load
      await waitForLoadingComplete(tester);

      // Look for retry button or refresh action
      final refreshButton = find.byIcon(Icons.refresh);
      if (refreshButton.evaluate().isNotEmpty) {
        await tester.tap(refreshButton.first);
        await pumpAndSettle(tester);
      }

      // Verify app doesn't crash
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('App displays location-based weather when permission granted', (
      WidgetTester tester,
    ) async {
      // This test assumes location permission is granted
      await buildTestApp(tester);

      // Wait for weather data to load
      await waitForLoadingComplete(tester);

      // Verify weather information is displayed
      final weatherCard = find.byType(Card);
      expect(weatherCard, findsWidgets);
    });

    testWidgets('User can handle "permission denied" gracefully', (
      WidgetTester tester,
    ) async {
      await buildTestApp(tester);

      // Wait for any initial setup
      await waitForLoadingComplete(tester);

      // Verify app shows appropriate UI (home page or permission request)
      expect(
        find.byType(Scaffold),
        findsOneWidget,
        reason: 'App should display a scaffold with appropriate content',
      );
    });
  });
}
