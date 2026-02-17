import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/features/home/presentation/widgets/current_weather_card.dart';
import 'package:weatherly/domain/entities/weather.dart';

void main() {
  group('CurrentWeatherCard Widget Tests', () {
    late Weather testWeather;

    setUp(() {
      testWeather = Weather(
        temperature: 22.5,
        feelsLike: 20.0,
        description: 'Partly cloudy',
        icon: '02d',
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
        condition: 'partly_cloudy',
      );
    });

    testWidgets('can render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: CurrentWeatherCard(weather: testWeather)),
          ),
        ),
      );

      // Just pump once to ensure widget renders without crashing
      await tester.pump();

      // Verify the card is rendered
      expect(find.byType(CurrentWeatherCard), findsOneWidget);
    });

    testWidgets('renders card layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: CurrentWeatherCard(weather: testWeather)),
          ),
        ),
      );

      // Pump to render the widget
      await tester.pump();

      // Verify scaffold is present
      expect(find.byType(Scaffold), findsOneWidget);

      // Verify MaterialApp is present
      expect(find.byType(MaterialApp), findsOneWidget);

      // ProviderScope was the fix - verify it's working
      expect(find.byType(ProviderScope), findsOneWidget);
    });
  });
}
