import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weatherly/app.dart';
import 'package:weatherly/core/services/notification_service.dart';
import 'package:weatherly/core/services/background_fetch_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive only on mobile platforms (not web)
  if (!kIsWeb) {
    try {
      await Hive.initFlutter();
    } catch (e) {
      debugPrint('⚠️ Hive initialization error: $e');
    }
  }

  // Load environment variables (may not exist on web build)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('⚠️ Could not load .env file: $e');
  }

  // Initialize notification service and background fetch only on mobile
  if (!kIsWeb) {
    try {
      final notificationService = NotificationService();
      await notificationService.initialize();

      // Initialize background fetch for periodic weather updates
      await BackgroundFetchService.initializeBackgroundFetch();
      await BackgroundFetchService.startBackgroundFetch();
    } catch (e) {
      debugPrint('⚠️ Mobile services initialization error: $e');
    }
  }

  runApp(const ProviderScope(child: WeatherlyApp()));
}
