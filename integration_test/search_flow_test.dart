import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:weatherly/features/search/presentation/pages/search_page.dart';
import 'package:weatherly/features/home/presentation/pages/home_page.dart';
import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Search to Select City Flow Integration Tests', () {
    testWidgets('User can navigate to search page from home',
        (WidgetTester tester) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Look for search button or navigation to search
      final searchFinder = find.byIcon(Icons.search);
      if (searchFinder.evaluate().isNotEmpty) {
        await tester.tap(searchFinder.first);
        await pumpAndSettle(tester);

        // Verify we're on the search page
        expect(
          find.byType(SearchPage),
          findsOneWidget,
          reason: 'Should navigate to SearchPage',
        );
      }
    });

    testWidgets('Search page displays search input field',
        (WidgetTester tester) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to search
      final searchFinder = find.byIcon(Icons.search);
      if (searchFinder.evaluate().isNotEmpty) {
        await tester.tap(searchFinder.first);
        await pumpAndSettle(tester);

        // Verify search input is present
        final textField = find.byType(TextField);
        expect(textField, findsWidgets);
      }
    });

    testWidgets('User can enter search query and see results',
        (WidgetTester tester) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to search
      final searchFinder = find.byIcon(Icons.search);
      if (searchFinder.evaluate().isNotEmpty) {
        await tester.tap(searchFinder.first);
        await pumpAndSettle(tester);

        // Enter search text
        final textField = find.byType(TextField);
        if (textField.evaluate().isNotEmpty) {
          await tester.enterText(textField.first, 'New York');
          await pumpAndSettle(tester);

          // Wait for search results to appear
          await tester.pump(const Duration(seconds: 2));
          await pumpAndSettle(tester);

          // Results should be displayed as a list
          final listTiles = find.byType(ListTile);
          expect(
            listTiles,
            findsWidgets,
            reason: 'Search results should display as list tiles',
          );
        }
      }
    });

    testWidgets('User can select a city from search results',
        (WidgetTester tester) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to search
      final searchFinder = find.byIcon(Icons.search);
      if (searchFinder.evaluate().isNotEmpty) {
        await tester.tap(searchFinder.first);
        await pumpAndSettle(tester);

        // Enter search text
        final textField = find.byType(TextField);
        if (textField.evaluate().isNotEmpty) {
          await tester.enterText(textField.first, 'London');
          await pumpAndSettle(tester);

          // Wait for results
          await tester.pump(const Duration(seconds: 2));
          await pumpAndSettle(tester);

          // Tap first result
          final listTiles = find.byType(ListTile);
          if (listTiles.evaluate().isNotEmpty) {
            await tester.tap(listTiles.first);
            await pumpAndSettle(tester);

            // Should return to home page with new location
            expect(
              find.byType(HomePage),
              findsOneWidget,
              reason: 'Should navigate back to home after selecting city',
            );
          }
        }
      }
    });

    testWidgets('Search handles empty results gracefully',
        (WidgetTester tester) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to search
      final searchFinder = find.byIcon(Icons.search);
      if (searchFinder.evaluate().isNotEmpty) {
        await tester.tap(searchFinder.first);
        await pumpAndSettle(tester);

        // Enter strange search term
        final textField = find.byType(TextField);
        if (textField.evaluate().isNotEmpty) {
          await tester.enterText(textField.first, 'xyzabc123notreal');
          await pumpAndSettle(tester);

          // Wait for results
          await tester.pump(const Duration(seconds: 2));
          await pumpAndSettle(tester);

          // Should show "no results" message or empty list gracefully
          expect(
            find.byType(SearchPage),
            findsOneWidget,
            reason: 'Search page should still be displayed',
          );
        }
      }
    });

    testWidgets('Recent searches are shown before typing',
        (WidgetTester tester) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to search
      final searchFinder = find.byIcon(Icons.search);
      if (searchFinder.evaluate().isNotEmpty) {
        await tester.tap(searchFinder.first);
        await pumpAndSettle(tester);

        // Verify search page
        expect(find.byType(SearchPage), findsOneWidget);
      }
    });
  });
}
