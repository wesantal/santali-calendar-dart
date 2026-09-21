/// Santali date representation.
///
/// Returned by [SantaliCalendar.getDate], [SantaliCalendar.today],
/// and [SantaliCalendar.getCalendarToday]. Provides the day number,
/// month, year, weekday, and lunar-phase flags for a specific
/// Gregorian instant.
library;

import 'package:santali_calendar/models/santali_month.dart';
import 'package:santali_calendar/utils/olchiki_number.dart';

/// A Santali date for a specific Gregorian instant.
///
/// The [date] field holds the raw UTC timestamp of the queried instant.
/// Day numbers use proportional division within the month, matching
/// the reference implementation.
class SantaliDate {
  /// Day number within the Santali month (1-based).
  final int day;

  /// Gregorian year of the queried instant.
  final int year;

  /// Day of the week (`DateTime.weekday`: Monday = 1 ... Sunday = 7).
  final int weekDay;

  /// 0-based index of the Santali month within its year.
  final int monthIndex;

  /// Raw UTC timestamp of the queried instant.
  final DateTime date;

  /// Whether this day is Purnima (full moon).
  final bool isPurnima;

  /// Whether this day is Amavasya (new moon / last day of month).
  final bool isAmavasya;

  /// Whether this year contains the leap month Sarcha.
  final bool isLeapMonth;

  /// The Santali month containing this date.
  final SantaliMonth month;

  /// Whether this is the first day of the Santali month.
  final bool isFirstMoonDay;

  /// Creates a Santali date.
  const SantaliDate({
    required this.day,
    required this.year,
    required this.date,
    required this.month,
    required this.weekDay,
    required this.monthIndex,
    required this.isPurnima,
    required this.isAmavasya,
    required this.isLeapMonth,
    required this.isFirstMoonDay,
  });

  /// Ol Chiki numeral of the day number.
  String get olChikiDay => toOlChikiNumeral(day);

  /// Ol Chiki numeral of the year.
  String get olChikiYear => toOlChikiNumeral(year);

  @override
  String toString() {
    return '$day ${month.name} $year '
        '(${month.roman}, Gregorian: '
        '${date.toIso8601String().split("T").first})';
  }
}
