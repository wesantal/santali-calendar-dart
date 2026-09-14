import 'package:santali_calendar/santali_calendar.dart';

void main() {
  final calendar = SantaliCalendar();

  // Today's Santali date (exact instant; before 17:00 IST this is still
  // the previous Santali day).
  final today = calendar.today();
  print('Today: $today');
  print('Purnima: ${today.isPurnima}, Amavasya: ${today.isAmavasya}');

  // Santali date of today's calendar-grid cell (always matches the
  // highlighted cell, even before 17:00 IST).
  final gridToday = calendar.getCalendarToday();
  print('Grid today: day ${gridToday.day} of ${gridToday.month.roman}');

  // Convert any Gregorian date.
  final date = calendar.getDate(DateTime.utc(2026, 9, 14, 9, 0));
  print('Converted: $date');

  // A single month with its calendar grid.
  final dasany = calendar.getMonth(2026, 8);
  print('${dasany.name} (${dasany.roman}): ${dasany.totalDays} days');

  // Festivals of the year, sorted by date.
  for (final festival in calendar.getFestivals(2026)) {
    print('${festival.roman}: ${festival.date.toUtc()}');
  }
}
