import 'package:santali_calendar/src/models/santali_month.dart';
import 'package:santali_calendar/src/utils/olchiki_number.dart';

class SantaliDate {
  final int day;
  final int year;
  final int monthIndex;
  final int weekDay;
  final DateTime date;
  final DateTime monthStartDate;
  final DateTime monthEndDate;
  final String monthEnglish;
  final bool isPurnima;
  final bool isAmavasya;
  final bool isLeapMonth;
  final SantaliMonth month;

  const SantaliDate({
    required this.day,
    required this.year,
    required this.monthIndex,
    required this.date,
    required this.month,
    required this.weekDay,
    required this.monthStartDate,
    required this.monthEndDate,
    required this.monthEnglish,
    required this.isPurnima,
    required this.isAmavasya,
    required this.isLeapMonth,
  });

  String get olChikiDay => toOlChikiNumeral(day);

  String get olChikiYear => toOlChikiNumeral(year);

  @override
  String toString() {
    return '$day ${month.name} $year '
        '(${month.roman}, Gregorian: '
        '${date.toIso8601String().split("T").first})';
  }
}
