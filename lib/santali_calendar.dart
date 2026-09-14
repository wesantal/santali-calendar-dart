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
  final DateTime anchorDate;
  final int anchorYear;
  final SantaliMoonCalendar _moonCalendar;
  final Map<int, List<SantaliMonth>> _monthsCache = {};

  SantaliCalendar({DateTime? anchorDate, this.anchorYear = 2026})
    : anchorDate = anchorDate ?? DateTime.utc(2026, 1, 19),
      _moonCalendar = SantaliMoonCalendar();

  // ----------------------------------------------------------
  // Normalize any DateTime to the Santali day it belongs to.
  //
  // Santali days start at 17:00 IST (11:30 UTC).
  // A Gregorian date before 11:30 UTC belongs to the
  // previous Santali day, so we shift it back.
  // ----------------------------------------------------------

  static const int _santaliStartUtcHour = 11;
  static const int _santaliStartUtcMinute = 30;

  DateTime _normalize(DateTime date) {
    final utc = date.toUtc();
    var year = utc.year;
    var month = utc.month;
    var day = utc.day;

    // If before 11:30 UTC, this Gregorian instant belongs to
    // the previous Santali day → shift the date back one day.
    if (utc.hour < _santaliStartUtcHour ||
        (utc.hour == _santaliStartUtcHour &&
            utc.minute < _santaliStartUtcMinute)) {
      final prev = DateTime.utc(year, month, day).subtract(
        const Duration(days: 1),
      );
      year = prev.year;
      month = prev.month;
      day = prev.day;
    }

    return DateTime.utc(year, month, day);
  }

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

      final start = month.startDate;
      final end = month.endDate;

      final isAfterOrEqualStart = !date.isBefore(start);
      final isBeforeOrEqualEnd = !date.isAfter(end);

      if (isAfterOrEqualStart && isBeforeOrEqualEnd) {
        final day = date.difference(start).inDays + 1;

        final isPurnima = _isSameGregorianDate(date, month.fullMoonDate);
        final isAmavasya = _isSameGregorianDate(date, month.newMoonDate);

        return SantaliDate(
          day: day,
          year: year,
          monthIndex: index,
          month: month,
          date: date,
          weekDay: date.weekday,
          monthStartDate: start,
          monthEndDate: end,
          monthEnglish: month.roman,
          isPurnima: isPurnima,
          isAmavasya: isAmavasya,
          isLeapMonth: month.isLeapMonth,
        );
      }
    }

    throw StateError('Santali date could not be determined for $date.');
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
