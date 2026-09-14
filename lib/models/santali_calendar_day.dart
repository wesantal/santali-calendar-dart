import 'package:santali_calendar/constants/weeks.dart';

class SantaliCalendarDay {
  final int day;
  final bool isToday;
  final DateTime date;
  final bool isPurnima;
  final bool isAmavasya;
  final String olChikiDay;
  final bool isCurrentMonth;
  final SantaliWeekDay weekDay;

  const SantaliCalendarDay({
    required this.day,
    required this.date,
    required this.weekDay,
    required this.isToday,
    required this.isPurnima,
    required this.isAmavasya,
    required this.olChikiDay,
    required this.isCurrentMonth,
  });
}
