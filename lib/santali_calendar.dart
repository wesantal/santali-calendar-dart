import 'package:santali_calendar/src/constants/months.dart';
import 'package:santali_calendar/src/constants/weeks.dart';
import 'package:santali_calendar/src/models/santali_calendar_day.dart';
import 'package:santali_calendar/src/models/santali_calendar_month.dart';
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

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
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

  SantaliCalendarMonth buildCalendarMonth(
    SantaliMonth month,
    SantaliDate today, {
    SantaliMonth? previousMonth,
    SantaliMonth? nextMonth,
  }) {
    final cells = <SantaliCalendarDay?>[];

    final firstDay = month.startDate!;

    // Dart:
    // Monday = 1 ... Sunday = 7
    //
    // Required:
    // Sunday = 0 ... Saturday = 6
    final startWeekday = firstDay.weekday % 7;

    // ----------------------------------------------------------
    // PREVIOUS MONTH DAYS
    // ----------------------------------------------------------

    if (previousMonth != null) {
      final previousStart = previousMonth.startDate!;

      final firstPreviousDay = previousMonth.days - startWeekday + 1;

      for (var day = firstPreviousDay; day <= previousMonth.days; day++) {
        final date = previousStart.add(Duration(days: day - 1));

        cells.add(
          SantaliCalendarDay(
            day: day,
            date: date,
            isCurrentMonth: false,
            isToday: _isSameDate(today.gregorianDate, date),
          ),
        );
      }
    } else {
      for (var i = 0; i < startWeekday; i++) {
        cells.add(null);
      }
    }

    // ----------------------------------------------------------
    // CURRENT MONTH DAYS
    // ----------------------------------------------------------

    for (var day = 1; day <= month.days; day++) {
      final date = firstDay.add(Duration(days: day - 1));

      cells.add(
        SantaliCalendarDay(
          day: day,
          date: date,
          isCurrentMonth: true,
          isToday: _isSameDate(today.gregorianDate, date),
        ),
      );
    }

    // ----------------------------------------------------------
    // NEXT MONTH DAYS
    // ----------------------------------------------------------

    final remainder = cells.length % 7;

    if (remainder != 0 && nextMonth != null) {
      final requiredDays = 7 - remainder;
      final nextStart = nextMonth.startDate!;

      for (var day = 1; day <= requiredDays && day <= nextMonth.days; day++) {
        final date = nextStart.add(Duration(days: day - 1));

        cells.add(
          SantaliCalendarDay(
            day: day,
            date: date,
            isCurrentMonth: false,
            isToday: _isSameDate(today.gregorianDate, date),
          ),
        );
      }
    }

    // Complete last row
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    // ----------------------------------------------------------
    // CONVERT CELLS TO WEEKDAY-COLUMN MAP
    // ----------------------------------------------------------

    final rows = (cells.length / 7).ceil();

    final calendar = <SantaliWeekDay, List<SantaliCalendarDay?>>{
      SantaliWeekDay.sunday: [],
      SantaliWeekDay.monday: [],
      SantaliWeekDay.tuesday: [],
      SantaliWeekDay.wednesday: [],
      SantaliWeekDay.thursday: [],
      SantaliWeekDay.friday: [],
      SantaliWeekDay.saturday: [],
    };

    final weekDays = SantaliWeekDay.values;

    for (var row = 0; row < rows; row++) {
      for (var column = 0; column < 7; column++) {
        final index = row * 7 + column;

        calendar[weekDays[column]]!.add(
          index < cells.length ? cells[index] : null,
        );
      }
    }

    return SantaliCalendarMonth(
      days: month.days,
      name: month.name,
      english: month.english,
      startDate: month.startDate,
      endDate: month.endDate,
      calendar: calendar,
    );
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
    final today = getDate(DateTime.now());
    final months = buildMonths(year);
    final calendarMonths = List.generate(months.length, (index) {
      return buildCalendarMonth(
        months[index],
        today,
        previousMonth: months[index > 0 ? index - 1 : months.length - 1],
        nextMonth: months[index < months.length - 1 ? index + 1 : 0],
      );
    });

    final startDate = yearStart(year);
    final endDate = startDate.add(Duration(days: yearLength(year) - 1));

    return SantaliCalendarYear(
      year: year,
      endDate: endDate,
      startDate: startDate,
      months: calendarMonths,
      currentMonthIndex: today.monthIndex,
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

  SantaliCalendarMonth getMonth(int year, int monthIndex) {
    if (monthIndex < 0 || monthIndex >= santaliMonths.length) {
      throw RangeError('Invalid Santali month index: $monthIndex');
    }
    final months = buildMonths(year);
    return buildCalendarMonth(
      months[monthIndex],
      getDate(DateTime.now()),
      previousMonth: months[monthIndex - 1],
      nextMonth: months[monthIndex + 1],
    );
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
          day: day,
          year: year,
          month: month,
          monthEndDate: end,
          monthIndex: index,
          gregorianDate: date,
          monthStartDate: start,
          monthEnglish: month.english,
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

  SantaliCalendarMonth getMonthByDate(DateTime date) {
    final santaliDate = getDate(date);
    final calendar = getCalendar(santaliDate.year);
    return calendar.months[santaliDate.monthIndex];
  }

  SantaliCalendarMonth getCurrentMonth() {
    return getMonthByDate(DateTime.now());
  }
}
