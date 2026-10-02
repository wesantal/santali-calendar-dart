/// Santali season models and definitions.
///
/// Contains [SantaliSeasonDefinition] (static season metadata) and
/// the canonical ordered list of the six Santali seasons,
/// [santaliSeasons]. The [SantaliSeason] enum itself is declared in
/// `constants/seasons.dart`.
library;

import 'package:santali_calendar/constants/seasons.dart';
import 'package:santali_calendar/models/santali_month.dart';

/// Static metadata for a Santali season.
class SantaliSeasonDefinition {
  /// Season identity.
  final SantaliSeason id;

  /// Ol Chiki display name.
  final String name;

  /// Roman-script display name.
  final String roman;

  /// English name of the season.
  final String english;

  /// 0-based Santali month indices covered by this season.
  ///
  /// 0 = Mag ... 11 = Pus, and 12 = Sarcha (leap month, only present
  /// in leap years).
  final List<SantaliMonthId> months;

  /// Optional Ol Chiki description.
  final String? description;

  /// Creates a season definition.
  const SantaliSeasonDefinition({
    required this.id,
    required this.name,
    required this.roman,
    required this.english,
    required this.months,
    this.description,
  });

  /// Whether this season covers the Santali month [monthId].
  bool containsMonth(SantaliMonthId monthId) => months.contains(monthId);

  @override
  String toString() {
    return '$roman ($name, $english)';
  }
}

/// Static definitions for the six Santali seasons, in year order.
///
/// Sarcha Chando is part of [SantaliSeason.hemanta] in leap years.
const List<SantaliSeasonDefinition> santaliSeasons = [
  SantaliSeasonDefinition(
    id: SantaliSeason.shishira,
    name: 'ᱨᱟᱵᱟᱝ',
    roman: 'Rabang',
    english: 'Winter',
    months: [SantaliMonthId.push, SantaliMonthId.mag],
    description: 'ᱯᱩᱥ ᱟᱨ ᱢᱟᱜᱽ ᱠᱤᱱ ᱫᱚ ᱨᱟᱵᱟᱝ ᱨᱤᱛᱩ ᱠᱚ ᱢᱮᱱ-ᱟ᱾',
  ),
  SantaliSeasonDefinition(
    id: SantaliSeason.basanta,
    name: 'ᱱᱤᱨᱚᱲ',
    roman: 'Niral',
    english: 'Spring',
    months: [SantaliMonthId.fagun, SantaliMonthId.chaat],
    description: 'ᱯᱷᱟᱹᱜᱩᱱ ᱟᱨ ᱪᱟᱹᱛ ᱠᱤᱱ ᱫᱚ ᱱᱤᱨᱚᱲ ᱨᱤᱛᱩ ᱠᱚ ᱢᱮᱱ-ᱟ᱾ ᱱᱚᱣᱟ ᱨᱤᱛᱩᱨᱮ ᱫᱚ ᱫᱟᱨᱮ ᱟᱨ ᱱᱟᱹᱲᱤ ᱠᱚᱨᱮ ᱡᱮᱸᱜᱮᱫ ᱜᱮ ᱵᱟᱦᱟᱜ-ᱟ᱾',
  ),
  SantaliSeasonDefinition(
    id: SantaliSeason.grishma,
    name: 'ᱥᱤᱛᱩᱝ',
    roman: 'Situng',
    english: 'Summer',
    months: [SantaliMonthId.baisak, SantaliMonthId.jhent],
    description: 'ᱵᱟᱹᱶᱥᱟᱹᱠ ᱟᱨ ᱡᱷᱮᱸᱴ ᱠᱤᱱ ᱫᱚ ᱥᱤᱛᱩᱝ ᱨᱤᱛᱩ ᱠᱚ ᱢᱮᱱ-ᱟ᱾',
  ),
  SantaliSeasonDefinition(
    id: SantaliSeason.barsha,
    name: 'ᱡᱟᱹᱯᱩᱫ',
    roman: 'Japud',
    english: 'Monsoon',
    months: [SantaliMonthId.ashal, SantaliMonthId.saan],
    description: 'ᱟᱥᱟᱲ ᱟᱨ ᱥᱟᱱ ᱠᱤᱱ ᱫᱚ ᱡᱟᱹᱯᱩᱫ ᱨᱤᱛᱩ ᱠᱚ ᱢᱮᱱ-ᱟ᱾',
  ),
  SantaliSeasonDefinition(
    id: SantaliSeason.sarata,
    name: 'ᱦᱮᱢᱟᱞ',
    roman: 'Hemal',
    english: 'Autumn',
    months: [SantaliMonthId.bhador, SantaliMonthId.dasany],
    description: 'ᱵᱷᱟᱫᱚᱨ ᱟᱨ ᱫᱟᱥᱟᱶ ᱠᱤᱱ ᱫᱚ ᱦᱮᱢᱟᱞ ᱨᱤᱛᱩ ᱠᱚ ᱢᱮᱱ-ᱟ᱾',
  ),
  SantaliSeasonDefinition(
    id: SantaliSeason.hemanta,
    name: 'ᱦᱟᱣᱮᱫ',
    roman: 'Hawed',
    english: 'Pre-winter',
    months: [
      SantaliMonthId.sohray,
      SantaliMonthId.aghan,
      SantaliMonthId.sarcha,
    ],
    description: 'ᱥᱚᱦᱚᱨᱟᱭ ᱟᱨ ᱟᱜᱷᱟᱬ ᱠᱤᱱ ᱫᱚ ᱦᱟᱣᱮᱫ ᱨᱤᱛᱩ ᱠᱚ ᱢᱮᱱ-ᱟ᱾ ᱱᱚᱣᱟ ᱨᱤᱛᱩ ᱨᱮᱫᱚ ᱨᱮ ᱫᱚ ᱦᱳᱲᱳ ᱠᱚ ᱜᱮᱞᱮᱜ-ᱟ᱾',
  ),
];

/// Season of every 0-based Santali month index, derived from
/// [santaliSeasons].
final Map<SantaliMonthId, SantaliSeason> monthSeasons = {
  for (final definition in santaliSeasons)
    for (final monthId in definition.months) monthId: definition.id,
};

/// Returns the [SantaliSeasonDefinition] of [season].
///
/// Throws a [StateError] for an unknown season.
SantaliSeasonDefinition getSeasonDefinition(SantaliSeason season) {
  for (final definition in santaliSeasons) {
    if (definition.id == season) {
      return definition;
    }
  }
  throw StateError('Unknown Santali season: $season');
}

/// Returns the [SantaliSeason] of the Santali month [monthId].
///
/// [monthId] is 0-based: 0 = Mag ... 11 = Pus, and 12 = Sarcha
/// (leap month, only present in leap years). Throws a [RangeError]
/// for out-of-range indices.
SantaliSeasonDefinition seasonOfMonthId(SantaliMonthId monthId) {
  return santaliSeasons.firstWhere((s) => s.months.contains(monthId));
}
