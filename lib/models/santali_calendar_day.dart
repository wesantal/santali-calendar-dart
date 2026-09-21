/// Calendar day cell within a Santali calendar month grid.
///
/// Each cell represents a single day in the calendar grid, with its
/// Gregorian date, Ol Chiki numeral, weekday, and lunar-phase flags.
library;

import 'package:santali_calendar/constants/weeks.dart';

/// A single day cell in the calendar grid.
///
/// Contains all information needed to render a day in the UI:
/// the day number, Gregorian date, weekday, and flags for
/// [isPurnima], [isAmavasya], [isFirstMoonDay], and [isToday].
class SantaliCalendarDay {
  /// Day number within the Santali month (1-based).
  final int day;

  /// Whether this cell represents today.
  final bool isToday;

  /// Gregorian date of this day.
  final DateTime date;

  /// Whether this day is Purnima (full moon).
  final bool isPurnima;

  /// Whether this day is Amavasya (new moon / last day of month).
  final bool isAmavasya;

  /// Ol Chiki numeral of the day number.
  final String olChikiDay;

  /// Whether this is the first day of the Santali month.
  final bool isFirstMoonDay;

  /// Whether this day belongs to the displayed month.
  final bool isCurrentMonth;

  /// Weekday of this day.
  final SantaliWeekDay weekDay;

  /// Creates a calendar day cell.
  const SantaliCalendarDay({
    required this.day,
    required this.date,
    required this.weekDay,
    required this.isToday,
    required this.isPurnima,
    required this.isAmavasya,
    required this.olChikiDay,
    required this.isFirstMoonDay,
    required this.isCurrentMonth,
  });
}
