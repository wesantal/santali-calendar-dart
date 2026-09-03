import 'package:santali_calendar/src/constants/months.dart';
import 'package:santali_calendar/src/models/santali_calendar_year.dart';
import 'package:santali_calendar/src/models/santali_date.dart';
import 'package:santali_calendar/src/models/santali_month.dart';
import 'package:santali_calendar/src/utils/leap_year.dart';

class SantaliCalendar {
  final DateTime anchorDate;
  final int anchorYear;

  SantaliCalendar({DateTime? anchorDate, this.anchorYear = 2026})
    : anchorDate = anchorDate ?? DateTime.utc(2026, 1, 19);

  // ----------------------------------------------------------
  // Normalize any DateTime to UTC date only
  // ----------------------------------------------------------

  DateTime _normalize(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  // ----------------------------------------------------------
  // TOTAL DAYS IN A SANTALI YEAR
  //
  // IMPORTANT:
  // Does NOT call buildMonths().
  // This prevents infinite recursion.
  // ----------------------------------------------------------

  int yearLength(int year) {
    const baseYearDays = 354;
    const sarchaDays = 30;
    return baseYearDays + (isLeapYear(year) ? sarchaDays : 0);
  }

  // ----------------------------------------------------------
  // GET START DATE OF SANTALI YEAR
  // ----------------------------------------------------------

  DateTime yearStart(int year) {
    if (year == anchorYear) {
      return anchorDate;
    }

    var currentYear = anchorYear;
    var currentDate = anchorDate;

    // Future year
    if (year > anchorYear) {
      while (currentYear < year) {
        currentDate = currentDate.add(Duration(days: yearLength(currentYear)));

        currentYear++;
      }

      return currentDate;
    }

    // Previous year
    while (currentYear > year) {
      currentYear--;

      currentDate = currentDate.subtract(
        Duration(days: yearLength(currentYear)),
      );
    }

    return currentDate;
  }

  // ----------------------------------------------------------
  // BUILD ALL MONTHS FOR A YEAR
  // ----------------------------------------------------------

  List<SantaliMonth> buildMonths(int year) {
    final definitions = <SantaliMonth>[
      ...santaliMonths,
      if (isLeapYear(year)) sarchaMonth,
    ];

    final start = yearStart(year);
    var cursor = start;

    return definitions.map((month) {
      final monthStart = cursor;

      final monthEnd = monthStart.add(Duration(days: month.days - 1));

      cursor = monthStart.add(Duration(days: month.days));

      return month.copyWith(startDate: monthStart, endDate: monthEnd);
    }).toList();
  }

  // ----------------------------------------------------------
  // GET COMPLETE CALENDAR YEAR
  // ----------------------------------------------------------

  SantaliCalendarYear getCalendar(int year) {
    final startDate = yearStart(year);

    final months = buildMonths(year);

    final endDate = startDate.add(Duration(days: yearLength(year) - 1));

    return SantaliCalendarYear(
      year: year,
      startDate: startDate,
      endDate: endDate,
      months: months,
    );
  }

  // ----------------------------------------------------------
  // GET ONE MONTH BY INDEX
  //
  // 0 = Mag
  // 1 = Phagun
  // ...
  // 11 = Pus
  // ----------------------------------------------------------

  SantaliMonth getMonth(int year, int monthIndex) {
    if (monthIndex < 0 || monthIndex >= santaliMonths.length) {
      throw RangeError('Invalid Santali month index: $monthIndex');
    }

    return buildMonths(year)[monthIndex];
  }

  // ----------------------------------------------------------
  // GET SANTALI DATE FROM GREGORIAN DATE
  // ----------------------------------------------------------

  SantaliDate getDate(DateTime date) {
    final normalized = _normalize(date);

    var year = anchorYear;

    while (true) {
      final start = yearStart(year);

      final end = start.add(Duration(days: yearLength(year) - 1));

      final isAfterOrEqualStart = !normalized.isBefore(start);

      final isBeforeOrEqualEnd = !normalized.isAfter(end);

      // Date belongs to this year
      if (isAfterOrEqualStart && isBeforeOrEqualEnd) {
        return _findDateInYear(normalized, year);
      }

      // Move backward
      if (normalized.isBefore(start)) {
        year--;
      }
      // Move forward
      else {
        year++;
      }
    }
  }

  // ----------------------------------------------------------
  // FIND MONTH AND DAY INSIDE YEAR
  // ----------------------------------------------------------

  SantaliDate _findDateInYear(DateTime date, int year) {
    final months = buildMonths(year);

    for (var index = 0; index < months.length; index++) {
      final month = months[index];

      final start = month.startDate!;
      final end = month.endDate!;

      final isAfterOrEqualStart = !date.isBefore(start);

      final isBeforeOrEqualEnd = !date.isAfter(end);

      if (isAfterOrEqualStart && isBeforeOrEqualEnd) {
        final day = date.difference(start).inDays + 1;

        return SantaliDate(
          year: year,
          monthIndex: index,
          month: month,
          monthEnglish: month.english,
          day: day,
          gregorianDate: date,
          monthStartDate: start,
          monthEndDate: end,
        );
      }
    }

    throw StateError(
      'Santali date could not be determined '
      'for $date.',
    );
  }

  // ----------------------------------------------------------
  // TODAY
  // ----------------------------------------------------------

  SantaliDate today() {
    return getDate(DateTime.now());
  }
}
