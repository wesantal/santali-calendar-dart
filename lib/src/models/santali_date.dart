import 'package:santali_calendar/src/models/santali_month.dart';
import 'package:santali_calendar/src/utils/olchiki_number.dart';

class SantaliDate {
  final int year;
  final int monthIndex;
  final SantaliMonth month;
  final String monthEnglish;
  final int day;

  final DateTime gregorianDate;
  final DateTime monthStartDate;
  final DateTime monthEndDate;

  const SantaliDate({
    required this.year,
    required this.monthIndex,
    required this.month,
    required this.monthEnglish,
    required this.day,
    required this.gregorianDate,
    required this.monthStartDate,
    required this.monthEndDate,
  });

  String get olChikiDay => toOlChikiNumeral(day);

  String get olChikiYear => toOlChikiNumeral(year);

  @override
  String toString() {
    return '$day ${month.name} $year '
        '(${month.english}, Gregorian: '
        '${gregorianDate.toIso8601String().split("T").first})';
  }
}
