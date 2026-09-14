# santali_calendar

A Dart package for the traditional Santali lunisolar calendar.

Uses astronomical moon phase calculations (Chandradarshan) to determine accurate month boundaries based on the 19-year Metonic cycle.

**Repository:** [https://github.com/wesantal/santali-calendar-dart](https://github.com/wesantal/santali-calendar-dart)

## Installation

```yaml
dependencies:
  santali_calendar: ^2.0.0
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
print(today);            // 3 ᱫᱟᱥᱟᱸᱭ 2026 (Dasany, Gregorian: 2026-09-14)
print(today.weekDay);    // SantaliWeekDay.monday
print(today.isPurnima);  // false
print(today.isAmavasya); // false

// Convert any Gregorian date
final date = calendar.getDate(DateTime.utc(2026, 6, 15));

// Get full calendar year
final year = calendar.getCalendar(2026);
print(year.startDate);         // 2026-01-19 11:30:00.000Z
print(year.currentMonthIndex); // index of today's month

// Get a single month
final magh = calendar.getMonth(2026, 0);
print(magh.name);     // "ᱢᱟᱜᱽ"
print(magh.roman);    // "Mag"
print(magh.totalDays); // 30

// Get month for any date
final month = calendar.getMonthByDate(DateTime.now());

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
print(year.startDate);         // start of Magh
print(year.endDate);           // end of Pus
print(year.currentMonthIndex); // index of today's month

for (final month in year.months) {
  print('${month.name} (${month.roman}): ${month.totalDays} days');
  print('  Start: ${month.startDate}');
  print('  End:   ${month.endDate}');
  print('  Full Moon: ${month.fullMoonDate}');
  print('  New Moon:  ${month.newMoonDate}');

  for (final cell in month.days) {
    if (cell != null && cell.isCurrentMonth) {
      print('  ${cell.weekDay} ${cell.day}: ${cell.date}');
    }
  }
}
```

### SantaliMonth

Base month model with astronomical data:

```dart
class SantaliMonth {
  final int index;           // 0-12
  final String name;         // Ol Chiki name
  final String roman;        // English name
  final DateTime startDate;  // Gregorian start (Chandradarshan)
  final DateTime endDate;    // Gregorian end
  final DateTime newMoonDate;  // Amavasya date
  final DateTime fullMoonDate; // Purnima date
  final int totalDays;       // days in month
  final bool isLeapMonth;    // true for Sarcha
  final DateTime displayEndDate;
}
```

### SantaliDate

Returned by `getDate()` and `today()`:

```dart
final date = calendar.today();

date.day;            // 3
date.year;           // 2026
date.monthIndex;     // 8 (0-based)
date.month;          // SantaliMonth instance
date.monthEnglish;   // "Dasany"
date.weekDay;        // SantaliWeekDay.monday
date.date;           // 2026-09-14 00:00:00.000Z
date.monthStartDate; // 2026-09-11 11:30:00.000Z
date.monthEndDate;   // 2026-10-11 11:30:00.000Z
date.isPurnima;      // false
date.isAmavasya;     // false
date.isLeapMonth;    // false
date.olChikiDay;     // "᱓"
date.olChikiYear;    // "᱒᱐᱒᱖"
```

### SantaliCalendarMonth

Calendar grid month (extends `SantaliMonth`):

```dart
class SantaliCalendarMonth extends SantaliMonth {
  final List<SantaliCalendarDay?> days; // flat list of all cells (7 × rows)
}
```

### SantaliCalendarDay

Each cell in the calendar grid:

```dart
class SantaliCalendarDay {
  final int day;             // day number (1-30)
  final DateTime date;       // Gregorian date
  final SantaliWeekDay weekDay;
  final bool isToday;
  final bool isCurrentMonth;
  final bool isPurnima;
  final bool isAmavasya;
}
```

## Santali Months

| #   | Name    | Ol Chiki | Days |
| --- | ------- | -------- | ---- |
| 0   | Mag     | ᱢᱟᱜᱽ     | 29-30 |
| 1   | Phagun  | ᱯᱷᱟᱹᱜᱩᱱ  | 29-30 |
| 2   | Chat    | ᱪᱟᱹᱛ     | 29-30 |
| 3   | Baisak  | ᱵᱟᱹᱭᱥᱟᱹᱠ | 29-30 |
| 4   | Jhent   | ᱡᱷᱮᱸᱴ    | 29-30 |
| 5   | Ashar   | ᱟᱥᱟᱲ     | 29-30 |
| 6   | San     | ᱥᱟᱱ      | 29-30 |
| 7   | Bhador  | ᱵᱷᱟᱫᱚᱨ   | 29-30 |
| 8   | Dasain  | ᱫᱟᱥᱟᱸᱭ   | 29-30 |
| 9   | Soharay | ᱥᱚᱦᱚᱨᱟᱭ  | 29-30 |
| 10  | Aghan   | ᱟᱜᱷᱟᱬ    | 29-30 |
| 11  | Pus     | ᱯᱩᱥ      | 29-30 |
| 12  | Sarcha  | ᱥᱚᱨᱪᱟ    | 30 (leap years only) |

Month lengths vary based on astronomical calculations (29-30 days depending on moon phases).

**Normal year:** 354 days (12 months). **Leap year:** 384 days (adds Sarcha, a 30-day intercalary month).

## API Reference

### SantaliCalendar

| Method                             | Return Type            | Description                               |
| ---------------------------------- | ---------------------- | ----------------------------------------- |
| `getCalendar(year)`                | `SantaliCalendarYear`  | Complete calendar year with grid months   |
| `getMonth(year, monthIndex)`       | `SantaliCalendarMonth` | Single month with calendar grid (0-12)    |
| `getMonthByDate(date)`             | `SantaliCalendarMonth` | Calendar month for any Gregorian date     |
| `getCurrentMonth()`                | `SantaliCalendarMonth` | Current month with calendar grid          |
| `getDate(date)`                    | `SantaliDate`          | Convert a Gregorian date to Santali       |
| `today()`                          | `SantaliDate`          | Today's Santali date                      |
| `yearStart(year)`                  | `DateTime`             | Gregorian start date of a Santali year    |
| `yearLength(year)`                 | `int`                  | Total days in a Santali year (354 or 384) |
| `buildMonths(year)`                | `List<SantaliMonth>`   | Astronomical month objects for a year     |
| `buildCalendarMonth(month, today)` | `SantaliCalendarMonth` | Build calendar grid for a month           |

### Utility Functions

| Function              | Signature                             | Description                                 |
| --------------------- | ------------------------------------- | ------------------------------------------- |
| `isLeapYear(year)`    | `bool isLeapYear(int year)`           | Check if year has 13 months (Metonic cycle) |
| `toOlChikiNumeral(n)` | `String toOlChikiNumeral(int number)` | Convert number to Ol Chiki script           |

## Types

```dart
SantaliCalendar       // Main calendar class
SantaliCalendarYear   // Full year with months list and currentMonthIndex
SantaliCalendarMonth  // Month with days list (extends SantaliMonth)
SantaliCalendarDay    // Day cell: day, date, weekDay, isToday, isCurrentMonth, isPurnima, isAmavasya
SantaliMonth          // Astronomical month: name, roman, startDate, endDate, fullMoonDate, newMoonDate
SantaliDate           // Converted date: day, year, weekDay, isPurnima, isAmavasya, olChiki getters
SantaliWeekDay        // Enum: sunday through saturday
SantaliMoonCalendar   // Astronomical calculation engine
```

## License

MIT
