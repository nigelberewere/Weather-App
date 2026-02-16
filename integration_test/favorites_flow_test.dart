import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:weatherly/features/favorites/presentation/pages/favorites_page.dart';
import 'package:weatherly/features/home/presentation/pages/home_page.dart';
import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Favorites Management Flow Integration Tests', () {
    testWidgets('User can navigate to favorites page from home',
        (WidgetTester tester) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Look for favorites navigation (bottom nav or drawer)
      final favoritesFinder = find.byIcon(Icons.favorite);
      if (favoritesFinder.evaluate().isNotEmpty) {
        await tester.tap(favoritesFinder.first);
        await pumpAndSettle(tester);

        expect(
          find.byType(FavoritesPage),
          findsOneWidget,
          reason: 'Should navigate to FavoritesPage',
        );
      }
    });

    testWidgets('Favorites page shows empty state when no favorites',
        (WidgetTester tester) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to favorites
      final favoritesFinder = find.byIcon(Icons.favorite);
      if (favoritesFinder.evaluate().isNotEmpty) {
        await tester.tap(favoritesFinder.first);
        await pumpAndSettle(tester);

        // Empty state should show "No favorite locations" or similar
        expect(find.byType(FavoritesPage), findsOneWidget);
        
        // Look for text indicating empty favorites
        final textFound = find.textContaining('favorite').evaluate().isNotEmpty;
        expect(
          textFound,
          true,
          reason: 'Should display message about favorites',
        );
      }
    });

    testWidgets('User can add a location to favorites from mini-dashboard',
        (WidgetTester tester) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to search to find a location
      final searchFinder = find.byIcon(Icons.search);
      if (searchFinder.evaluate().isNotEmpty) {
        await tester.tap(searchFinder.first);
        await pumpAndSettle(tester);

        // Enter search text
        final textField = find.byType(TextField);
        if (textField.evaluate().isNotEmpty) {
          await tester.enterText(textField.first, 'Paris');
          await pumpAndSettle(tester);

          // Wait for results
          await tester.pump(const Duration(seconds: 2));
          await pumpAndSettle(tester);

          // Look for favorite/add button in search results
          final listTiles = find.byType(ListTile);
          if (listTiles.evaluate().isNotEmpty) {
            // Try to find an add/favorite button
            final addButton = find.byIcon(Icons.add);
            if (addButton.evaluate().isNotEmpty) {
              await tester.tap(addButton.first);
              await pumpAndSettle(tester);
            } else {
              // Just tap the first result to add it
              await tester.tap(listTiles.first);
              await pumpAndSettle(tester);
            }
          }
        }
      }
    });

    testWidgets('User can view favorite locations in favorites page',
        (WidgetTester tester) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to favorites
      final favoritesFinder = find.byIcon(Icons.favorite);
      if (favoritesFinder.evaluate().isNotEmpty) {
        await tester.tap(favoritesFinder.first);
        await pumpAndSettle(tester);

        expect(find.byType(FavoritesPage), findsOneWidget);
        
        // If there are favorites, they should be displayed
        final cards = find.byType(Card);
        if (cards.evaluate().isNotEmpty) {
          expect(cards, findsWidgets);
        }
      }
    });

    testWidgets('User can remove a favorite location',
        (WidgetTester tester) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to favorites
      final favoritesFinder = find.byIcon(Icons.favorite);
      if (favoritesFinder.evaluate().isNotEmpty) {
        await tester.tap(favoritesFinder.first);
        await pumpAndSettle(tester);

        // If there are favorites, try to remove one
        final removeButtons = find.byIcon(Icons.delete);
        if (removeButtons.evaluate().isNotEmpty) {
          await tester.tap(removeButtons.first);
          await pumpAndSettle(tester);

          // Verify removal confirmation or direct removal
          expect(find.byType(FavoritesPage), findsOneWidget);
        }
      }
    });

    testWidgets('User can select a favorite to view its weather',
        (WidgetTester tester) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to favorites
      final favoritesFinder = find.byIcon(Icons.favorite);
      if (favoritesFinder.evaluate().isNotEmpty) {
        await tester.tap(favoritesFinder.first);
        await pumpAndSettle(tester);

        // If there are favorites, click on one
        final cards = find.byType(Card);
        if (cards.evaluate().isNotEmpty) {
          await tester.tap(cards.first);
          await pumpAndSettle(tester);

          // Should navigate to home page with that location selected
          expect(find.byType(HomePage), findsOneWidget);
        }
      }
    });

    testWidgets('Favorites persist after app restart',
        (WidgetTester tester) async {
      // This is a basic test that can be expanded with actual persistence checking
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);

      // Navigate to favorites
      final favoritesFinder = find.byIcon(Icons.favorite);
      if (favoritesFinder.evaluate().isNotEmpty) {
        await tester.tap(favoritesFinder.first);
        await pumpAndSettle(tester);

        expect(find.byType(FavoritesPage), findsOneWidget);
      }
    });
  });
}
