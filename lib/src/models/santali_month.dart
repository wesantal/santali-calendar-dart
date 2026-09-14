enum SantaliMonthId {
  mag,
  fagun,
  chaat,
  baisak,
  jhent,
  ashal,
  saan,
  bhador,
  dasany,
  sohray,
  aghan,
  push,
  sarcha,
}

class SantaliMonth {
  final SantaliMonthId id;
  final int index;
  final String name;
  final String roman;
  final DateTime startDate;
  final DateTime newMoonDate;
  final DateTime fullMoonDate;
  final DateTime endDate;
  final int totalDays;
  final bool isLeapMonth;
  final DateTime displayEndDate;

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
  final SantaliMonthId id;
  final String name;
  final String roman;
  final bool isLeapMonth;

  const SantaliMonthDefinition(
    this.id,
    this.name,
    this.roman, {
    this.isLeapMonth = false,
  });
}

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
