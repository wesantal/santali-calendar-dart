/// Santali month models and definitions.
///
/// Contains [SantaliMonth] (astronomical month data), [SantaliMonthId]
/// (month identity enum), and [SantaliMonthDefinition] (static month
/// metadata).
library;

/// Identity of a Santali month.
///
/// There are 13 values: 12 regular months plus [sarcha] (the
/// intercalary leap month, only present in leap years).
enum SantaliMonthId {
  /// Mag (ᱢᱟᱜᱽ) — first month.
  mag,

  /// Fagun (ᱯᱷᱟᱹᱜᱩᱱ).
  fagun,

  /// Chaat (ᱪᱟᱹᱛ).
  chaat,

  /// Baisak (ᱵᱟᱹᱭᱥᱟᱹᱠ).
  baisak,

  /// Jhent (ᱡᱷᱮᱸᱴ).
  jhent,

  /// Ashal (ᱟᱥᱟᱲ).
  ashal,

  /// Saan (ᱥᱟᱱ).
  saan,

  /// Bhador (ᱵᱷᱟᱫᱚᱨ).
  bhador,

  /// Dasany (ᱫᱟᱥᱟᱸᱭ).
  dasany,

  /// Sohray (ᱥᱚᱦᱨᱟᱭ).
  sohray,

  /// Aaghan (ᱟᱜᱷᱟᱬ).
  aghan,

  /// Pus (ᱯᱩᱥ).
  push,

  /// Sarcha Chando (ᱥᱟᱨᱪᱟ ᱪᱟᱸᱫᱳ) — leap month.
  sarcha,
}

/// Astronomical month data for a Santali month.
///
/// Contains Gregorian date boundaries computed by the astronomical
/// engine ([SantaliMoonCalendar]), moon-phase dates, and the
/// month's identity and length.
class SantaliMonth {
  /// Month identity.
  final SantaliMonthId id;

  /// 0-based index within the year (0 = Mag ... 12 = Sarcha).
  final int index;

  /// Ol Chiki display name.
  final String name;

  /// Roman-script display name.
  final String roman;

  /// Gregorian start date (Chandradarshan at 11:30 UTC).
  final DateTime startDate;

  /// Gregorian new-moon (Amavasya) date.
  final DateTime newMoonDate;

  /// Gregorian full-moon (Purnima / Kunami) date.
  final DateTime fullMoonDate;

  /// Gregorian end date (next Chandradarshan at 11:30 UTC).
  final DateTime endDate;

  /// Number of days in the month (29 or 30, or 30 for Sarcha).
  final int totalDays;

  /// Whether this is the leap month Sarcha.
  final bool isLeapMonth;

  /// Display end date (endDate minus one day).
  final DateTime displayEndDate;

  /// Creates an astronomical month.
  const SantaliMonth({
    required this.id,
    required this.index,
    required this.name,
    required this.roman,
    required this.startDate,
    required this.newMoonDate,
    required this.fullMoonDate,
    required this.endDate,
    required this.displayEndDate,
    required this.totalDays,
    required this.isLeapMonth,
  });
}

/// Default month definitions.
///
/// Sarcha Chando is inserted after Pus in leap years.
class SantaliMonthDefinition {
  /// Month identity.
  final SantaliMonthId id;

  /// Ol Chiki display name.
  final String name;

  /// Roman-script display name.
  final String roman;

  /// Whether this is the leap month Sarcha.
  final bool isLeapMonth;

  /// Creates a month definition.
  const SantaliMonthDefinition(
    this.id,
    this.name,
    this.roman, {
    this.isLeapMonth = false,
  });
}

/// Static definitions for all 13 Santali months.
const List<SantaliMonthDefinition> santaliMonths = [
  SantaliMonthDefinition(SantaliMonthId.mag, 'ᱢᱟᱜᱽ', 'Mag'),
  SantaliMonthDefinition(SantaliMonthId.fagun, 'ᱯᱷᱟᱹᱜᱩᱱ', 'Fagun'),
  SantaliMonthDefinition(SantaliMonthId.chaat, 'ᱪᱟᱹᱛ', 'Chaat'),
  SantaliMonthDefinition(SantaliMonthId.baisak, 'ᱵᱟᱹᱭᱥᱟᱹᱠ', 'Baisak'),
  SantaliMonthDefinition(SantaliMonthId.jhent, 'ᱡᱷᱮᱸᱴ', 'Jhent'),
  SantaliMonthDefinition(SantaliMonthId.ashal, 'ᱟᱥᱟᱲ', 'Ashal'),
  SantaliMonthDefinition(SantaliMonthId.saan, 'ᱥᱟᱱ', 'Saan'),
  SantaliMonthDefinition(SantaliMonthId.bhador, 'ᱵᱷᱟᱫᱚᱨ', 'Bhador'),
  SantaliMonthDefinition(SantaliMonthId.dasany, 'ᱫᱟᱥᱟᱸᱭ', 'Dasany'),
  SantaliMonthDefinition(SantaliMonthId.sohray, 'ᱥᱚᱦᱨᱟᱭ', 'Sohray'),
  SantaliMonthDefinition(SantaliMonthId.aghan, 'ᱟᱜᱷᱟᱬ', 'Aaghan'),
  SantaliMonthDefinition(SantaliMonthId.push, 'ᱯᱩᱥ', 'Pus'),
  SantaliMonthDefinition(
    SantaliMonthId.sarcha,
    'ᱥᱟᱨᱪᱟ ᱪᱟᱸᱫᱳ',
    'Sarcha Chando',
    isLeapMonth: true,
  ),
];
