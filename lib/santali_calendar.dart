import 'dart:math' as math;

import 'package:santali_calendar/src/constants/weeks.dart';
import 'package:santali_calendar/src/festivals/data.dart';
import 'package:santali_calendar/src/festivals/types.dart';
import 'package:santali_calendar/src/models/santali_calendar_day.dart';
import 'package:santali_calendar/src/models/santali_calendar_month.dart';
import 'package:santali_calendar/src/models/santali_calendar_year.dart';
import 'package:santali_calendar/src/models/santali_date.dart';
import 'package:santali_calendar/src/models/santali_month.dart';
import 'package:santali_calendar/src/astronomy/moon.dart';

class SantaliCalendar {
  final DateTime anchorDate = DateTime.utc(2026, 1, 19);
  final SantaliMoonCalendar _moonCalendar;
  final Map<int, List<SantaliMonth>> _monthsCache = {};

  SantaliCalendar() : _moonCalendar = SantaliMoonCalendar();

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  SantaliWeekDay _getWeekDay(DateTime date) {
    return weekDays[date.weekday - 1];
  }

  // ----------------------------------------------------------
  // GET MONTHS FOR A YEAR (cached)
  // ----------------------------------------------------------

  List<SantaliMonth> buildMonths(int year) {
    return _monthsCache.putIfAbsent(year, () {
      return _moonCalendar.getSantaliMonths(year);
    });
  }

  // ----------------------------------------------------------
  // TOTAL DAYS IN A SANTALI YEAR
  // ----------------------------------------------------------

  int yearLength(int year) {
    final months = buildMonths(year);
    int totalDays = 0;
    for (final month in months) {
      totalDays += month.totalDays;
    }
    return totalDays;
  }

  // ----------------------------------------------------------
  // GET START DATE OF SANTALI YEAR
  //
  // Uses the first Chandradarshan (new moon start) of Magh month.
  // ----------------------------------------------------------

  DateTime yearStart(int year) {
    final magStartMs = _moonCalendar.getMagStartMoon(year);
    final startMs = _moonCalendar.getChandradarshan(magStartMs);
    return DateTime.fromMillisecondsSinceEpoch(startMs, isUtc: true);
  }

  // ----------------------------------------------------------
  // BUILD CALENDAR MONTH
  // ----------------------------------------------------------

  SantaliCalendarMonth buildCalendarMonth(
    SantaliMonth month,
    SantaliDate today, {
    SantaliMonth? previousMonth,
    SantaliMonth? nextMonth,
  }) {
    final cells = <SantaliCalendarDay?>[];

    final firstDay = month.startDate;

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
      final previousStart = previousMonth.startDate;

      final firstPreviousDay = previousMonth.totalDays - startWeekday + 1;

      for (var day = firstPreviousDay; day <= previousMonth.totalDays; day++) {
        final date = previousStart.add(Duration(days: day - 1));
        final isPurnima = _isSameGregorianDate(
          date,
          previousMonth.fullMoonDate,
        );
        final isAmavasya = _isSameGregorianDate(
          date,
          previousMonth.newMoonDate,
        );
        cells.add(
          SantaliCalendarDay(
            day: day,
            date: date,
            isCurrentMonth: false,
            weekDay: _getWeekDay(date),
            isPurnima: isPurnima,
            isAmavasya: isAmavasya,
            isToday: _isSameDate(today.date, date),
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

    for (var day = 1; day <= month.totalDays; day++) {
      final date = firstDay.add(Duration(days: day - 1));
      final isPurnima = _isSameGregorianDate(date, month.fullMoonDate);
      final isAmavasya = _isSameGregorianDate(date, month.newMoonDate);
      cells.add(
        SantaliCalendarDay(
          day: day,
          date: date,
          isCurrentMonth: true,
          weekDay: _getWeekDay(date),
          isPurnima: isPurnima,
          isAmavasya: isAmavasya,
          isToday: _isSameDate(today.date, date),
        ),
      );
    }

    // ----------------------------------------------------------
    // NEXT MONTH DAYS
    // ----------------------------------------------------------

    final remainder = cells.length % 7;

    if (remainder != 0 && nextMonth != null) {
      final requiredDays = 7 - remainder;
      final nextStart = nextMonth.startDate;

      for (
        var day = 1;
        day <= requiredDays && day <= nextMonth.totalDays;
        day++
      ) {
        final date = nextStart.add(Duration(days: day - 1));
        final isPurnima = _isSameGregorianDate(date, nextMonth.fullMoonDate);
        final isAmavasya = _isSameGregorianDate(date, nextMonth.newMoonDate);
        cells.add(
          SantaliCalendarDay(
            day: day,
            date: date,
            isCurrentMonth: false,
            weekDay: _getWeekDay(date),
            isPurnima: isPurnima,
            isAmavasya: isAmavasya,
            isToday: _isSameDate(today.date, date),
          ),
        );
      }
    }

    // Complete last row
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    return SantaliCalendarMonth(
      days: cells.toList(),
      id: month.id,
      name: month.name,
      roman: month.roman,
      index: month.index,
      endDate: month.endDate,
      startDate: month.startDate,
      totalDays: month.totalDays,
      isLeapMonth: month.isLeapMonth,
      newMoonDate: month.newMoonDate,
      fullMoonDate: month.fullMoonDate,
      displayEndDate: month.displayEndDate,
    );
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
  // 12 = Sarcha (leap month, only in leap years)
  // ----------------------------------------------------------

  SantaliCalendarMonth getMonth(int year, int monthIndex) {
    final months = buildMonths(year);
    if (monthIndex < 0 || monthIndex >= months.length) {
      throw RangeError('Invalid Santali month index: $monthIndex');
    }
    return buildCalendarMonth(
      months[monthIndex],
      getDate(DateTime.now()),
      previousMonth:
          months[monthIndex > 0 ? monthIndex - 1 : months.length - 1],
      nextMonth: months[monthIndex < months.length - 1 ? monthIndex + 1 : 0],
    );
  }

  // ----------------------------------------------------------
  // GET SANTALI DATE FROM GREGORIAN DATE
  //
  // Uses raw timestamps (no normalization) to match the TS
  // algorithm: proportional day division within the month.
  // ----------------------------------------------------------

  SantaliDate getDate(DateTime date) {
    final target = date.toUtc();
    final targetMs = target.millisecondsSinceEpoch;

    final gregorianYear = target.year;

    // Try current Gregorian year first
    var months = buildMonths(gregorianYear);
    var result = _findMonthAndDay(target, targetMs, months, gregorianYear);
    if (result != null) return result;

    // Try previous year
    months = buildMonths(gregorianYear - 1);
    result = _findMonthAndDay(target, targetMs, months, gregorianYear - 1);
    if (result != null) return result;

    // Try next year
    months = buildMonths(gregorianYear + 1);
    result = _findMonthAndDay(target, targetMs, months, gregorianYear + 1);
    if (result != null) return result;

    throw StateError('Unable to determine Santali date for $date');
  }

  // ----------------------------------------------------------
  // FIND MONTH AND DAY USING RAW TIMESTAMP
  //
  // Matches the TS getDate algorithm:
  //   day = Math.floor((targetMs - startMs) / dayDuration) + 1
  // ----------------------------------------------------------

  SantaliDate? _findMonthAndDay(
    DateTime target,
    int targetMs,
    List<SantaliMonth> months,
    int year,
  ) {
    for (var index = 0; index < months.length; index++) {
      final month = months[index];
      final startMs = month.startDate.millisecondsSinceEpoch;
      final endMs = month.endDate.millisecondsSinceEpoch;

      if (targetMs >= startMs && targetMs < endMs) {
        final totalDays = month.totalDays;
        final dayDuration = (endMs - startMs) / totalDays;
        var day = ((targetMs - startMs) / dayDuration).floor() + 1;
        day = math.max(1, math.min(totalDays, day));

        final isPurnima = _isSameGregorianDate(target, month.fullMoonDate);
        final isAmavasya = _isSameGregorianDate(target, month.newMoonDate);

        return SantaliDate(
          day: day,
          month: month,
          date: target,
          year: target.year,
          monthIndex: index,
          isPurnima: isPurnima,
          isAmavasya: isAmavasya,
          weekDay: target.weekday,
          isLeapMonth: month.isLeapMonth,
        );
      }
    }
    return null;
  }

  bool _isSameGregorianDate(DateTime a, DateTime? b) {
    if (b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // ----------------------------------------------------------
  // TODAY
  // ----------------------------------------------------------

  SantaliDate today() {
    return getDate(DateTime.now());
  }

  SantaliDate getCalendarToday() {
    final date = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      23, // hour
      59, // minute
      59, // second
      999, // millisecond
    );
    return getDate(date);
  }
  // ----------------------------------------------------------
  // LEAP YEAR CHECK
  // ----------------------------------------------------------

  bool isLeapYear(int year) {
    return _moonCalendar.isSantaliLeapYear(year);
  }

  // ----------------------------------------------------------
  // DAYS IN MONTH
  // ----------------------------------------------------------

  int getDaysInMonth(int year, int monthIndex) {
    final months = buildMonths(year);
    if (monthIndex < 0 || monthIndex >= months.length) {
      throw RangeError('Invalid Santali month index: $monthIndex');
    }
    return months[monthIndex].totalDays;
  }

  // ----------------------------------------------------------
  // MONTH INDEX FROM GREGORIAN DATE
  // ----------------------------------------------------------

  int getMonthIndex(DateTime date) {
    return _moonCalendar.getMonthIndex(date);
  }

  // ----------------------------------------------------------
  // CALENDAR MONTH INDEX FROM GREGORIAN DATE
  // ----------------------------------------------------------

  int getCalendarMonthIndex(DateTime date) {
    return _moonCalendar.getCalendarMonthIndex(date);
  }

  // ----------------------------------------------------------
  // GET CALENDAR MONTH FROM GREGORIAN DATE
  // ----------------------------------------------------------

  SantaliCalendarMonth getMonthFromDate(DateTime date) {
    final santaliDate = getDate(date);
    return getMonth(santaliDate.year, santaliDate.monthIndex);
  }

  // ----------------------------------------------------------
  // FESTIVALS
  // ----------------------------------------------------------

  SantaliFestival _resolveFestival(
    SantaliFestivalDefinition definition,
    int year,
  ) {
    final months = buildMonths(year);

    if (definition.rule is FixedGregorianFestivalRule) {
      final rule = (definition.rule as FixedGregorianFestivalRule).rule;
      final date = DateTime.utc(year, rule.month, rule.day);
      final month = getMonthFromDate(date);
      return SantaliFestival(
        id: definition.id,
        name: definition.name,
        roman: definition.roman,
        monthId: month.id,
        type: definition.type,
        date: date,
        description: definition.description,
      );
    } else {
      final rule = (definition.rule as MoonRelativeFestivalRule).rule;
      final month = months.firstWhere(
        (m) => m.id == rule.monthId,
        orElse: () => throw StateError('Month ${rule.monthId} not found'),
      );

      final DateTime baseDate;
      if (rule.phase == MoonPhase.fullMoon) {
        baseDate = month.fullMoonDate;
      } else {
        baseDate = month.newMoonDate;
      }

      final date = baseDate.add(Duration(days: rule.offsetDays));

      return SantaliFestival(
        id: definition.id,
        name: definition.name,
        roman: definition.roman,
        monthId: rule.monthId,
        type: definition.type,
        date: date,
        description: definition.description,
      );
    }
  }

  List<SantaliFestival> getFestivals(int year) {
    final festivals = <SantaliFestival>[];
    for (final definition in santaliFestivals) {
      try {
        festivals.add(_resolveFestival(definition, year));
      } catch (_) {
        // Skip festival if resolution fails
      }
    }
    festivals.sort((a, b) => a.date.compareTo(b.date));
    return festivals;
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
