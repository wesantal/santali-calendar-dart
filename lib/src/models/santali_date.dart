import 'package:santali_calendar/src/models/santali_month.dart';
import 'package:santali_calendar/src/utils/olchiki_number.dart';

class SantaliDate {
  final int day;
  final int year;
  final int weekDay;
  final int monthIndex;
  final DateTime date;
  final bool isPurnima;
  final bool isAmavasya;
  final bool isLeapMonth;
  final SantaliMonth month;

  const SantaliDate({
    required this.day,
    required this.year,
    required this.date,
    required this.month,
    required this.weekDay,
    required this.monthIndex,
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
