import 'package:santali_calendar/src/models/santali_calendar_month.dart';

class SantaliCalendarYear {
  final int year;
  final DateTime endDate;
  final DateTime startDate;
  final int currentMonthIndex;
  final List<SantaliCalendarMonth> months;

  const SantaliCalendarYear({
    required this.year,
    required this.months,
    required this.endDate,
    required this.startDate,
    required this.currentMonthIndex,
  });
}
