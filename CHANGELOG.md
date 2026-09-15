## 2.0.3

### Bug Fixes

- Fixed previous month date issue

## 2.0.2

### Bug Fixes

- Fixed `SantaliCalendarDay.weekDay` labels shifted one day back (`weekDays[date.weekday - 1]` → `weekDays[date.weekday % 7]`, matching the Sunday-first `weekDays` order)

## 2.0.1

### Documentation

- Added dartdoc comments to the full `SantaliCalendar` public API
- Added runnable `example/santali_calendar_example.dart`

## 2.0.0

### Astronomical Calendar Engine

- `SantaliCalendar` now uses `SantaliMoonCalendar` for accurate moon-phase-based month calculations
- Month start/end dates are determined by Chandradarshan (first visible crescent) instead of fixed 29/30-day arithmetic
- Santali days start at 17:00 IST (11:30 UTC)
- `getDate()` uses raw timestamps with proportional day division (`floor((targetMs - startMs) / dayDuration) + 1`), matching the reference implementation
- Added `isPurnima`, `isAmavasya`, `isLeapMonth` fields to `SantaliDate`
- Added `weekDay` field to `SantaliDate` (int, `DateTime.weekday`: Monday = 1 ... Sunday = 7)
- Added `fullMoonDate`, `newMoonDate`, `isLeapMonth` fields to `SantaliMonth`
- Month results are cached per year (`buildMonths`)

### Month Identity

- Added `SantaliMonthId` enum (`mag`, `fagun`, `chaat`, `baisak`, `jhent`, `ashal`, `saan`, `bhador`, `dasany`, `sohray`, `aghan`, `push`, `sarcha`)
- Added required `id` field to `SantaliMonth`, `SantaliMonthDefinition`, and `SantaliCalendarMonth`

### Festivals

- Added festival system in `lib/src/festivals/` (`types.dart`, `data.dart`, `festivals.dart`)
- Added `SantaliFestivalRule` (sealed), `FixedGregorianFestivalRule`, `MoonRelativeFestivalRule`, `MoonPhase`, `SantaliFestivalType`, `SantaliFestivalDefinition`, `SantaliFestival`
- Added `SantaliCalendar.getFestivals(year)` resolving 18 festivals (moon-relative and fixed Gregorian), sorted by date

### New SantaliCalendar Methods

- `getCalendarToday()` — Santali date of today's calendar-grid cell (evaluates the day starting 17:00 IST on today's Gregorian date)
- `isLeapYear(year)` — Metonic-cycle leap year check
- `getDaysInMonth(year, monthIndex)` — days in a Santali month
- `getMonthIndex(date)` — Santali month index for a Gregorian instant
- `getCalendarMonthIndex(date)` — Santali month index for a Gregorian calendar cell
- `getMonthFromDate(date)` — calendar month for any Gregorian date

### Model Restructure

- Moved `SantaliMonth`, `SantaliDate`, `SantaliMonthDefinition` to `lib/src/models/`
- `astronomy/moon.dart` now contains only `SantaliMoonCalendar` and `MonthAstronomy`
- Removed `lib/src/constants/months.dart` (definitions now in models)

### Breaking Changes

- `SantaliMonth.english` renamed to `SantaliMonth.roman`
- `SantaliDate.gregorianDate` renamed to `SantaliDate.date` (now the raw UTC timestamp of the queried instant)
- `SantaliMonth` now requires `id` (`SantaliMonthId`)
- `SantaliDate.monthEnglish` / `monthStartDate` / `monthEndDate` removed — use `date.month.roman`, `date.month.startDate`, `date.month.endDate`
- `SantaliDate.weekDay` is `int` (`DateTime.weekday`), not `SantaliWeekDay`
- `SantaliCalendar` constructor takes no arguments (`anchorDate` fixed, `anchorYear` removed)
- `SantaliCalendarMonth` extends astronomy `SantaliMonth` with all its fields

## 1.0.4

- Added `weekDay as SantaliWeekDay` field to `SantaliCalendarDay` for direct weekday access

## 1.0.3

- Simplified `SantaliCalendarMonth` to a standalone class (no longer extends `SantaliMonth`)
- Replaced `Map<SantaliWeekDay, List<SantaliCalendarDay?>> calendar` with flat `List<SantaliCalendarDay?> days`
- Added `weekDay` field to `SantaliCalendarDay` for direct weekday access
- Added `weekDays` list constant for ordered weekday access
- Removed empty `build_calendar_month.dart` utility file

### Breaking Changes

- `SantaliCalendarMonth` no longer extends `SantaliMonth` — use `.name`, `.english`, `.startDate`, `.endDate` directly
- `SantaliCalendarMonth.calendar` map removed — iterate `.days` list instead and use `cell.weekDay` for weekday info

## 1.0.2

- Fixed calendar grid rendering issue

## 1.0.1

- Added `SantaliCalendarMonth` model with calendar grid for UI rendering
- Added `SantaliCalendarDay` model with `day`, `date`, `isToday`, `isCurrentMonth`
- Added `getMonthByDate()` to get calendar month for any Gregorian date
- Added `getCurrentMonth()` to get current month with calendar grid
- Added `buildCalendarMonth()` to build calendar grid for a month
- Added `currentMonthIndex` field to `SantaliCalendarYear`

### Breaking Changes

- `getMonth()` now returns `SantaliCalendarMonth` instead of `SantaliMonth`
- `SantaliCalendarYear.months` is now `List<SantaliCalendarMonth>` instead of `List<SantaliMonth>`
- `SantaliCalendarYear` requires new `currentMonthIndex` field

## 1.0.0

- Initial version.
