import 'dart:math' as math;

import 'package:santali_calendar/models/santali_date.dart';
import 'package:santali_calendar/models/santali_month.dart';

class MonthAstronomy {
  final int index;
  final int totalDays;
  final DateTime endDate;
  final DateTime startDate;
  final DateTime kunamiDate;
  final DateTime? fullMoonIST;
  final DateTime? fullMoonAstronomical;

  const MonthAstronomy({
    required this.index,
    required this.endDate,
    required this.startDate,
    required this.totalDays,
    required this.kunamiDate,
    required this.fullMoonIST,
    required this.fullMoonAstronomical,
  });
}

class SantaliMoonCalendar {
  static const int msPerSecond = 1000;
  static const int msPerMinute = 60 * msPerSecond;
  static const int msPerHour = 60 * msPerMinute;
  static const int msPerDay = 24 * msPerHour;

  static const int secondsPerDay = 86400;
  static const double julianUnixEpoch = 2440587.5;

  static const int istOffsetMs = 5 * msPerHour + 30 * msPerMinute;

  static const int santaliDayStartUtcHour = 11;
  static const int santaliDayStartUtcMinute = 30;

  static const int metonicCycleStart = 2026;

  static const Set<int> metonicLeapPositions = {1, 4, 7, 9, 12, 15, 18};

  /// Magh 2023 astronomical New Moon anchor.
  /// 2023-01-22T02:23:00+05:30 = 1674334380000 ms
  static const int anchorNmMs = 1674334380000;

  SantaliMoonCalendar();

  // ---------------------------------------------------------------------------
  // BASIC MATH
  // ---------------------------------------------------------------------------

  double degToRad(double degrees) => degrees * math.pi / 180.0;

  double normalizeDegrees(double degrees) {
    var value = degrees % 360.0;
    if (value < 0) value += 360.0;
    return value;
  }

  double sinDeg(double degrees) => math.sin(degToRad(degrees));

  double cosDeg(double degrees) => math.cos(degToRad(degrees));

  // ---------------------------------------------------------------------------
  // JULIAN DAY / DATE
  // ---------------------------------------------------------------------------

  double unixMsToJulianDay(int ms) {
    return ms / msPerDay + julianUnixEpoch;
  }

  int julianDayToUnixMs(double jd) {
    return ((jd - julianUnixEpoch) * msPerDay).round();
  }

  // ---------------------------------------------------------------------------
  // DELTA-T
  // ---------------------------------------------------------------------------

  double calculateDeltaT(double year) {
    double t;

    if (year >= 2005 && year < 2050) {
      t = (year - 2000) / 100;
      return 62.92 + 32.217 * t + 55.89 * t * t;
    }

    if (year >= 1986 && year < 2005) {
      t = (year - 2000) / 100;
      return 63.86 + 33.45 * t - 603.74 * t * t + 1727.5 * t * t * t;
    }

    if (year >= 2050 && year < 2150) {
      t = (year - 1820) / 100;
      return -20 + 32 * t * t - 0.5628 * (2150 - year);
    }

    t = (year - 2000) / 100;
    return 64.7 + 64.5 * t + 0.25 * t * t;
  }

  // ---------------------------------------------------------------------------
  // LUNATION NUMBER
  // ---------------------------------------------------------------------------

  double getApproximateK(int ms) {
    final date = DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
    final year = date.year + (date.month - 1) / 12.0;
    return (year - 2000) * 12.3685;
  }

  // ---------------------------------------------------------------------------
  // LUNAR ARGUMENTS
  // ---------------------------------------------------------------------------

  Map<String, double> getLunarArguments(double k) {
    final t = k / 1236.85;
    final t2 = t * t;
    final t3 = t2 * t;
    final t4 = t3 * t;

    final m = normalizeDegrees(
      2.5534 + 29.1053567 * k - 0.0000014 * t2 - 0.00000011 * t3,
    );

    final mp = normalizeDegrees(
      201.5643 +
          385.81693528 * k +
          0.0107582 * t2 +
          0.00001238 * t3 -
          0.000000058 * t4,
    );

    final f = normalizeDegrees(
      160.7108 +
          390.67050284 * k -
          0.0016118 * t2 -
          0.00000227 * t3 +
          0.000000011 * t4,
    );

    final om = normalizeDegrees(
      124.7746 - 1.56375588 * k + 0.0020672 * t2 + 0.00000215 * t3,
    );

    final e = 1 - 0.002516 * t - 0.0000074 * t2;

    return {
      'T': t,
      'T2': t2,
      'T3': t3,
      'T4': t4,
      'M': m,
      'Mp': mp,
      'F': f,
      'Om': om,
      'E': e,
    };
  }

  // ---------------------------------------------------------------------------
  // PLANETARY CORRECTION
  // ---------------------------------------------------------------------------

  double planetaryCorrection(double t, double k) {
    final a1 = 299.77 + 0.107408 * k - 0.000325 * t * t;
    final a2 = 251.88 + 0.016321 * k;
    final a3 = 251.83 + 26.651886 * k;
    final a4 = 349.42 + 36.412478 * k;
    final a5 = 84.66 + 18.206239 * k;
    final a6 = 141.74 + 53.303771 * k;
    final a7 = 207.14 + 2.453732 * k;
    final a8 = 154.84 + 7.30686 * k;
    final a9 = 34.52 + 27.261239 * k;
    final a10 = 207.19 + 0.121824 * k;
    final a11 = 291.34 + 1.844379 * k;
    final a12 = 161.72 + 24.198154 * k;
    final a13 = 239.56 + 25.513099 * k;
    final a14 = 331.55 + 3.592518 * k;

    return 0.000325 * sinDeg(a1) +
        0.000165 * sinDeg(a2) +
        0.000164 * sinDeg(a3) +
        0.000126 * sinDeg(a4) +
        0.00011 * sinDeg(a5) +
        0.000062 * sinDeg(a6) +
        0.00006 * sinDeg(a7) +
        0.000056 * sinDeg(a8) +
        0.000047 * sinDeg(a9) +
        0.000042 * sinDeg(a10) +
        0.00004 * sinDeg(a11) +
        0.000037 * sinDeg(a12) +
        0.000035 * sinDeg(a13) +
        0.000023 * sinDeg(a14);
  }

  // ---------------------------------------------------------------------------
  // NEW MOON CORRECTION
  // ---------------------------------------------------------------------------

  double newMoonCorrection(Map<String, double> a) {
    final m = a['M']!;
    final mp = a['Mp']!;
    final f = a['F']!;
    final om = a['Om']!;
    final e = a['E']!;

    return -0.4072 * sinDeg(mp) +
        0.17241 * e * sinDeg(m) +
        0.01608 * sinDeg(2 * mp) +
        0.01039 * sinDeg(2 * f) +
        0.00739 * e * sinDeg(mp - m) -
        0.00514 * e * sinDeg(mp + m) +
        0.00208 * e * e * sinDeg(2 * m) -
        0.00111 * sinDeg(mp - 2 * f) -
        0.00057 * sinDeg(mp + 2 * f) +
        0.00056 * e * sinDeg(2 * mp + m) -
        0.00042 * sinDeg(3 * mp) +
        0.00042 * e * sinDeg(m + 2 * f) +
        0.00038 * e * sinDeg(m - 2 * f) -
        0.00024 * e * sinDeg(2 * mp - m) -
        0.00017 * sinDeg(om) -
        0.00007 * sinDeg(mp + 2 * m) +
        0.00004 * sinDeg(2 * mp - 2 * f) +
        0.00004 * sinDeg(3 * m) +
        0.00003 * sinDeg(mp + m - 2 * f) +
        0.00003 * sinDeg(2 * mp + 2 * f) -
        0.00003 * sinDeg(mp + m + 2 * f) +
        0.00003 * sinDeg(mp - m + 2 * f) -
        0.00002 * sinDeg(mp - m - 2 * f) -
        0.00002 * sinDeg(3 * mp + m) +
        0.00002 * sinDeg(4 * mp);
  }

  // ---------------------------------------------------------------------------
  // FULL MOON CORRECTION
  // ---------------------------------------------------------------------------

  double fullMoonCorrection(Map<String, double> a) {
    final m = a['M']!;
    final mp = a['Mp']!;
    final f = a['F']!;
    final om = a['Om']!;
    final e = a['E']!;

    return -0.40614 * sinDeg(mp) +
        0.17302 * e * sinDeg(m) +
        0.01614 * sinDeg(2 * mp) +
        0.01043 * sinDeg(2 * f) +
        0.00734 * e * sinDeg(mp - m) -
        0.00515 * e * sinDeg(mp + m) +
        0.00209 * e * e * sinDeg(2 * m) -
        0.00111 * sinDeg(mp - 2 * f) -
        0.00057 * sinDeg(mp + 2 * f) +
        0.00056 * e * sinDeg(2 * mp + m) -
        0.00042 * sinDeg(3 * mp) +
        0.00042 * e * sinDeg(m + 2 * f) +
        0.00038 * e * sinDeg(m - 2 * f) -
        0.00024 * e * sinDeg(2 * mp - m) -
        0.00017 * sinDeg(om) -
        0.00007 * sinDeg(mp + 2 * m) +
        0.00004 * sinDeg(2 * mp - 2 * f) +
        0.00004 * sinDeg(3 * m) +
        0.00003 * sinDeg(mp + m - 2 * f) +
        0.00003 * sinDeg(2 * mp + 2 * f) -
        0.00003 * sinDeg(mp + m + 2 * f) +
        0.00003 * sinDeg(mp - m + 2 * f) -
        0.00002 * sinDeg(mp - m - 2 * f) -
        0.00002 * sinDeg(3 * mp + m) +
        0.00002 * sinDeg(4 * mp);
  }

  // ---------------------------------------------------------------------------
  // BASE JDE
  // ---------------------------------------------------------------------------

  double getBaseJde(double k) {
    final t = k / 1236.85;
    final t2 = t * t;
    final t3 = t2 * t;
    final t4 = t3 * t;

    return 2451550.09765 +
        29.530588853 * k +
        0.0001337 * t2 -
        0.00000015 * t3 +
        0.00000000073 * t4;
  }

  // ---------------------------------------------------------------------------
  // NEW MOON / FULL MOON
  // ---------------------------------------------------------------------------

  int getNewMoon(double k) {
    final kInt = k.round();
    final args = getLunarArguments(kInt.toDouble());

    var jde = getBaseJde(kInt.toDouble()) + newMoonCorrection(args);
    jde += planetaryCorrection(args['T']!, kInt.toDouble());

    final approximateYear = 2000 + kInt / 12.3685;
    final deltaT = calculateDeltaT(approximateYear);

    jde -= deltaT / secondsPerDay;

    return julianDayToUnixMs(jde);
  }

  int getFullMoon(double k) {
    final kFull = k.floorToDouble() + 0.5;
    final args = getLunarArguments(kFull);

    var jde = getBaseJde(kFull) + fullMoonCorrection(args);
    jde += planetaryCorrection(args['T']!, kFull);

    final approximateYear = 2000 + kFull / 12.3685;
    final deltaT = calculateDeltaT(approximateYear);

    jde -= deltaT / secondsPerDay;

    return julianDayToUnixMs(jde);
  }

  int? getFullMoonBetween(int startMs, int endMs) {
    if (endMs <= startMs) return null;

    final mid = ((startMs + endMs) / 2).round();
    final kApprox = getApproximateK(mid);

    int? best;
    var bestDiff = double.infinity;

    final center = kApprox.floor();

    for (var k = center - 2; k <= center + 3; k++) {
      final fullMoon = getFullMoon(k.toDouble());

      if (fullMoon >= startMs && fullMoon < endMs) {
        final diff = (fullMoon - mid).abs().toDouble();

        if (diff < bestDiff) {
          bestDiff = diff;
          best = fullMoon;
        }
      }
    }

    return best;
  }

  // ---------------------------------------------------------------------------
  // CHANDRADARSHAN
  // ---------------------------------------------------------------------------

  int getChandradarshan(int newMoonMs) {
    final istMs = newMoonMs + istOffsetMs;
    final istDate = DateTime.fromMillisecondsSinceEpoch(istMs, isUtc: true);

    final totalMinutes =
        istDate.hour * 60 +
        istDate.minute +
        istDate.second / 60.0 +
        istDate.millisecond / 60000.0;

    final istMidnightMs = DateTime.utc(
      istDate.year,
      istDate.month,
      istDate.day,
    ).millisecondsSinceEpoch;

    final cutoff = istMidnightMs + 17 * msPerHour;

    if (totalMinutes < 17 * 60) {
      return cutoff - istOffsetMs;
    }

    return cutoff + msPerDay - istOffsetMs;
  }

  // ---------------------------------------------------------------------------
  // METONIC CYCLE
  // ---------------------------------------------------------------------------

  bool isSantaliLeapYear(int year) {
    final position = (((year - metonicCycleStart) % 19 + 19) % 19) + 1;

    return metonicLeapPositions.contains(position);
  }

  // ---------------------------------------------------------------------------
  // CONTINUOUS NEW MOON CHAIN
  // ---------------------------------------------------------------------------

  final List<int> _newMoonChain = [];

  List<int> get newMoonChain => List.unmodifiable(_newMoonChain);

  void _ensureAnchor() {
    if (_newMoonChain.isEmpty) {
      _newMoonChain.add(anchorNmMs);
    }
  }

  int extendNewMoonChain(int untilMs) {
    _ensureAnchor();

    var last = _newMoonChain.last;

    while (last < untilMs + 60 * msPerDay) {
      final searchFrom = last + 25 * msPerDay;
      final kApprox = getApproximateK(searchFrom);
      final center = kApprox.floor();

      int? best;

      for (var k = center - 2; k <= center + 4; k++) {
        final nm = getNewMoon(k.toDouble());

        if (nm > last + 20 * msPerDay && nm < last + 40 * msPerDay) {
          if (best == null || nm < best) {
            best = nm;
          }
        }
      }

      if (best == null || best <= last) {
        break;
      }

      _newMoonChain.add(best);
      last = best;
    }

    return last;
  }

  int getMagStartMoon(int year) {
    _ensureAnchor();

    var index = 0;

    for (var y = 2023; y < year; y++) {
      index += isSantaliLeapYear(y) ? 13 : 12;
    }

    while (_newMoonChain.length <= index) {
      final last = _newMoonChain.last;
      extendNewMoonChain(last + 40 * msPerDay);
    }

    return _newMoonChain[index];
  }

  int getNextNewMoon(int afterMs) {
    final kApprox = getApproximateK(afterMs);
    final center = kApprox.floor();

    int? best;

    for (var k = center - 1; k <= center + 4; k++) {
      final nm = getNewMoon(k.toDouble());

      if (nm > afterMs && (best == null || nm < best)) {
        best = nm;
      }
    }

    return best ?? getNewMoon(kApprox.toInt() + 1);
  }

  // ---------------------------------------------------------------------------
  // PURNIMA / KUNAMI
  // ---------------------------------------------------------------------------

  int getPurnimaDayNum(int startMs, int endMs, int fullMoonMs) {
    if (endMs <= startMs) return 1;

    final numDays = ((endMs - startMs) / msPerDay).round();

    if (numDays <= 0) return 1;

    final dayDuration = (endMs - startMs) / numDays;

    var dayNum = ((fullMoonMs - startMs) / dayDuration).floor() + 1;

    if (dayNum < 1) dayNum = 1;
    if (dayNum > numDays) dayNum = numDays;

    return dayNum;
  }

  DateTime getKunamiDate(int startMs, int endMs, int fullMoonMs) {
    final dayNum = getPurnimaDayNum(startMs, endMs, fullMoonMs);

    final numDays = ((endMs - startMs) / msPerDay).round();

    final dayDuration = (endMs - startMs) / numDays;

    final kunamiStart = startMs + ((dayNum - 1) * dayDuration).round();

    return DateTime.fromMillisecondsSinceEpoch(kunamiStart, isUtc: true);
  }

  // ---------------------------------------------------------------------------
  // MONTHS
  // ---------------------------------------------------------------------------

  List<SantaliMonth> getSantaliMonths(int year) {
    final totalMonths = isSantaliLeapYear(year) ? 13 : 12;

    final months = <SantaliMonth>[];

    var currentNewMoon = getMagStartMoon(year);

    for (var index = 0; index < totalMonths; index++) {
      final startMs = getChandradarshan(currentNewMoon);

      final nextNm = getNextNewMoon(currentNewMoon + 25 * msPerDay);

      final endMs = getChandradarshan(nextNm);

      final fullMoonMs = getFullMoonBetween(startMs, endMs);

      if (fullMoonMs == null) {
        currentNewMoon = nextNm;
        continue;
      }

      final totalDays = ((endMs - startMs) / msPerDay).round();

      final kunamiDay = getPurnimaDayNum(startMs, endMs, fullMoonMs);

      final dayDuration = (endMs - startMs) / totalDays;

      final kunamiStartMs = startMs + ((kunamiDay - 1) * dayDuration).round();

      final definition = santaliMonths[index];

      final startDate = DateTime.fromMillisecondsSinceEpoch(
        startMs,
        isUtc: true,
      );

      final endDate = DateTime.fromMillisecondsSinceEpoch(endMs, isUtc: true);

      final kunamiDate = DateTime.fromMillisecondsSinceEpoch(
        kunamiStartMs,
        isUtc: true,
      );

      months.add(
        SantaliMonth(
          id: definition.id,
          index: index,
          name: definition.name,
          roman: definition.roman,
          startDate: startDate,
          newMoonDate: startDate,
          fullMoonDate: kunamiDate,
          endDate: endDate,
          displayEndDate: endDate.subtract(const Duration(days: 1)),
          totalDays: totalDays,
          isLeapMonth: index == 12,
        ),
      );

      currentNewMoon = nextNm;
    }

    return months;
  }

  // ---------------------------------------------------------------------------
  // MONTH INDEX
  // ---------------------------------------------------------------------------

  int getMonthIndex(DateTime date) {
    final targetMs = date.toUtc().millisecondsSinceEpoch;

    final year = date.toLocal().year;

    var months = getSantaliMonths(year);

    for (final month in months) {
      final start = month.startDate.millisecondsSinceEpoch;
      final end = month.endDate.millisecondsSinceEpoch;

      if (targetMs >= start && targetMs < end) {
        return month.index;
      }
    }

    months = getSantaliMonths(year - 1);

    for (final month in months) {
      final start = month.startDate.millisecondsSinceEpoch;
      final end = month.endDate.millisecondsSinceEpoch;

      if (targetMs >= start && targetMs < end) {
        return month.index;
      }
    }

    months = getSantaliMonths(year + 1);

    for (final month in months) {
      final start = month.startDate.millisecondsSinceEpoch;
      final end = month.endDate.millisecondsSinceEpoch;

      if (targetMs >= start && targetMs < end) {
        return month.index;
      }
    }

    return 0;
  }

  // ---------------------------------------------------------------------------
  // SANTALI DAY BOUNDARIES
  // ---------------------------------------------------------------------------

  /// Returns 17:00 IST on the supplied Gregorian calendar date.
  ///
  /// This is used for calendar-cell month selection.
  DateTime getSantaliDayStart(DateTime date) {
    final target = date.toLocal();

    return DateTime.utc(
      target.year,
      target.month,
      target.day,
      santaliDayStartUtcHour,
      santaliDayStartUtcMinute,
    );
  }

  /// Returns the start of the Santali day that CONTAINS the given instant.
  ///
  /// Example:
  /// 11 Sep 2026 06:00 IST -> 10 Sep 2026 17:00 IST.
  /// 11 Sep 2026 18:00 IST -> 11 Sep 2026 17:00 IST.
  DateTime startOfSantaliDay(DateTime date) {
    final target = date.toUtc();

    final ist = target.add(Duration(milliseconds: istOffsetMs));

    var year = ist.year;
    var month = ist.month;
    var day = ist.day;

    if (ist.hour < 17) {
      final previous = DateTime.utc(
        year,
        month,
        day,
      ).subtract(const Duration(days: 1));

      year = previous.year;
      month = previous.month;
      day = previous.day;
    }

    return DateTime.utc(
      year,
      month,
      day,
      santaliDayStartUtcHour,
      santaliDayStartUtcMinute,
    );
  }

  /// Exclusive end boundary of the Santali day.
  DateTime endOfSantaliDay(DateTime date) {
    return startOfSantaliDay(date).add(const Duration(days: 1));
  }

  bool isSameSantaliDay(DateTime a, DateTime b) {
    return startOfSantaliDay(a) == startOfSantaliDay(b);
  }

  DateTime addSantaliDays(DateTime date, int days) {
    return date.toUtc().add(Duration(days: days));
  }

  // ---------------------------------------------------------------------------
  // CALENDAR MONTH INDEX
  // ---------------------------------------------------------------------------

  /// Gets the Santali month represented by a Gregorian calendar cell.
  ///
  /// Example:
  /// 11 Sep 2026 -> evaluates 11 Sep 17:00 IST,
  /// therefore returns Dasay rather than Bhador.
  int getCalendarMonthIndex(DateTime date) {
    final target = getSantaliDayStart(date);

    final targetMs = target.millisecondsSinceEpoch;

    final year = date.toLocal().year;

    var months = getSantaliMonths(year);

    for (final month in months) {
      if (targetMs >= month.startDate.millisecondsSinceEpoch &&
          targetMs < month.endDate.millisecondsSinceEpoch) {
        return month.index;
      }
    }

    months = getSantaliMonths(year - 1);

    for (final month in months) {
      if (targetMs >= month.startDate.millisecondsSinceEpoch &&
          targetMs < month.endDate.millisecondsSinceEpoch) {
        return month.index;
      }
    }

    months = getSantaliMonths(year + 1);

    for (final month in months) {
      if (targetMs >= month.startDate.millisecondsSinceEpoch &&
          targetMs < month.endDate.millisecondsSinceEpoch) {
        return month.index;
      }
    }

    return 0;
  }

  // ---------------------------------------------------------------------------
  // CURRENT MONTH
  // ---------------------------------------------------------------------------

  SantaliMonth getSantaliMonth([DateTime? date]) {
    final target = date ?? DateTime.now();
    final targetMs = target.toUtc().millisecondsSinceEpoch;

    final year = target.toLocal().year;

    var months = getSantaliMonths(year);

    for (final month in months) {
      if (targetMs >= month.startDate.millisecondsSinceEpoch &&
          targetMs < month.endDate.millisecondsSinceEpoch) {
        return month;
      }
    }

    months = getSantaliMonths(year - 1);

    for (final month in months) {
      if (targetMs >= month.startDate.millisecondsSinceEpoch &&
          targetMs < month.endDate.millisecondsSinceEpoch) {
        return month;
      }
    }

    months = getSantaliMonths(year + 1);

    for (final month in months) {
      if (targetMs >= month.startDate.millisecondsSinceEpoch &&
          targetMs < month.endDate.millisecondsSinceEpoch) {
        return month;
      }
    }

    throw StateError('Unable to determine Santali month for $target');
  }

  // ---------------------------------------------------------------------------
  // SANTALI DATE
  // ---------------------------------------------------------------------------

  SantaliDate getDate([DateTime? date]) {
    final target = date ?? DateTime.now();
    final targetMs = target.toUtc().millisecondsSinceEpoch;

    final gregorianYear = target.toLocal().year;

    SantaliMonth? month;

    var months = getSantaliMonths(gregorianYear);

    for (final m in months) {
      if (targetMs >= m.startDate.millisecondsSinceEpoch &&
          targetMs < m.endDate.millisecondsSinceEpoch) {
        month = m;
        break;
      }
    }

    if (month == null) {
      months = getSantaliMonths(gregorianYear - 1);

      for (final m in months) {
        if (targetMs >= m.startDate.millisecondsSinceEpoch &&
            targetMs < m.endDate.millisecondsSinceEpoch) {
          month = m;
          break;
        }
      }
    }

    if (month == null) {
      months = getSantaliMonths(gregorianYear + 1);

      for (final m in months) {
        if (targetMs >= m.startDate.millisecondsSinceEpoch &&
            targetMs < m.endDate.millisecondsSinceEpoch) {
          month = m;
          break;
        }
      }
    }

    if (month == null) {
      throw StateError('Unable to determine Santali date for $target');
    }

    final startMs = month.startDate.millisecondsSinceEpoch;
    final endMs = month.endDate.millisecondsSinceEpoch;

    final totalDays = ((endMs - startMs) / msPerDay).round();

    final dayDuration = (endMs - startMs) / totalDays;

    var day = ((targetMs - startMs) / dayDuration).floor() + 1;

    day = math.max(1, math.min(totalDays, day));

    final isPurnima = isSameSantaliDay(target, month.fullMoonDate);
    final isAmavasya = isSameSantaliDay(target, month.newMoonDate);

    return SantaliDate(
      day: day,
      date: target,
      year: target.year,
      month: month,
      isPurnima: isPurnima,
      isAmavasya: isAmavasya,
      monthIndex: month.index,
      weekDay: target.weekday,
      isLeapMonth: month.isLeapMonth,
    );
  }

  SantaliDate getToday() {
    return getDate(DateTime.now());
  }

  // ---------------------------------------------------------------------------
  // CALENDAR
  // ---------------------------------------------------------------------------

  List<SantaliMonth> getCalendarMonths(int year) {
    return getSantaliMonths(year);
  }

  // ---------------------------------------------------------------------------
  // ASTRONOMY / DEBUG
  // ---------------------------------------------------------------------------

  DateTime toISTDate(int ms) {
    return DateTime.fromMillisecondsSinceEpoch(ms + istOffsetMs, isUtc: true);
  }

  MonthAstronomy getMonthAstronomy(SantaliMonth month) {
    final startMs = month.startDate.millisecondsSinceEpoch;
    final endMs = month.endDate.millisecondsSinceEpoch;

    final fullMoonMs = getFullMoonBetween(startMs, endMs);

    return MonthAstronomy(
      index: month.index,
      startDate: month.startDate,
      endDate: month.endDate,
      totalDays: month.totalDays,
      fullMoonAstronomical: fullMoonMs == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(fullMoonMs, isUtc: true),
      fullMoonIST: fullMoonMs == null ? null : toISTDate(fullMoonMs),
      kunamiDate: month.fullMoonDate,
    );
  }

  List<DateTime> getNewMoonsForYear(int year) {
    final start = DateTime.utc(year, 1, 1).millisecondsSinceEpoch;
    final end = DateTime.utc(year + 1, 1, 1).millisecondsSinceEpoch;

    final kStart = getApproximateK(start).floor() - 2;
    final kEnd = getApproximateK(end).ceil() + 2;

    final result = <DateTime>[];

    for (var k = kStart; k <= kEnd; k++) {
      final nm = getNewMoon(k.toDouble());

      if (nm >= start && nm < end) {
        result.add(DateTime.fromMillisecondsSinceEpoch(nm, isUtc: true));
      }
    }

    result.sort((a, b) => a.compareTo(b));
    return result;
  }

  List<DateTime> getFullMoonsForYear(int year) {
    final start = DateTime.utc(year, 1, 1).millisecondsSinceEpoch;
    final end = DateTime.utc(year + 1, 1, 1).millisecondsSinceEpoch;

    final kStart = getApproximateK(start).floor() - 2;
    final kEnd = getApproximateK(end).ceil() + 2;

    final result = <DateTime>[];

    for (var k = kStart; k <= kEnd; k++) {
      final fm = getFullMoon(k.toDouble());

      if (fm >= start && fm < end) {
        result.add(DateTime.fromMillisecondsSinceEpoch(fm, isUtc: true));
      }
    }

    result.sort((a, b) => a.compareTo(b));
    return result;
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  bool isSameGregorianDate(DateTime a, DateTime b) {
    final x = a.toLocal();
    final y = b.toLocal();

    return x.year == y.year && x.month == y.month && x.day == y.day;
  }
}
