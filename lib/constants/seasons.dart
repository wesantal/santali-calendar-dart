/// Season (ṛtu) definitions for the Santali calendar.
///
/// Provides the [SantaliSeason] enum. Static season metadata (names,
/// English names, descriptions, and covered months) lives in
/// [SantaliSeasonDefinition] (`models/santali_season.dart`).
library;

/// The six traditional seasons (ṛtu) of the Santali calendar.
///
/// Each season spans two Santali months, except [hemanta] which also
/// covers the intercalary month Sarcha in leap years.
enum SantaliSeason {
  /// Shishira (ᱨᱟᱵᱟᱝ) — cold season (Mag, Fagun).
  shishira,

  /// Basanta (ᱱᱤᱨᱚᱲ) — spring (Chaat, Baisak).
  basanta,

  /// Grishma (ᱥᱤᱛᱩᱝ) — summer (Jhent, Ashal).
  grishma,

  /// Barsha (ᱡᱟᱹᱯᱩᱫ) — monsoon (Saan, Bhador).
  barsha,

  /// sarata (ᱦᱮᱢᱟᱞ) — autumn (Dasany, Sohray).
  ///
  /// The Santali form of this season is commonly written Sorom.
  sarata,

  /// Hemanta (ᱦᱟᱣᱮᱫ) — pre-winter (Aaghan, Pus, Sarcha).
  hemanta,
}
