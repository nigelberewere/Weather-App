# Integration Tests - Quick Start Guide

## Overview

The Weatherly app includes comprehensive integration tests covering critical user flows:

1. ✅ **Location Permission Flow** - Handling location permissions on app startup
2. ✅ **Search → Select City** - Searching and selecting a city
3. ✅ **Favorites Management** - Adding, viewing, and removing favorite locations  
4. ✅ **Settings Persistence** - Theme, unit, and notification preferences
5. ✅ **Complete User Journey** - Full app navigation and feature testing

## Quick Commands

### Run All Tests
```bash
flutter test integration_test/
```

### Run Specific Flow Tests
```bash
# Location permission tests
flutter test integration_test/location_permission_test.dart

# Search flow tests
flutter test integration_test/search_flow_test.dart

# Favorites management tests
flutter test integration_test/favorites_flow_test.dart

# Settings persistence tests
flutter test integration_test/settings_persistence_test.dart

# Complete user journey tests
flutter test integration_test/user_journey_test.dart
```

### Run on Physical Device
```bash
# List devices
flutter devices

# Run on specific device
flutter test integration_test/ -d <device_id>
```

### Run on Emulator
```bash
# Android Emulator
flutter test integration_test/ -d emulator-5554

# iOS Simulator
flutter test integration_test/ -d emulator
```

## Prerequisites

### Required
- Flutter SDK (latest stable or dev)
- Connected device or emulator
- `.env` file with API credentials
- 5 minutes per test run (patience)

### Recommended
- Device with 2GB+ RAM
- Stable internet connection
- Location services enabled (for location tests)

## Test Files Structure

```
integration_test/
├── helpers/
│   ├── test_helpers.dart          # Common test utilities
│   └── mock_providers.dart        # Mock providers for testing
├── location_permission_test.dart   # Location permission flow
├── search_flow_test.dart          # Search and select city flow
├── favorites_flow_test.dart       # Favorites management flow
├── settings_persistence_test.dart # Settings persistence flow
├── user_journey_test.dart         # Complete user journey
├── integration_test.dart          # Test configuration
├── config.json                     # Test configuration
├── README.md                       # Full documentation
└── QUICK_START.md                 # This file
```

## What's Tested

### 1. Location Permission Flow (`location_permission_test.dart`)
- [ ] App shows location permission screen
- [ ] User can retry after denial
- [ ] App displays weather when permission granted
- [ ] Graceful handling of permission denial

### 2. Search → Select City (`search_flow_test.dart`)
- [ ] Navigate to search page
- [ ] Search input field displays
- [ ] Enter search query and see results
- [ ] Select city from results
- [ ] Handle empty results gracefully
- [ ] Recent searches display

### 3. Favorites Management (`favorites_flow_test.dart`)
- [ ] Navigate to favorites page
- [ ] Empty state displays correctly
- [ ] Add locations to favorites
- [ ] View favorite locations
- [ ] Remove favorites
- [ ] Select favorite to view weather
- [ ] Favorites persist after app restart

### 4. Settings Persistence (`settings_persistence_test.dart`)
- [ ] Change theme preference
- [ ] Change temperature unit (°C/°F/K)
- [ ] Settings persist after navigation
- [ ] Settings persist after app restart
- [ ] Can reset settings to defaults
- [ ] Notification settings persist

### 5. Complete User Journey (`user_journey_test.dart`)
- [ ] App startup and loading
- [ ] Tab navigation works
- [ ] Weather data displays
- [ ] Network error handling
- [ ] Pull-to-refresh functionality
- [ ] Share functionality
- [ ] Access forecast pages
- [ ] Access map page
- [ ] Theme toggle in settings

## Typical Test Output

```
Analyzing integration_test/                                50.0s
Building for Android x86 (debug)...                        25.0s
Launching Android emulator...                              15.0s

Running "flutter test integration_test/"...

Integration tests starting (5 test suites, 30+ individual tests)

01:02  Location Permission Flow Integration Tests             ✓
       ✓ App shows location permission screen on first launch
       ✓ User can retry location permission after denial
       ✓ App displays location-based weather when permission granted
       ✓ User can handle "permission denied" gracefully

02:15  Search to Select City Flow Integration Tests           ✓
       ✓ User can navigate to search page from home
       ✓ Search page displays search input field
       ✓ User can enter search query and see results
       ✓ User can select a city from search results
       ✓ Search handles empty results gracefully
       ✓ Recent searches are shown before typing

03:30  Favorites Management Flow Integration Tests            ✓
       ✓ User can navigate to favorites page from home
       ✓ Favorites page shows empty state when no favorites
       ✓ User can add a location to favorites from mini-dashboard
       ✓ User can view favorite locations in favorites page
       ✓ User can remove a favorite location
       ✓ User can select a favorite to view its weather
       ✓ Favorites persist after app restart

04:45  Settings Persistence Flow Integration Tests            ✓
       ✓ User can navigate to settings page from home
       ✓ Settings page displays theme preference option
       ✓ User can change theme preference
       ✓ User can change temperature unit preference
       ✓ Settings changes persist after navigation away and back
       ✓ Settings are persisted across app restarts
       ✓ User can reset settings to defaults
       ✓ Notification settings are persisted

06:00  Complete User Journey Integration Tests                ✓
       ✓ Full app startup and basic navigation
       ✓ Navigation between tabs works correctly
       ✓ Weather data displays correctly
       ✓ App handles network errors gracefully
       ✓ Pull-to-refresh functionality works
       ✓ Share functionality is available
       ✓ Forecast pages are accessible and load
       ✓ Map page is accessible
       ✓ Theme toggle works in settings

All tests passed! (30+ assertions)
```

## Troubleshooting

### Device Issues
```
Error: No devices found

Solution:
1. flutter devices              # List available devices
2. flutter test integration_test/ -d <device_id>
```

### Permission Issues
```
Error: Location permission denied

Solutions:
1. Grant location permission on test device
2. Tests skip location-specific assertions if permission unavailable
```

### Timeout Issues
```
Error: Test timeout exceeded

Solutions:
1. Increase test timeout
2. Check device performance
3. Verify network connectivity
4. Run individual tests instead of all
```

### App Crashes
```
Error: App crashed during test

Solutions:
1. Check .env file has required API keys
2. Check device storage space
3. Rebuild app: flutter clean && flutter pub get
4. Ensure device has internet connection
```

### Emulator Too Slow
```
Solution: Use hardware acceleration
- Android: Enable Intel HAXM or AMD-V in BIOS
- iOS: Ensure Mac has 8GB+ RAM
- Consider using physical device
```

## Performance Tips

- **Parallel Tests**: Run on multiple devices simultaneously
- **Selective Testing**: Run only the flows you're working on
- **Fast Setup**: Use `-d` flag to skip device discovery
- **Verbose Mode**: `flutter test integration_test/ -v` for detailed logs
- **Slow Motion**: `flutter test integration_test/ --route-test-timeout 5000` to see UI changes

## CI/CD Integration

### GitHub Actions
```yaml
- name: Run integration tests
  run: flutter test integration_test/ --verbose
```

### GitLab CI
```yaml
integration_tests:
  script:
    - flutter test integration_test/ --verbose
```

## Common Patterns in Tests

### Wait for Loading
```dart
await waitForLoadingComplete(tester);
```

### Find and Tap
```dart
final button = find.byIcon(Icons.search);
if (button.evaluate().isNotEmpty) {
  await tester.tap(button.first);
  await pumpAndSettle(tester);
}
```

### Enter Text
```dart
final textField = find.byType(TextField);
await tester.enterText(textField.first, 'New York');
await pumpAndSettle(tester);
```

### Verify Widget
```dart
expect(find.byType(HomePage), findsOneWidget);
```

## Adding New Tests

1. Create `new_feature_test.dart` in `integration_test/`
2. Import helpers and setup binding
3. Group related tests
4. Use descriptive test names
5. Handle both success and failure scenarios
6. Add to CI/CD pipeline

## Support & Resources

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Integration Test Package](https://pub.dev/packages/integration_test)
- [Test Helpers](helpers/test_helpers.dart)
- [Mock Providers](helpers/mock_providers.dart)
- [Full README](README.md)

## Next Steps

- ✅ Run all tests locally
- ✅ Verify tests pass on your device
- ✅ Integrate tests into CI/CD
- ✅ Set up automated test runs
- ✅ Monitor test results and performance

---

**Happy Testing! 🧪**

For issues or questions, check the full [README.md](README.md) or review existing test implementations.
