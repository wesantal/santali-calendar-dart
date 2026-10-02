/// Calendar month grid for a Santali month.
///
/// Extends [SantaliMonth] with a flat list of [SantaliCalendarDay]
/// cells for rendering in a 7-column calendar grid.
library;

import 'package:santali_calendar/models/santali_calendar_day.dart';
import 'package:santali_calendar/models/santali_month.dart';
import 'package:santali_calendar/models/santali_season.dart';

/// A renderable calendar month with day cells.
///
/// Extends [SantaliMonth] with a [days] list suitable for calendar
/// grid rendering. The list contains 7 × N cells (complete rows of 7),
/// with `null` entries for padding days outside the month.
class SantaliCalendarMonth extends SantaliMonth {
  /// Flat list of day cells (7 × number of rows).
  ///
  /// `null` entries represent padding cells before the first day
  /// or after the last day of the month.
  final List<SantaliCalendarDay?> days;
  final SantaliSeasonDefinition season;

  /// Creates a calendar month.
  const SantaliCalendarMonth({
    required this.days,
    required this.season,
    required super.id,
    required super.name,
    required super.roman,
    required super.index,
    required super.endDate,
    required super.startDate,
    required super.totalDays,
    required super.isLeapMonth,
    required super.newMoonDate,
    required super.fullMoonDate,
    required super.displayEndDate,
  });
}
