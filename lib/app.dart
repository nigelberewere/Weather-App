import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/theme/app_theme.dart';
import 'package:weatherly/features/home/presentation/pages/home_page.dart';
import 'package:weatherly/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:weatherly/core/localization/app_localizations.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void set(ThemeMode mode) => state = mode;
}

class WeatherlyApp extends ConsumerWidget {
  const WeatherlyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final hasSeenOnboarding = ref.watch(hasSeenOnboardingProvider);

    return MaterialApp(
      title: 'Weatherly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('es')],
      home: hasSeenOnboarding.when(
        data: (completed) =>
            completed ? const HomePage() : const OnboardingPage(),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (_, __) => const HomePage(), // Fallback to home if error
      ),
    );
  }
}
