# @wesantal/santali-calendar

A framework-independent Santali Calendar data and utility package for JavaScript and TypeScript applications.

Maps the traditional Santali lunisolar calendar onto the Gregorian calendar using the 19-year Metonic cycle for leap year calculation.

**Documentation:** [https://calendar.wesantal.org/docs](https://calendar.wesantal.org/docs) | **Calculation Guide:** [https://calendar.wesantal.org/docs/calculation-guide](https://calendar.wesantal.org/docs/calculation-guide)

## Installation

```bash
npm install @wesantal/santali-calendar
# or
bun add @wesantal/santali-calendar
```

## Usage

```typescript
import {
  getCalendar,
  getToday,
  getDate,
  getMonth,
  isLeapYear,
  weekDays,
  festivals,
  months,
  formatDate,
  formatDateShort,
  toOlChikiNumeral,
} from "@wesantal/santali-calendar";

// Get today's Santali date
const today = getToday();
// { day: 15, year: 2026, month: "ᱢᱟᱜᱽ", monthIndex: 0, startDate: "...", endDate: "..." }

// Convert any Gregorian date
const date = getDate(new Date("2026-06-15"));

// Get full calendar grid for a year
const calendar = getCalendar(2026);

// Check leap year
isLeapYear(2026); // true (Metonic position 1)
isLeapYear(2027); // false

// Get a single month
const magh = getMonth(2026, 0);

// Convert numbers to Ol Chiki script
toOlChikiNumeral(2026); // "᱒᱐᱒᱖"

// Format dates
formatDate("2026-01-19T00:00:00.000Z"); // "19 January 2026"
formatDateShort("2026-01-19T00:00:00.000Z"); // "19 Jan 2026"
```

## Calendar Structure

`getCalendar(year)` returns a `BuiltSantaliCalendarYear`:

```typescript
{
  year: 2026,
  startDate: "2026-01-19T00:00:00.000Z",
  endDate: "2027-01-07T00:00:00.000Z",
  months: [
    {
      name: "ᱢᱟᱜᱽ",
      days: 30,
      startDate: "2026-01-19T00:00:00.000Z",
      endDate: "2026-02-17T00:00:00.000Z",
      calendar: {
        sun: [null, { day: 7, date: "...", isCurrentMonth: true }, ...],
        mon: [{ day: 1, date: "...", isCurrentMonth: true }, ...],
        // ... all 7 weekdays
      }
    },
    // ... 12 or 13 months
  ]
}
```

### Calendar Grid

Each weekday column (`sun`, `mon`, `tue`, `wed`, `thu`, `fri`, `sat`) contains cells that are either:

- A `SantaliCalendarDay` object:
  ```typescript
  { day: 1, date: "2026-01-19T00:00:00.000Z", isCurrentMonth: true }
  ```
- `null` for empty padding cells

## Santali Months

| #   | Name    | Ol Chiki | Days |
| --- | ------- | -------- | ---- |
| 0   | Mag     | ᱢᱟᱜᱽ     | 30   |
| 1   | Phagun  | ᱯᱷᱟ.ᱜᱩᱱ  | 29   |
| 2   | Chaat   | ᱪᱟ.ᱛ     | 30   |
| 3   | Baisak  | ᱵᱟ.ᱭᱥᱟ.ᱠ | 29   |
| 4   | Jhent   | ᱡᱷᱮᱸᱴ    | 30   |
| 5   | Asal    | ᱟᱥᱟᱲ     | 29   |
| 6   | Saan    | ᱥᱟᱱ      | 30   |
| 7   | Bhador  | ᱵᱷᱟᱫᱚᱨ   | 29   |
| 8   | Dasain  | ᱫᱟᱥᱟᱸᱭ   | 30   |
| 9   | Saharay | ᱥᱚᱦᱨᱟᱭ   | 29   |
| 10  | Aghan   | ᱟᱜᱷᱟᱬ    | 30   |
| 11  | Pus     | ᱯᱩᱥ      | 29   |

**Normal year:** 354 days (12 months). **Leap year:** 384 days (adds Sarcha, a 30-day intercalary month).

## Gregorian Date Mapping

A Santali month spans parts of two Gregorian months. Example:

- **ᱢᱟᱜᱽ (Mag) 2026:** January 19 – February 17

```
ᱢᱟᱜᱽ (Mag)
sun  null  7* 14* 21* 28*
mon   1*  8* 15* 22* 29*
tue   2*  9* 16* 23* 30*
wed   3* 10* 17* 24*  1
thu   4* 11* 18* 25*  2
fri   5* 12* 19* 26*  3
sat   6* 13* 20* 27*  4

* = current month day
numbers without * = next month overflow
null = empty cell
```

## API Reference

| Function                     | Description                               |
| ---------------------------- | ----------------------------------------- |
| `getCalendar(year)`          | Full calendar grid for a Santali year     |
| `getMonth(year, monthIndex)` | Single month with calendar grid           |
| `getToday()`                 | Today's Santali date                      |
| `getDate(date)`              | Convert a Gregorian date to Santali       |
| `isLeapYear(year)`           | Check if year has 13 months               |
| `buildYearStart(year)`       | Gregorian start date for a Santali year   |
| `formatDate(iso)`            | Long format date (e.g. "19 January 2026") |
| `formatDateShort(iso)`       | Short format date (e.g. "19 Jan 2026")    |
| `toOlChikiNumeral(n)`        | Convert number to Ol Chiki script         |

### Constants

| Export                | Description                            |
| --------------------- | -------------------------------------- |
| `months`              | Array of 12 base month definitions     |
| `festivals`           | Array of 11 festivals with metadata    |
| `weekDays`            | Weekday names in Ol Chiki script       |
| `METONIC_CYCLE_START` | Metonic cycle anchor year (2026)       |
| `METONIC_LEAP_POS`    | Set of leap positions within the cycle |

## Festivals

```typescript
import { festivals } from "@wesantal/santali-calendar";

festivals.forEach((f) => {
  console.log(`${f.name}: ${f.date ?? "Date varies"}`);
});
```

Each festival includes `id`, `name`, `date`, `santaliMonth`, `description`, and `type` (`"festival"`, `"cultural"`, or `"community"`).

## TypeScript

Full type support:

```typescript
import type {
  WeekDay,
  SantaliMonth,
  SantaliCalendarYear,
  SantaliCalendar,
  SantaliCalendarDay,
  SantaliCalendarDayCell,
  SantaliCalendarMonth,
  BuiltSantaliCalendarYear,
  SantaliMonthInfo,
  SantaliFestival,
  TodaySantaliDate,
} from "@wesantal/santali-calendar";
```

## License

MIT
