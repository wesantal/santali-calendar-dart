# santali_calendar

A Dart package for the traditional Santali lunisolar calendar.

Maps the Santali calendar onto the Gregorian calendar using the 19-year Metonic cycle for leap year calculation.

**Repository:** [https://github.com/wesantal/santali-calendar-dart](https://github.com/wesantal/santali-calendar-dart)

## Installation

```yaml
dependencies:
  santali_calendar: ^1.0.1
```

```bash
dart pub add santali_calendar
```

## Usage

```dart
import 'package:santali_calendar/santali_calendar.dart';

final calendar = SantaliCalendar();

// Get today's Santali date
final today = calendar.today();
// SantaliDate: 15 ᱢᱟᱜᱽ 2026 (Mag, Gregorian: 2026-02-02)

// Convert any Gregorian date
final date = calendar.getDate(DateTime.utc(2026, 6, 15));

// Get full calendar year with grid
final year = calendar.getCalendar(2026);
print(year.currentMonthIndex); // index of today's month

// Get a single month with calendar grid
final magh = calendar.getMonth(2026, 0);
print(magh.name);          // "ᱢᱟᱜᱽ"
print(magh.calendar);      // Map<SantaliWeekDay, List<SantaliCalendarDay?>>

// Get month for any date
final month = calendar.getMonthByDate(DateTime.utc(2027, 8, 2));

// Get current month
final current = calendar.getCurrentMonth();

// Check leap year
isLeapYear(2026); // true (Metonic position 1)
isLeapYear(2027); // false

// Convert numbers to Ol Chiki script
toOlChikiNumeral(2026); // "᱒᱐᱒᱖"
```

## Calendar Structure

`getCalendar(year)` returns a `SantaliCalendarYear`:

```dart
final year = calendar.getCalendar(2026);

print(year.year);              // 2026
print(year.startDate);         // 2026-01-19 00:00:00.000Z
print(year.endDate);           // 2027-01-07 00:00:00.000Z
print(year.currentMonthIndex); // index of today's month (e.g. 0 for Mag)

for (final month in year.months) {
  print('${month.name} (${month.english}): ${month.days} days');
  print('  Start: ${month.startDate}');
  print('  End:   ${month.endDate}');

  // Access the calendar grid by weekday
  final sundays = month.calendar[SantaliWeekDay.sunday];
  for (final cell in sundays!) {
    if (cell != null) {
      print('  Sun ${cell.day}: ${cell.date} (today: ${cell.isToday})');
    }
  }
}
```

### SantaliCalendarMonth

Extends `SantaliMonth` with a calendar grid:

```dart
class SantaliCalendarMonth extends SantaliMonth {
  final Map<SantaliWeekDay, List<SantaliCalendarDay?>> calendar;
  // ... inherited: days, name, english, startDate, endDate
}
```

### SantaliCalendarDay

Each cell in the calendar grid:

```dart
class SantaliCalendarDay {
  final int day;             // day number (1-30)
  final DateTime date;       // Gregorian date
  final bool isToday;        // true if this is today
  final bool isCurrentMonth; // true if in the displayed month
}
```

### SantaliDate

`getDate(DateTime)` and `today()` return a `SantaliDate`:

```dart
final date = calendar.today();

date.year;           // 2026
date.monthIndex;     // 0 (0-based)
date.month;          // SantaliMonth instance
date.monthEnglish;   // "Mag"
date.day;            // 15
date.gregorianDate;  // 2026-02-02 00:00:00.000Z
date.monthStartDate; // 2026-01-19 00:00:00.000Z
date.monthEndDate;   // 2026-02-17 00:00:00.000Z
date.olChikiDay;     // "᱑᱕"
date.olChikiYear;    // "᱒᱐᱒᱖"
```

## Santali Months

| #   | Name    | Ol Chiki | Days |
| --- | ------- | -------- | ---- |
| 0   | Mag     | ᱢᱟᱜᱽ     | 30   |
| 1   | Phagun  | ᱯᱷᱟᱹᱜᱩᱱ  | 29   |
| 2   | Chat    | ᱪᱟᱹᱛ     | 30   |
| 3   | Baisak  | ᱵᱟᱹᱭᱥᱟᱹᱠ | 29   |
| 4   | Jhent   | ᱡᱷᱮᱸᱴ    | 30   |
| 5   | Ashar   | ᱟᱥᱟᱲ     | 29   |
| 6   | San     | ᱥᱟᱱ      | 30   |
| 7   | Bhador  | ᱵᱷᱟᱫᱚᱨ   | 29   |
| 8   | Dasain  | ᱫᱟᱥᱟᱸᱭ   | 30   |
| 9   | Soharay | ᱥᱚᱦᱚᱨᱟᱭ   | 29   |
| 10  | Aghan   | ᱟᱜᱷᱟᱬ    | 30   |
| 11  | Pus     | ᱯᱩᱥ      | 29   |

**Normal year:** 354 days (12 months). **Leap year:** 384 days (adds Sarcha, a 30-day intercalary month).

## Gregorian Date Mapping

A Santali month spans parts of two Gregorian months. Example:

- **ᱢᱟᱜᱽ (Mag) 2026:** January 19 – February 17

## API Reference

### SantaliCalendar

The main class. Instantiate with optional anchor date and year:

```dart
final calendar = SantaliCalendar();
// or with custom anchor
final calendar = SantaliCalendar(
  anchorDate: DateTime.utc(2026, 1, 19),
  anchorYear: 2026,
);
```

| Method | Return Type | Description |
| --- | --- | --- |
| `getCalendar(year)` | `SantaliCalendarYear` | Complete calendar year with grid months |
| `getMonth(year, monthIndex)` | `SantaliCalendarMonth` | Single month with calendar grid (0-11) |
| `getMonthByDate(date)` | `SantaliCalendarMonth` | Calendar month for any Gregorian date |
| `getCurrentMonth()` | `SantaliCalendarMonth` | Current month with calendar grid |
| `getDate(date)` | `SantaliDate` | Convert a Gregorian date to Santali |
| `today()` | `SantaliDate` | Today's Santali date |
| `yearStart(year)` | `DateTime` | Gregorian start date of a Santali year |
| `yearLength(year)` | `int` | Total days in a Santali year (354 or 384) |
| `buildMonths(year)` | `List<SantaliMonth>` | Base month objects for a year |
| `buildCalendarMonth(month, today)` | `SantaliCalendarMonth` | Build calendar grid for a month |

### Utility Functions

| Function | Signature | Description |
| --- | --- | --- |
| `isLeapYear(year)` | `bool isLeapYear(int year)` | Check if year has 13 months (Metonic cycle) |
| `toOlChikiNumeral(n)` | `String toOlChikiNumeral(int number)` | Convert number to Ol Chiki script |

### Constants

| Name | Type | Description |
| --- | --- | --- |
| `santaliMonths` | `List<SantaliMonth>` | 12 base month definitions |
| `sarchaMonth` | `SantaliMonth` | 13th intercalary month (leap years only) |
| `santaliWeekDays` | `Map<SantaliWeekDay, String>` | Weekday names in Ol Chiki script |
| `metonicCycleStart` | `int` | Metonic cycle anchor year (2026) |
| `metonicLeapPositions` | `Set<int>` | Leap positions within the 19-year cycle |

## Types

Full type support:

```dart
import 'package:santali_calendar/santali_calendar.dart';

SantaliCalendar       // Main calendar class
SantaliCalendarYear   // Full year with months list and currentMonthIndex
SantaliCalendarMonth  // Month with calendar grid (extends SantaliMonth)
SantaliCalendarDay    // Day cell: day, date, isToday, isCurrentMonth
SantaliMonth          // Base month: name, english, days, startDate, endDate
SantaliDate           // Converted date with Ol Chiki getters
SantaliWeekDay        // Enum: sunday through saturday
```

## License

MIT
