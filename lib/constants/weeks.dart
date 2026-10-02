/// Weekday definitions for the Santali calendar.
///
/// Provides the [SantaliWeekDay] enum, Ol Chiki weekday names,
/// and a canonical ordered list of weekdays (Sunday-first).
library;

/// Days of the week in the Santali calendar.
///
/// Ordered Sunday-first, matching the calendar grid layout.
enum SantaliWeekDay {
  /// Sunday (ᱥᱤᱸᱜᱤ).
  sunday,

  /// Monday (ᱚᱛᱮ).
  monday,

  /// Tuesday (ᱵᱟᱞᱮ).
  tuesday,

  /// Wednesday (ᱥᱟᱹᱜᱩᱱ).
  wednesday,

  /// Thursday (ᱥᱟᱹᱨᱫᱤ).
  thursday,

  /// Friday (ᱡᱟᱹᱨᱩᱢ).
  friday,

  /// Saturday (ᱧᱩᱦᱩᱢ).
  saturday,
}

/// Ol Chiki names for each [SantaliWeekDay].
const santaliWeekDays = {
  SantaliWeekDay.sunday: 'ᱥᱤᱸᱜᱤ',
  SantaliWeekDay.monday: 'ᱚᱛᱮ',
  SantaliWeekDay.tuesday: 'ᱵᱟᱞᱮ',
  SantaliWeekDay.wednesday: 'ᱥᱟᱹᱜᱩᱱ',
  SantaliWeekDay.thursday: 'ᱥᱟᱹᱨᱫᱤ',
  SantaliWeekDay.friday: 'ᱡᱟᱹᱨᱩᱢ',
  SantaliWeekDay.saturday: 'ᱧᱩᱦᱩᱢ',
};

/// Canonical ordered list of weekdays (Sunday-first).
const List<SantaliWeekDay> weekDays = [
  SantaliWeekDay.sunday,
  SantaliWeekDay.monday,
  SantaliWeekDay.tuesday,
  SantaliWeekDay.wednesday,
  SantaliWeekDay.thursday,
  SantaliWeekDay.friday,
  SantaliWeekDay.saturday,
];
