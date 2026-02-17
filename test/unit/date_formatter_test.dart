import 'package:flutter_test/flutter_test.dart';
import 'package:weatherly/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter', () {
    test('formats time correctly', () {
      final dateTime = DateTime(2024, 1, 15, 14, 30);
      expect(DateFormatter.formatTime(dateTime), '14:30');
    });

    test('formats date correctly', () {
      final dateTime = DateTime(2024, 1, 15);
      final result = DateFormatter.formatDate(dateTime);
      expect(result, contains('Jan'));
      expect(result, contains('15'));
      expect(result, contains('2024'));
    });

    test('formats day correctly', () {
      final monday = DateTime(2024, 1, 15); // Monday
      expect(DateFormatter.formatDay(monday), 'Monday');
    });

    test('formats short day correctly', () {
      final monday = DateTime(2024, 1, 15); // Monday
      expect(DateFormatter.formatShortDay(monday), 'Mon');
    });

    test('formats hour correctly', () {
      final dateTime = DateTime(2024, 1, 15, 14, 30);
      final result = DateFormatter.formatHour(dateTime);
      expect(result.toLowerCase(), contains('pm'));
    });

    test('gets relative time correctly', () {
      final now = DateTime.now();

      // Just now
      final justNow = now.subtract(const Duration(seconds: 30));
      expect(DateFormatter.getRelativeTime(justNow), 'Just now');

      // Minutes ago
      final minutesAgo = now.subtract(const Duration(minutes: 5));
      expect(DateFormatter.getRelativeTime(minutesAgo), '5m ago');

      // Hours ago
      final hoursAgo = now.subtract(const Duration(hours: 2));
      expect(DateFormatter.getRelativeTime(hoursAgo), '2h ago');

      // Days ago
      final daysAgo = now.subtract(const Duration(days: 3));
      expect(DateFormatter.getRelativeTime(daysAgo), '3d ago');
    });
  });
}
