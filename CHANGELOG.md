## 2.0.0

### Astronomical Calendar Engine

- `SantaliCalendar` now uses `SantaliMoonCalendar` for accurate moon-phase-based month calculations
- Month start/end dates are determined by Chandradarshan (first visible crescent) instead of fixed 29/30-day arithmetic
- Added `isPurnima`, `isAmavasya`, `isLeapMonth` fields to `SantaliDate`
- Added `weekDay` field to `SantaliDate`
- Added `fullMoonDate`, `newMoonDate`, `isLeapMonth` fields to `SantaliMonth`

### Model Restructure

- Moved `SantaliMonth`, `SantaliDate`, `SantaliMonthDefinition` to `lib/src/models/`
- `astronomy/moon.dart` now contains only `SantaliMoonCalendar` and `MonthAstronomy`
- Removed `lib/src/constants/months.dart` (definitions now in models)

### Breaking Changes

- `SantaliMonth.english` renamed to `SantaliMonth.roman`
- `SantaliDate.gregorianDate` renamed to `SantaliDate.date`
- `SantaliDate.monthStartDate` / `SantaliDate.monthEndDate` now required
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
