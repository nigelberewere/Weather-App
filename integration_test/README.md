# Integration Tests Guide

This directory contains comprehensive integration tests for the Weatherly app's critical user flows.

## Test Coverage

### 1. **Location Permission Flow** (`location_permission_test.dart`)
Tests the app's behavior when requesting location permissions:
- Shows location permission screen on first launch
- Handles permission denial gracefully
- Displays location-based weather when permission granted
- Provides retry mechanism for users who denied permissions

### 2. **Search to Select City Flow** (`search_flow_test.dart`)
Tests the complete search and location selection flow:
- Navigate to search page from home
- Search for cities by typing
- View and select from search results
- Handle empty search results
- Display recent searches

### 3. **Favorites Management Flow** (`favorites_flow_test.dart`)
Tests favorite locations management:
- Navigate to favorites page
- See empty state when no favorites
- Add locations to favorites
- View favorite locations with mini-dashboards
- Remove favorites
- Select favorite to view weather
- Verify favorites persistence

### 4. **Settings Persistence Flow** (`settings_persistence_test.dart`)
Tests that settings changes are saved and persisted:
- Change theme preference (light/dark/auto)
- Change temperature unit (Celsius/Fahrenheit/Kelvin)
- Toggle notification settings
- Persist settings across app navigation
- Persist settings across app restarts
- Reset settings to defaults

### 5. **Complete User Journey** (`user_journey_test.dart`)
Tests the complete app experience:
- App startup and initial loading
- Navigation between all tabs
- Weather data display
- Network error handling
- Pull-to-refresh functionality
- Share functionality
- Access forecast pages
- Access map page
- Theme toggle

## Running the Tests

### Run All Integration Tests
```bash
flutter test integration_test/
```

### Run Specific Test File
```bash
flutter test integration_test/location_permission_test.dart
flutter test integration_test/search_flow_test.dart
flutter test integration_test/favorites_flow_test.dart
flutter test integration_test/settings_persistence_test.dart
flutter test integration_test/user_journey_test.dart
```

### Run on Physical Device
```bash
# Connect device and enable USB debugging (Android) or trust (iOS)
flutter test integration_test/ -d <device_id>
```

### Run on Android Emulator
```bash
flutter test integration_test/ -d emulator-5554
```

### Run on iOS Simulator
```bash
flutter test integration_test/ -d emulator
```

### Verbose Output
```bash
flutter test integration_test/ -v
```

## Prerequisites

1. **Flutter SDK** - Latest stable version
2. **Connected Device or Emulator** - Integration tests require a running device/emulator
3. **Permissions** - For location tests, ensure test device has location permissions configured
4. **Environment Setup** - Ensure `.env` file is configured with API keys

## Test Helpers

The `helpers/test_helpers.dart` file provides utility functions for common test operations:

### Widget Navigation
- `buildTestApp()` - Initialize and build the app
- `pumpAndSettle()` - Wait for animations to complete

### User Interactions
- `tapButton()` - Tap a button by type
- `tapButtonByText()` - Tap a button by text
- `enterText()` - Enter text in a text field
- `scrollTo()` - Scroll to find a widget

### Assertions
- `expectText()` - Verify text is displayed
- `expectTextContaining()` - Verify text contains substring

### Utilities
- `waitForLoadingComplete()` - Wait for loading indicators to disappear
- `findText()` - Find text in widget tree
- `waitForWidget()` - Wait for a widget to appear

### Test Data
- `createTestWeather()` - Create sample weather data
- `createTestLocation()` - Create sample location data

## Best Practices

1. **Permissions**: Tests that require location permission may be skipped on devices without permission. Consider mocking this in CI/CD.

2. **Network Calls**: Some tests depend on real API calls (non-mocked). For CI/CD, consider:
   - Mocking the HTTP client
   - Using mock servers
   - Skipping network-dependent tests in CI

3. **Wait for Loading**: Always use `waitForLoadingComplete()` or `pumpAndSettle()` after actions that trigger loading.

4. **Device Independence**: Tests are designed to work on different screen sizes, but may need adjustment for very small screens.

5. **Test Isolation**: Each test should be independent and not rely on state from previous tests.

## Common Issues

### "Device not found"
```bash
flutter devices  # Check connected devices
flutter test integration_test/ -d <device_id>
```

### "Permission denied" errors on location tests
- Grant location permissions manually on test device
- Or update tests to skip location-specific assertions

### Tests timeout
- Increase timeout in test or use longer delays
- Check device performance and network connectivity

### "App crashes on startup"
- Verify `.env` file with required API keys
- Check device storage space
- Ensure app can run normally before testing

## CI/CD Integration

For GitHub Actions, add to `.github/workflows/test.yml`:

```yaml
- name: Run integration tests
  run: flutter test integration_test/ --verbose
```

For more complex setups that require mocking or emulator setup, see CI/CD documentation.

## Adding New Tests

When adding new integration tests:

1. Create new file in `integration_test/` directory
2. Import `IntegrationTestWidgetsFlutterBinding` and helpers
3. Use `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`
4. Group tests logically with `group()`
5. Use descriptive test names
6. Add documentation comment
7. Use helper functions for common operations
8. Handle both success and failure cases

Example:
```dart
import 'package:integration_test/integration_test.dart';
import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('My Feature Integration Tests', () {
    testWidgets('Description of test', (WidgetTester tester) async {
      await buildTestApp(tester);
      await waitForLoadingComplete(tester);
      
      // Test implementation
      expect(find.byType(MyWidget), findsOneWidget);
    });
  });
}
```

## Debugging Tests

### View Screen Captures
Tests automatically capture screenshots on failure. Check:
- `build/integration_test/` directory after test failure

### Print Debug Information
```dart
debugPrint('Debug message: ${find.byType(MyWidget).evaluate()}');
```

### Slow Motion
Run tests in slow motion to observe UI changes:
```bash
flutter test integration_test/ --route-test-timeout 5000
```

### Step Through Tests
Use breakpoints in IDE and run with debugger:
```bash
flutter test integration_test/ --start-paused
```

## Performance Considerations

- Integration tests run slower than unit tests
- Minimize UI interactions and animations
- Use `pumpAndSettle()` judiciously
- Consider breaking large flows into smaller tests
- Run on a device with adequate performance for CI/CD

## Support

For issues or questions about integration tests:
1. Check the flutter testing documentation
2. Review test helper source code
3. Examine existing test examples
4. Consult team development guidelines
