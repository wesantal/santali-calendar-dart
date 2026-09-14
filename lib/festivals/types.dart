import 'package:santali_calendar/models/santali_month.dart';

enum MoonPhase { newMoon, fullMoon }

class FixedGregorianRule {
  final int day;
  final int month;

  const FixedGregorianRule({required this.month, required this.day});
}

class MoonRelativeRule {
  final MoonPhase phase;
  final SantaliMonthId monthId;
  final int offsetDays;

  const MoonRelativeRule({
    required this.phase,
    required this.monthId,
    required this.offsetDays,
  });
}

sealed class SantaliFestivalRule {
  const SantaliFestivalRule();
}

class FixedGregorianFestivalRule extends SantaliFestivalRule {
  final FixedGregorianRule rule;

  const FixedGregorianFestivalRule(this.rule);
}

class MoonRelativeFestivalRule extends SantaliFestivalRule {
  final MoonRelativeRule rule;

  const MoonRelativeFestivalRule(this.rule);
}

enum SantaliFestivalType {
  festival,
  birthAnniversary,
  deathAnniversary,
  cultural,
  community,
  observance,
}

class SantaliFestivalDefinition {
  final String id;
  final String name;
  final String roman;
  final SantaliFestivalType type;
  final SantaliFestivalRule rule;
  final String? description;

  const SantaliFestivalDefinition({
    required this.id,
    required this.name,
    required this.roman,
    required this.type,
    required this.rule,
    this.description,
  });
}

class SantaliFestival {
  final String id;
  final String name;
  final String roman;
  final SantaliMonthId monthId;
  final SantaliFestivalType type;
  final String? description;
  final DateTime date;

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
