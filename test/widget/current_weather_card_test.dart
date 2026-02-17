import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
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

    testWidgets('displays temperature correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CurrentWeatherCard(weather: testWeather)),
        ),
      );

      expect(find.text('23°C'), findsOneWidget);
    });

    testWidgets('displays weather description', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CurrentWeatherCard(weather: testWeather)),
        ),
      );

      expect(find.text('PARTLY CLOUDY'), findsOneWidget);
    });

    testWidgets('displays feels like temperature', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CurrentWeatherCard(weather: testWeather)),
        ),
      );

      expect(find.textContaining('Feels like'), findsOneWidget);
      expect(find.textContaining('20°C'), findsOneWidget);
    });

    testWidgets('displays weather icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CurrentWeatherCard(weather: testWeather)),
        ),
      );

      expect(find.byType(Icon), findsOneWidget);
    });
  });
}
