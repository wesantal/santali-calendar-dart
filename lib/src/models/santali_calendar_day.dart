import 'package:santali_calendar/src/constants/weeks.dart';

class SantaliCalendarDay {
  final int day;
  final DateTime date;
  final bool isToday;
  final SantaliWeekDay weekDay;
  final bool isCurrentMonth;

  const SantaliCalendarDay({
    required this.day,
    required this.date,
    required this.isToday,
    required this.weekDay,
    required this.isCurrentMonth,
  });
}
