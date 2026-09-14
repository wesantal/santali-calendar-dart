# santali_calendar

A Dart package for the traditional Santali lunisolar calendar.

Uses astronomical moon phase calculations (Chandradarshan) to determine accurate month boundaries based on the 19-year Metonic cycle.

Santali days start at 17:00 IST (11:30 UTC). Day numbers use proportional division within the month, matching the reference implementation.

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
import 'package:santali_calendar/src/utils/olchiki_number.dart';

final calendar = SantaliCalendar();

// Get today's Santali date (exact instant)
final today = calendar.today();
print(today);            // 3 ᱫᱟᱥᱟᱸᱭ 2026 (Dasany, Gregorian: 2026-09-14)
print(today.weekDay);    // 1 (DateTime.weekday: Monday = 1 ... Sunday = 7)
print(today.isPurnima);  // false
print(today.isAmavasya); // false

// Santali date for the calendar grid cell of today
// (evaluates the day starting 17:00 IST on today's Gregorian date)
final gridToday = calendar.getCalendarToday();

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

// Check leap year (method)
calendar.isLeapYear(2026); // true (Metonic position 1)
calendar.isLeapYear(2027); // false

// Days in a Santali month
calendar.getDaysInMonth(2026, 0); // 30

// Festivals for a year
final festivals = calendar.getFestivals(2026);
for (final f in festivals) {
  print('${f.roman}: ${f.date} (${f.type.name})');
}

// Convert numbers to Ol Chiki script
toOlChikiNumeral(2026); // "᱒᱐᱒᱖"
```

## Calendar Structure

`getCalendar(year)` returns a `SantaliCalendarYear`:

```dart
final year = calendar.getCalendar(2026);

print(year.year);              // 2026
print(year.startDate);         // start of Mag
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
  final SantaliMonthId id;       // mag, fagun, ..., sarcha
  final int index;               // 0-12
  final String name;             // Ol Chiki name
  final String roman;            // English name
  final DateTime startDate;      // Gregorian start (Chandradarshan, 11:30 UTC)
  final DateTime endDate;        // Gregorian end (next Chandradarshan)
  final DateTime newMoonDate;    // Amavasya date
  final DateTime fullMoonDate;   // Purnima (Kunami) date
  final int totalDays;           // days in month
  final bool isLeapMonth;        // true for Sarcha
  final DateTime displayEndDate; // endDate minus one day
}
```

### SantaliDate

Returned by `getDate()`, `today()` and `getCalendarToday()`:

```dart
final date = calendar.today();

date.day;          // 3
date.year;         // 2026
date.monthIndex;   // 8 (0-based)
date.month;        // SantaliMonth instance
date.month.roman;  // "Dasany"
date.month.id;     // SantaliMonthId.dasany
date.weekDay;      // 1 (DateTime.weekday: Monday = 1 ... Sunday = 7)
date.date;         // raw UTC timestamp of the queried instant
date.isPurnima;    // false
date.isAmavasya;   // false
date.isLeapMonth;  // false
date.olChikiDay;   // "᱓"
date.olChikiYear;  // "᱒᱐᱒᱖"
```

Month boundaries are available via `date.month.startDate` / `date.month.endDate`.

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

### Festivals

`getFestivals(year)` returns `SantaliFestival` objects resolved from
`SantaliFestivalDefinition` rules (fixed Gregorian date or moon-relative):

```dart
class SantaliFestival {
  final String id;
  final String name;       // Ol Chiki name
  final String roman;      // English name
  final SantaliMonthId monthId;
  final SantaliFestivalType type; // festival, birthAnniversary,
                                  // deathAnniversary, cultural,
                                  // community, observance
  final DateTime date;
  final String? description;
}
```

## Santali Months

| #   | Id       | Name          | Ol Chiki      | Days               |
| --- | -------- | ------------- | ------------- | ------------------ |
| 0   | mag      | Mag           | ᱢᱟᱜᱽ          | 29-30              |
| 1   | fagun    | Fagun         | ᱯᱷᱟᱹᱜᱩᱱ       | 29-30              |
| 2   | chaat    | Chaat         | ᱪᱟᱹᱛ          | 29-30              |
| 3   | baisak   | Baisak        | ᱵᱟᱹᱭᱥᱟᱹᱠ      | 29-30              |
| 4   | jhent    | Jhent         | ᱡᱷᱮᱸᱴ         | 29-30              |
| 5   | ashal    | Ashal         | ᱟᱥᱟᱲ          | 29-30              |
| 6   | saan     | Saan          | ᱥᱟᱱ           | 29-30              |
| 7   | bhador   | Bhador        | ᱵᱷᱟᱫᱚᱨ        | 29-30              |
| 8   | dasany   | Dasany        | ᱫᱟᱥᱟᱸᱭ        | 29-30              |
| 9   | sohray   | Sohray        | ᱥᱚᱦᱨᱟᱭ        | 29-30              |
| 10  | aghan    | Aaghan        | ᱟᱜᱷᱟᱬ         | 29-30              |
| 11  | push     | Pus           | ᱯᱩᱥ           | 29-30              |
| 12  | sarcha   | Sarcha Chando | ᱥᱟᱨᱪᱟ ᱪᱟᱸᱫᱳ | 30 (leap years only) |

Month lengths vary based on astronomical calculations (29-30 days depending on moon phases).

**Normal year:** 354 days (12 months). **Leap year:** 384 days (adds Sarcha, a 30-day intercalary month).

## API Reference

### SantaliCalendar

| Method                             | Return Type            | Description                                              |
| ---------------------------------- | ---------------------- | -------------------------------------------------------- |
| `getCalendar(year)`                | `SantaliCalendarYear`  | Complete calendar year with grid months                  |
| `getMonth(year, monthIndex)`       | `SantaliCalendarMonth` | Single month with calendar grid (0-12)                   |
| `getMonthByDate(date)`             | `SantaliCalendarMonth` | Calendar month for any Gregorian date                    |
| `getMonthFromDate(date)`           | `SantaliCalendarMonth` | Calendar month for any Gregorian date                    |
| `getCurrentMonth()`                | `SantaliCalendarMonth` | Current month with calendar grid                         |
| `getDate(date)`                    | `SantaliDate`          | Convert a Gregorian date to Santali (exact instant)      |
| `today()`                          | `SantaliDate`          | Today's Santali date (exact instant)                     |
| `getCalendarToday()`               | `SantaliDate`          | Santali date of today's calendar-grid cell (17:00 IST)   |
| `getMonthIndex(date)`              | `int`                  | Santali month index for a Gregorian instant              |
| `getCalendarMonthIndex(date)`      | `int`                  | Santali month index for a Gregorian calendar cell        |
| `getDaysInMonth(year, monthIndex)` | `int`                  | Days in a Santali month                                  |
| `isLeapYear(year)`                 | `bool`                 | Check if year has 13 months (Metonic cycle)              |
| `getFestivals(year)`               | `List<SantaliFestival>`| Festivals resolved for a year, sorted by date            |
| `yearStart(year)`                  | `DateTime`             | Gregorian start date of a Santali year                   |
| `yearLength(year)`                 | `int`                  | Total days in a Santali year (354 or 384)                |
| `buildMonths(year)`                | `List<SantaliMonth>`   | Astronomical month objects for a year (cached)           |
| `buildCalendarMonth(month, today)` | `SantaliCalendarMonth` | Build calendar grid for a month                          |

### Utility Functions

| Function              | Signature                             | Description                                 |
| --------------------- | ------------------------------------- | ------------------------------------------- |
| `isLeapYear(year)`    | `bool isLeapYear(int year)`           | Check if year has 13 months (Metonic cycle). Import from `src/utils/leap_year.dart` |
| `toOlChikiNumeral(n)` | `String toOlChikiNumeral(int number)` | Convert number to Ol Chiki script. Import from `src/utils/olchiki_number.dart` |

## Types

```dart
SantaliCalendar       // Main calendar class
SantaliCalendarYear   // Full year with months list and currentMonthIndex
SantaliCalendarMonth  // Month with days list (extends SantaliMonth)
SantaliCalendarDay    // Day cell: day, date, weekDay, isToday, isCurrentMonth, isPurnima, isAmavasya
SantaliMonth          // Astronomical month: id, name, roman, startDate, endDate, fullMoonDate, newMoonDate
SantaliMonthId        // Enum: mag, fagun, chaat, baisak, jhent, ashal, saan, bhador, dasany, sohray, aghan, push, sarcha
SantaliDate           // Converted date: day, year, weekDay (int), isPurnima, isAmavasya, olChiki getters
SantaliWeekDay        // Enum: sunday through saturday
SantaliFestival       // Resolved festival: id, name, roman, monthId, type, date
SantaliFestivalDefinition // Festival rule definition (fixed Gregorian or moon-relative)
SantaliFestivalType   // Enum: festival, birthAnniversary, deathAnniversary, cultural, community, observance
SantaliMoonCalendar   // Astronomical calculation engine
```

## License

MIT
