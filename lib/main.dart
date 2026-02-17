import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weatherly/app.dart';
import 'package:weatherly/core/services/notification_service.dart';
import 'package:weatherly/core/services/background_fetch_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Load environment variables
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Warning: Could not load .env file: $e');
  }

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Initialize background fetch for periodic weather updates
  await BackgroundFetchService.initializeBackgroundFetch();
  await BackgroundFetchService.startBackgroundFetch();

  runApp(const ProviderScope(child: WeatherlyApp()));
}
