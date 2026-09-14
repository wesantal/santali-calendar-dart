import 'package:santali_calendar/models/santali_calendar_day.dart';
import 'package:santali_calendar/models/santali_month.dart';

class SantaliCalendarMonth extends SantaliMonth {
  final List<SantaliCalendarDay?> days;

  const SantaliCalendarMonth({
    required this.days,
    required super.id,
    required super.name,
    required super.roman,
    required super.index,
    required super.endDate,
    required super.startDate,
    required super.totalDays,
    required super.isLeapMonth,
    required super.newMoonDate,
    required super.fullMoonDate,
    required super.displayEndDate,
  });
}
