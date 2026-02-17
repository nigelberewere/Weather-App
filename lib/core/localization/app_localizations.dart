import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Getters for localized strings
  String get appTitle => 'Weatherly';
  String get home => 'Home';
  String get forecast => 'Forecast';
  String get map => 'Map';
  String get favorites => 'Favorites';
  String get settings => 'Settings';
  String get currentWeather => 'Current Weather';
  String get hourlyForecast => 'Hourly Forecast';
  String get dailyForecast => 'Daily Forecast';
  String get temperature => 'Temperature';
  String get feelsLike => 'Feels Like';
  String get humidity => 'Humidity';
  String get windSpeed => 'Wind Speed';
  String get pressure => 'Pressure';
  String get visibility => 'Visibility';
  String get uvIndex => 'UV Index';
  String get dewPoint => 'Dew Point';
  String get sunrise => 'Sunrise';
  String get sunset => 'Sunset';
  String get searchLocation => 'Search location';
  String get addToFavorites => 'Add to Favorites';
  String get removeFromFavorites => 'Remove from Favorites';
  String get noDataAvailable => 'No data available';
  String get offlineMode => 'Offline Mode';
  String get lastUpdated => 'Last updated';
  String get retry => 'Retry';
  String get locationPermissionDenied => 'Location permission denied';
  String get enableLocation => 'Enable Location';
  String get networkError => 'Network error occurred';
  String get alerts => 'Weather Alerts';
  String get noAlerts => 'No active alerts';
  String get airQuality => 'Air Quality';
  String get uvHealthGuidance => 'UV Health Guidance';
  String get searchForCity => 'Search for a city';
  String get noLocationsFound => 'No locations found';
  String get noFavoriteLocations => 'No favorite locations';
  String get addLocationsToFavorites =>
      'Add locations to favorites from the search page';
  String get selectLocation => 'Please select a location';
  String get noForecastData => 'No forecast data available';
  String get error => 'Error';
  String get errorLoadingData => 'Error loading data';
  String get notificationSettings => 'Notification Settings';
  String get severeWeatherOnly => 'Severe Weather Only';
  String get onlyNotifySevere => 'Only notify for severe/extreme alerts';
  String get alertTypes => 'Alert Types';
  String get dailyWeatherSummary => 'Daily Weather Summary';
  String get morningForecast => 'Morning weather forecast notification';
  String get summaryTime => 'Summary Time';
  String get sendTestNotification => 'Send Test Notification';
  String get testNotificationSent => 'Test notification sent!';
  String get theme => 'Theme';
  String get temperatureUnit => 'Temperature Unit';
  String get close => 'Close';
  String get pm25 => 'PM2.5';
  String get pm10 => 'PM10';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
