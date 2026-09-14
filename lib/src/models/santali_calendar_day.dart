import 'package:santali_calendar/src/constants/weeks.dart';

class SantaliCalendarDay {
  final int day;
  final DateTime date;
  final bool isToday;
  final bool isCurrentMonth;
  final bool isPurnima;
  final bool isAmavasya;
  final SantaliWeekDay weekDay;

  const SantaliCalendarDay({
    required this.day,
    required this.date,
    required this.weekDay,
    required this.isToday,
    required this.isPurnima,
    required this.isAmavasya,
    required this.isCurrentMonth,
  });
}
