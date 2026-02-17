import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherly/app.dart';
import 'package:weatherly/domain/entities/weather.dart';

/// Helper to build the app for integration tests
Future<void> buildTestApp(WidgetTester tester, {WidgetRef? ref}) async {
  await tester.pumpWidget(const ProviderScope(child: WeatherlyApp()));
  await tester.pumpAndSettle();
}

/// Helper to pump and settle the widget tree
Future<void> pumpAndSettle(WidgetTester tester) async {
  await tester.pumpAndSettle(const Duration(milliseconds: 500));
}

/// Helper to find and tap a button by text
Future<void> tapButton(WidgetTester tester, String buttonText) async {
  final button = find
      .byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton ||
            widget is TextButton ||
            widget is OutlinedButton,
      )
      .first;

  await tester.tap(button);
  await pumpAndSettle(tester);
}

/// Helper to find and tap a button by text (more flexible)
Future<void> tapButtonByText(WidgetTester tester, String text) async {
  final finder = find.text(text).first;
  await tester.scrollUntilVisible(
    finder,
    100,
    scrollable: find.byType(SingleChildScrollView).first,
  );
  await tester.tap(finder);
  await pumpAndSettle(tester);
}

/// Helper to enter text in a text field
Future<void> enterText(
  WidgetTester tester,
  String text, {
  int index = 0,
}) async {
  await tester.enterText(find.byType(TextField).at(index), text);
  await pumpAndSettle(tester);
}

/// Helper to find text in the widget tree
Finder findText(String text) => find.text(text);

/// Helper to wait for a specific widget to appear
Future<void> waitForWidget(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  final endTime = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(endTime)) {
    await tester.pump();
    if (finder.evaluate().isNotEmpty) {
      break;
    }
  }
}

/// Test data: Sample weather
Weather createTestWeather({
  double temperature = 22.5,
  String condition = 'sunny',
  String description = 'Clear sky',
}) => Weather(
  temperature: temperature,
  feelsLike: 20.0,
  description: description,
  icon: '01d',
  humidity: 65,
  windSpeed: 5.5,
  windDegree: 180,
  pressure: 1013,
  visibility: 10000,
  dewPoint: 15.0,
  uvIndex: 5,
  sunrise: DateTime.now(),
  sunset: DateTime.now().add(const Duration(hours: 8)),
  timestamp: DateTime.now(),
  condition: condition,
);

/// Test data: Sample location
Location createTestLocation({
  String name = 'Test City',
  double lat = 40.7128,
  double lon = -74.0060,
}) => Location(
  name: name,
  latitude: lat,
  longitude: lon,
  country: 'Test Country',
  state: 'Test State',
);

/// Helper to scroll to find a widget
Future<void> scrollTo(
  WidgetTester tester,
  Finder finder, {
  Finder? scrollable,
}) async {
  await tester.scrollUntilVisible(
    finder,
    100,
    scrollable: scrollable ?? find.byType(SingleChildScrollView).first,
  );
  await pumpAndSettle(tester);
}

/// Helper to verify text is displayed
void expectText(String text) {
  expect(find.text(text), findsOneWidget);
}

/// Helper to verify text contains
void expectTextContaining(String text) {
  expect(find.textContaining(text), findsOneWidget);
}

/// Helper to wait for loading to complete
Future<void> waitForLoadingComplete(
  WidgetTester tester, {
  int maxAttempts = 30,
}) async {
  for (int i = 0; i < maxAttempts; i++) {
    await tester.pump(const Duration(milliseconds: 500));

    // Check if loading indicators are still present
    final loadingIndicators = find.byType(CircularProgressIndicator);
    if (loadingIndicators.evaluate().isEmpty) {
      break;
    }
  }
  await pumpAndSettle(tester);
}
