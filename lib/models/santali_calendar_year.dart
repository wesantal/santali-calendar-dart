/// Complete calendar year for the Santali calendar.
///
/// Contains all months in a Santali year and metadata about the
/// year's position in the Metonic cycle.
library;

import 'package:santali_calendar/models/santali_calendar_month.dart';

/// A complete Santali calendar year.
///
/// Returned by [SantaliCalendar.getCalendar]. Contains the list of
/// [SantaliCalendarMonth] grids and metadata about the year's
/// Gregorian date range.
class SantaliCalendarYear {
  /// Gregorian year (e.g. 2026).
  final int year;

  /// Gregorian end date of the year (last day of Pus).
  final DateTime endDate;

  /// Gregorian start date of the year (Chandradarshan of Mag).
  final DateTime startDate;

  /// Index of the month containing today (0-based).
  final int currentMonthIndex;

  /// Calendar months in this year (12 or 13 in leap years).
  final List<SantaliCalendarMonth> months;

  /// Creates a calendar year.
  const SantaliCalendarYear({
    required this.year,
    required this.months,
    required this.endDate,
    required this.startDate,
    required this.currentMonthIndex,
  });
}
