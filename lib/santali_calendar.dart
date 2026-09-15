import 'dart:math' as math;

import 'package:santali_calendar/constants/weeks.dart';
import 'package:santali_calendar/festivals/data.dart';
import 'package:santali_calendar/festivals/types.dart';
import 'package:santali_calendar/models/santali_calendar_day.dart';
import 'package:santali_calendar/models/santali_calendar_month.dart';
import 'package:santali_calendar/models/santali_calendar_year.dart';
import 'package:santali_calendar/models/santali_date.dart';
import 'package:santali_calendar/models/santali_month.dart';
import 'package:santali_calendar/astronomy/moon.dart';
import 'package:santali_calendar/utils/olchiki_number.dart';

/// Traditional Santali lunisolar calendar.
///
/// Month boundaries are determined by Chandradarshan (first visible crescent)
/// using astronomical moon phase calculations ([SantaliMoonCalendar]) on the
/// 19-year Metonic cycle, instead of fixed 29/30-day arithmetic.
///
/// Santali days start at 17:00 IST (11:30 UTC), and day numbers within a
/// month use proportional division of the month's actual duration.
///
/// ```dart
/// final calendar = SantaliCalendar();
/// final today = calendar.today();
/// print(today); // e.g. 3 ᱫᱟᱥᱟᱸᱭ 2026 (Dasany, Gregorian: 2026-09-14)
/// ```
class SantaliCalendar {
  /// Gregorian anchor date of the Santali epoch (Mag 2026 Chandradarshan).
  final DateTime anchorDate = DateTime.utc(2026, 1, 19);
  final SantaliMoonCalendar _moonCalendar;
  final Map<int, List<SantaliMonth>> _monthsCache = {};

  /// Creates a calendar with its own astronomical calculation engine.
  SantaliCalendar() : _moonCalendar = SantaliMoonCalendar();

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  SantaliWeekDay _getWeekDay(DateTime date) {
    return weekDays[date.weekday % 7];
  }

  // ----------------------------------------------------------
  // GET MONTHS FOR A YEAR (cached)
  // ----------------------------------------------------------

  /// Returns the astronomical [SantaliMonth] objects for [year].
  ///
  /// Results are cached, since month calculation involves full
  /// astronomical computations per month. Leap years contain 13 months
  /// (including Sarcha), normal years contain 12.
  List<SantaliMonth> buildMonths(int year) {
    return _monthsCache.putIfAbsent(year, () {
      return _moonCalendar.getSantaliMonths(year);
    });
  }

  // ----------------------------------------------------------
  // TOTAL DAYS IN A SANTALI YEAR
  // ----------------------------------------------------------

  /// Returns the total number of days in the Santali year [year].
  ///
  /// This is 354 for normal years and 384 for leap years (which include
  /// the 30-day intercalary month Sarcha).
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

  /// Returns the Gregorian start date of the Santali year [year].
  ///
  /// This is the Chandradarshan (first visible crescent) of the Magh
  /// month's new moon, at 11:30 UTC (17:00 IST).
  DateTime yearStart(int year) {
    final magStartMs = _moonCalendar.getMagStartMoon(year);
    final startMs = _moonCalendar.getChandradarshan(magStartMs);
    return DateTime.fromMillisecondsSinceEpoch(startMs, isUtc: true);
  }

  // ----------------------------------------------------------
  // BUILD CALENDAR MONTH
  // ----------------------------------------------------------

  /// Builds a renderable calendar grid for [month].
  ///
  /// Cells from [previousMonth] and [nextMonth] fill the leading and
  /// trailing partial weeks so the grid always holds complete rows of 7.
  /// Pass [today] (usually from [today] or [getCalendarToday]) to mark
  /// the `isToday` cell.
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
      final firstPreviousDay = (previousMonth.totalDays - startWeekday) + 1;

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
            olChikiDay: toOlChikiNumeral(day),
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
          olChikiDay: toOlChikiNumeral(day),
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
            olChikiDay: toOlChikiNumeral(day),
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

  /// Returns the complete renderable calendar for the Santali year [year].
  ///
  /// Includes a [SantaliCalendarMonth] grid for every month and the
  /// [SantaliCalendarYear.currentMonthIndex] of today.
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

  /// Returns a single renderable calendar month.
  ///
  /// [monthIndex] is 0-based: 0 = Mag ... 11 = Pus, and 12 = Sarcha
  /// (only present in leap years). Throws a [RangeError] for
  /// out-of-range indices.
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

  /// Converts the Gregorian instant [date] to a [SantaliDate].
  ///
  /// The exact timestamp matters: instants before 17:00 IST (11:30 UTC)
  /// belong to the previous Santali day. Day numbers use proportional
  /// division of the month's actual duration:
  ///
  /// ```dart
  /// final d = calendar.getDate(DateTime.utc(2026, 9, 14, 9, 0));
  /// print(d.day); // 3 (14:30 IST is still day 3 of Dasany)
  /// ```
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

  /// Returns the [SantaliDate] for the current instant.
  ///
  /// See [getDate]: before 17:00 IST the result is still the previous
  /// Santali day. For highlighting today in a calendar grid, use
  /// [getCalendarToday] instead.
  SantaliDate today() {
    return getDate(DateTime.now());
  }

  /// Returns the [SantaliDate] of today's calendar-grid cell.
  ///
  /// Evaluates the Santali day starting at 17:00 IST on today's
  /// Gregorian date, so the result always matches the `isToday` cell
  /// produced by [buildCalendarMonth], even before 17:00 IST.
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

  /// Returns whether Santali year [year] is a leap year.
  ///
  /// Leap years follow the 19-year Metonic cycle and contain the
  /// 13th intercalary month Sarcha (384 days instead of 354).
  bool isLeapYear(int year) {
    return _moonCalendar.isSantaliLeapYear(year);
  }

  // ----------------------------------------------------------
  // DAYS IN MONTH
  // ----------------------------------------------------------

  /// Returns the number of days in the Santali month [monthIndex] of [year].
  ///
  /// Throws a [RangeError] for out-of-range indices.
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

  /// Returns the Santali month index containing the instant [date].
  ///
  /// The raw timestamp is compared against month boundaries
  /// (Chandradarshan instants at 11:30 UTC).
  int getMonthIndex(DateTime date) {
    return _moonCalendar.getMonthIndex(date);
  }

  // ----------------------------------------------------------
  // CALENDAR MONTH INDEX FROM GREGORIAN DATE
  // ----------------------------------------------------------

  /// Returns the Santali month index for a Gregorian calendar cell.
  ///
  /// A calendar cell for a Gregorian date represents the Santali day
  /// starting at 17:00 IST on that date.
  int getCalendarMonthIndex(DateTime date) {
    return _moonCalendar.getCalendarMonthIndex(date);
  }

  // ----------------------------------------------------------
  // GET CALENDAR MONTH FROM GREGORIAN DATE
  // ----------------------------------------------------------

  /// Returns the renderable calendar month containing [date].
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

  /// Returns all festivals of the Santali year [year], sorted by date.
  ///
  /// Festivals resolve from fixed Gregorian rules (e.g. Hul Maha on
  /// June 30) or moon-relative rules (e.g. Sohray on the full moon of
  /// Sohray month). Definitions that cannot be resolved are skipped.
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

  /// Returns the renderable calendar month containing [date].
  ///
  /// Unlike [getMonthByDate], the month is taken from the full
  /// [getCalendar] grid, so its cells carry correct `isToday` flags.
  SantaliCalendarMonth getMonthByDate(DateTime date) {
    final santaliDate = getDate(date);
    final calendar = getCalendar(santaliDate.year);
    return calendar.months[santaliDate.monthIndex];
  }

  /// Returns the renderable calendar month containing today.
  SantaliCalendarMonth getCurrentMonth() {
    return getMonthByDate(DateTime.now());
  }
}
