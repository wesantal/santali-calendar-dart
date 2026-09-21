/// Festival rule types and definitions for the Santali calendar.
///
/// Supports three kinds of festival rules:
/// - [FixedGregorianFestivalRule] — fixed Gregorian date (e.g. June 30)
/// - [FixedSantaliFestivalRule] — fixed day in a Santali month (e.g. day 5 of Mag)
/// - [MoonRelativeFestivalRule] — offset from a moon phase in a Santali month
library;

import 'package:santali_calendar/models/santali_month.dart';

/// Lunar phase used for moon-relative festival rules.
enum MoonPhase {
  /// Amavasya (new moon).
  newMoon,

  /// Purnima (full moon).
  fullMoon,
}

/// A rule that places a festival on a fixed day within a Santali month.
///
/// Unlike [FixedGregorianRule], this uses the Santali month identity
/// ([monthId]) rather than a Gregorian month number.
class FixedSantaliRule {
  /// Day of the Santali month (1-based).
  final int day;

  /// Santali month in which the festival falls.
  final SantaliMonthId monthId;

  /// Creates a fixed Santali rule for [day] of [monthId].
  const FixedSantaliRule({required this.day, required this.monthId});
}

/// A rule that places a festival on a fixed Gregorian date.
///
/// The [month] and [day] are Gregorian calendar values.
class FixedGregorianRule {
  /// Day of the Gregorian month (1-based).
  final int day;

  /// Gregorian month (1 = January ... 12 = December).
  final int month;

  /// Creates a fixed Gregorian rule for [month]/[day].
  const FixedGregorianRule({required this.month, required this.day});
}

/// A rule that places a festival relative to a moon phase in a Santali month.
///
/// The festival date is computed as [offsetDays] after (or before, if
/// negative) the [phase] of [monthId].
class MoonRelativeRule {
  /// Moon phase to offset from.
  final MoonPhase phase;

  /// Santali month in which the moon phase occurs.
  final SantaliMonthId monthId;

  /// Number of days to add to the moon-phase date.
  final int offsetDays;

  /// Creates a moon-relative rule.
  const MoonRelativeRule({
    required this.phase,
    required this.monthId,
    required this.offsetDays,
  });
}

/// Base class for all Santali festival resolution rules.
///
/// Subclasses:
/// - [FixedGregorianFestivalRule]
/// - [FixedSantaliFestivalRule]
/// - [MoonRelativeFestivalRule]
sealed class SantaliFestivalRule {
  /// Creates a festival rule.
  const SantaliFestivalRule();
}

/// A festival rule based on a fixed Gregorian date.
///
/// Example: Hul Maha on June 30 every year.
class FixedGregorianFestivalRule extends SantaliFestivalRule {
  /// The fixed Gregorian date rule.
  final FixedGregorianRule rule;

  /// Creates a fixed Gregorian festival rule.
  const FixedGregorianFestivalRule(this.rule);
}

/// A festival rule based on a moon phase relative to a Santali month.
///
/// Example: Sohray on the full moon of Sohray month.
class MoonRelativeFestivalRule extends SantaliFestivalRule {
  /// The moon-relative rule.
  final MoonRelativeRule rule;

  /// Creates a moon-relative festival rule.
  const MoonRelativeFestivalRule(this.rule);
}

/// A festival rule based on a fixed day in a Santali month.
///
/// Example: Mag Bonga on day 5 of Mag.
class FixedSantaliFestivalRule extends SantaliFestivalRule {
  /// The fixed Santali date rule.
  final FixedSantaliRule rule;

  /// Creates a fixed Santali festival rule.
  const FixedSantaliFestivalRule(this.rule);
}

/// Classification of Santali festivals by cultural significance.
enum SantaliFestivalType {
  /// Major community festival (e.g. Mag Bonga, Sohray).
  festival,

  /// Birth anniversary of a notable figure.
  birthAnniversary,

  /// Death anniversary of a notable figure.
  deathAnniversary,

  /// Cultural event (e.g. Jantal, Dasany).
  cultural,

  /// Community gathering or observance (e.g. Ir Sid, Parsi Jitkar Maha).
  community,

  /// General observance (e.g. Santali New Year, Dah Serma).
  observance,
}

/// Declarative definition of a Santali festival.
///
/// Contains the festival's identity ([id], [name], [roman]), its
/// [SantaliFestivalType], a resolution [SantaliFestivalRule], and an
/// optional [description]. Use [SantaliCalendar.getFestivals] to
/// resolve definitions into concrete [SantaliFestival] instances.
class SantaliFestivalDefinition {
  /// Unique identifier (e.g. `'mag-bonga'`).
  final String id;

  /// Ol Chiki display name.
  final String name;

  /// Roman-script display name.
  final String roman;

  /// Festival classification.
  final SantaliFestivalType type;

  /// Rule used to compute the festival date for a given year.
  final SantaliFestivalRule rule;

  /// Optional Ol Chiki description.
  final String? description;

  /// Creates a festival definition.
  const SantaliFestivalDefinition({
    required this.id,
    required this.name,
    required this.roman,
    required this.type,
    required this.rule,
    this.description,
  });
}

/// A resolved Santali festival with its concrete date.
///
/// Created by [SantaliCalendar.getFestivals] from a
/// [SantaliFestivalDefinition].
class SantaliFestival {
  /// Unique identifier (e.g. `'mag-bonga'`).
  final String id;

  /// Ol Chiki display name.
  final String name;

  /// Roman-script display name.
  final String roman;

  /// Santali month in which the festival falls.
  final SantaliMonthId monthId;

  /// Festival classification.
  final SantaliFestivalType type;

  /// Optional Ol Chiki description.
  final String? description;

  /// Resolved Gregorian date of the festival.
  final DateTime date;

  /// Creates a resolved festival.
  const SantaliFestival({
    required this.id,
    required this.name,
    required this.roman,
    required this.monthId,
    required this.type,
    required this.date,
    this.description,
  });
}
