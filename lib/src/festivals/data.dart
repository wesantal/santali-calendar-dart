import 'package:santali_calendar/src/festivals/types.dart';
import 'package:santali_calendar/src/models/santali_month.dart';

const List<SantaliFestivalDefinition> santaliFestivals = [
  SantaliFestivalDefinition(
    id: 'santali-new-year',
    name: 'ᱱᱟᱣᱟ ᱥᱮᱨᱢᱟ',
    roman: 'Santali New Year',
    type: SantaliFestivalType.observance,
    rule: MoonRelativeFestivalRule(
      MoonRelativeRule(
        phase: MoonPhase.newMoon,
        offsetDays: 0,
        monthId: SantaliMonthId.mag,
      ),
    ),
    description: 'ᱟᱵᱚᱟᱜ ᱱᱟᱣᱟ ᱥᱮᱨᱢᱟ',
  ),
  SantaliFestivalDefinition(
    id: 'mag-bonga',
    name: 'ᱢᱟᱜᱽ ᱵᱚᱸᱜᱟ',
    roman: 'Mag Bonga',
    type: SantaliFestivalType.festival,
    rule: MoonRelativeFestivalRule(
      MoonRelativeRule(
        phase: MoonPhase.newMoon,
        offsetDays: 4,
        monthId: SantaliMonthId.mag,
      ),
    ),
    description: 'ᱢᱩᱞᱩᱜ ᱕ ᱟᱢᱤ',
  ),
  SantaliFestivalDefinition(
    id: 'pandit-death-anniversary',
    name: 'ᱜᱩᱨᱩ ᱜᱚᱢᱠᱮ ᱜᱩᱨᱩ ᱢᱟᱸᱦᱟ',
    roman: 'Guru Gomke Guru Maha',
    type: SantaliFestivalType.deathAnniversary,
    rule: MoonRelativeFestivalRule(
      MoonRelativeRule(
        phase: MoonPhase.newMoon,
        offsetDays: 6,
        monthId: SantaliMonthId.mag,
      ),
    ),
    description: 'ᱢᱩᱞᱩᱜ ᱗ ᱟᱹᱢᱤ',
  ),
  SantaliFestivalDefinition(
    id: 'bidu-chandan',
    name: 'ᱵᱤᱫᱩ ᱪᱟᱸᱫᱟᱱ',
    roman: 'Bidu Chandan',
    type: SantaliFestivalType.festival,
    rule: MoonRelativeFestivalRule(
      MoonRelativeRule(
        phase: MoonPhase.fullMoon,
        offsetDays: 0,
        monthId: SantaliMonthId.mag,
      ),
    ),
    description: 'ᱢᱟᱜᱽ ᱠᱩᱱᱟᱹᱢᱤ',
  ),
  SantaliFestivalDefinition(
    id: 'baha-bonga',
    name: 'ᱵᱟᱦᱟ ᱵᱚᱸᱜᱟ',
    roman: 'Baha Bonga',
    type: SantaliFestivalType.festival,
    rule: MoonRelativeFestivalRule(
      MoonRelativeRule(
        phase: MoonPhase.newMoon,
        offsetDays: 4,
        monthId: SantaliMonthId.fagun,
      ),
    ),
    description: 'ᱯᱷᱟᱹᱜᱩᱱ ᱢᱩᱞᱩᱜ ᱕ ᱟᱹᱢᱤ',
  ),
  SantaliFestivalDefinition(
    id: 'eroh-bonga',
    name: 'ᱮᱨᱚᱜ ᱵᱚᱸᱜᱟ',
    roman: 'Eroh',
    type: SantaliFestivalType.festival,
    rule: MoonRelativeFestivalRule(
      MoonRelativeRule(
        phase: MoonPhase.newMoon,
        offsetDays: 4,
        monthId: SantaliMonthId.chaat,
      ),
    ),
    description: 'ᱢᱩᱞᱩᱜ ᱕ ᱟᱹᱢᱤ',
  ),
  SantaliFestivalDefinition(
    id: 'guru-kunami',
    name: 'ᱜᱩᱨᱩ ᱠᱩᱹᱱᱟᱹᱢᱤ',
    roman: 'Guru Kunami',
    type: SantaliFestivalType.birthAnniversary,
    rule: MoonRelativeFestivalRule(
      MoonRelativeRule(
        phase: MoonPhase.fullMoon,
        offsetDays: 0,
        monthId: SantaliMonthId.baisak,
      ),
    ),
    description: 'ᱵᱟᱹᱭᱥᱟᱹᱠ ᱠᱩᱱᱟᱹᱢᱤ',
  ),
  SantaliFestivalDefinition(
    id: 'dah-serma',
    name: 'ᱫᱟᱜ ᱥᱮᱨᱢᱟ',
    roman: 'Dah Serma',
    type: SantaliFestivalType.observance,
    rule: MoonRelativeFestivalRule(
      MoonRelativeRule(
        phase: MoonPhase.fullMoon,
        offsetDays: 0,
        monthId: SantaliMonthId.jhent,
      ),
    ),
    description: 'ᱡᱷᱮᱸᱴ ᱵᱟᱸᱜᱟ ᱠᱩᱱᱟᱹᱢᱤ',
  ),
  SantaliFestivalDefinition(
    id: 'asalia-bonga',
    name: 'ᱟᱹᱥᱟᱹᱲᱤᱭᱟᱹ ᱵᱚᱸᱜᱟ',
    roman: 'Asalia Bonga',
    type: SantaliFestivalType.festival,
    rule: MoonRelativeFestivalRule(
      MoonRelativeRule(
        phase: MoonPhase.newMoon,
        offsetDays: 4,
        monthId: SantaliMonthId.ashal,
      ),
    ),
    description: 'ᱢᱩᱞᱩᱜ ᱕ ᱟᱹᱢᱤ',
  ),
  SantaliFestivalDefinition(
    id: 'hul-maha',
    name: 'ᱦᱩᱞ ᱢᱟᱸᱦᱟ',
    roman: 'Hul Maha',
    type: SantaliFestivalType.festival,
    rule: FixedGregorianFestivalRule(FixedGregorianRule(month: 6, day: 30)),
    description: 'ᱥᱤᱫᱩ, ᱠᱟᱹᱱᱩ, ᱪᱟᱸᱫ, ᱵᱷᱟᱭᱨᱚ, ᱯᱷᱩᱞᱚ ᱟᱨ ᱡᱷᱟᱱᱚ',
  ),
  SantaliFestivalDefinition(
    id: 'hariyali',
    name: 'ᱦᱟᱹᱨᱤᱭᱟᱹᱲᱤ',
    roman: 'Hariyali',
    type: SantaliFestivalType.festival,
    rule: MoonRelativeFestivalRule(
      MoonRelativeRule(
        phase: MoonPhase.fullMoon,
        offsetDays: 0,
        monthId: SantaliMonthId.saan,
      ),
    ),
    description: 'ᱥᱟᱱ ᱵᱚᱸᱜᱟ ᱠᱩᱱᱟᱹᱢᱤ',
  ),
  SantaliFestivalDefinition(
    id: 'jantal',
    name: 'ᱡᱟᱱᱛᱟᱲ',
    roman: 'Jantal',
    type: SantaliFestivalType.cultural,
    rule: MoonRelativeFestivalRule(
      MoonRelativeRule(
        phase: MoonPhase.fullMoon,
        offsetDays: 0,
        monthId: SantaliMonthId.bhador,
      ),
    ),
    description: 'ᱵᱷᱟᱫᱚᱨ ᱵᱚᱸᱜᱟ ᱠᱩᱱᱟᱹᱢᱤ',
  ),
  SantaliFestivalDefinition(
    id: 'dasany',
    name: 'ᱫᱟᱥᱟᱸᱭ',
    roman: 'Dasany',
    type: SantaliFestivalType.cultural,
    rule: MoonRelativeFestivalRule(
      MoonRelativeRule(
        phase: MoonPhase.newMoon,
        offsetDays: 4,
        monthId: SantaliMonthId.dasany,
      ),
    ),
    description: 'ᱢᱩᱞᱩᱜ ᱕ ᱟᱹᱢᱤ',
  ),
  SantaliFestivalDefinition(
    id: 'sohray',
    name: 'ᱥᱚᱦᱨᱟᱭ',
    roman: 'Sohray',
    type: SantaliFestivalType.festival,
    rule: MoonRelativeFestivalRule(
      MoonRelativeRule(
        phase: MoonPhase.fullMoon,
        offsetDays: 0,
        monthId: SantaliMonthId.sohray,
      ),
    ),
    description: 'ᱠᱩᱱᱟᱹᱢᱤ ᱥᱚᱦᱨᱟᱭ',
  ),
  SantaliFestivalDefinition(
    id: 'ir-sid',
    name: 'ᱤᱨ ᱥᱤᱫ',
    roman: 'Ir Sid',
    type: SantaliFestivalType.community,
    rule: MoonRelativeFestivalRule(
      MoonRelativeRule(
        phase: MoonPhase.newMoon,
        offsetDays: 4,
        monthId: SantaliMonthId.push,
      ),
    ),
    description: 'ᱢᱩᱞᱩᱜ ᱕ ᱟᱹᱢᱤ',
  ),
  SantaliFestivalDefinition(
    id: 'parsi-jitkar-maha',
    name: 'ᱯᱟᱹᱨᱥᱤ ᱡᱤᱛᱠᱟᱹᱨ ᱢᱟᱸᱦᱟ',
    roman: 'Parsi Jitkar Maha',
    type: SantaliFestivalType.community,
    rule: FixedGregorianFestivalRule(FixedGregorianRule(month: 12, day: 22)),
    description: 'ᱯᱟᱹᱨᱥᱤ ᱡᱤᱛᱠᱟᱹᱨ ᱢᱟᱸᱦᱟ',
  ),
  SantaliFestivalDefinition(
    id: 'baba-tilka-majhi-janam-maha',
    name: 'ᱵᱟᱵᱟ ᱛᱤᱞᱠᱟᱹ ᱢᱟᱡᱷᱤ ᱡᱟᱱᱟᱢ ᱢᱟᱦᱟ',
    roman: 'Baba Tilka Majhi Janam Maha',
    type: SantaliFestivalType.festival,
    rule: FixedGregorianFestivalRule(FixedGregorianRule(month: 2, day: 11)),
    description: 'ᱵᱟᱵᱟ ᱛᱤᱞᱠᱟᱹ ᱢᱟᱡᱷᱤ ᱡᱟᱱᱟᱢ ᱢᱟᱦᱟ',
  ),
  SantaliFestivalDefinition(
    id: 'adivasi-diwas',
    name: 'ᱟᱹᱫᱤᱵᱟᱹᱥᱤ ᱢᱟᱸᱦᱟ',
    roman: 'Adivasi Diwas',
    type: SantaliFestivalType.festival,
    rule: FixedGregorianFestivalRule(FixedGregorianRule(month: 8, day: 9)),
    description: 'ᱟᱹᱫᱤᱵᱟᱹᱥᱤ ᱢᱟᱸᱦᱟ',
  ),
];
