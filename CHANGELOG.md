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
