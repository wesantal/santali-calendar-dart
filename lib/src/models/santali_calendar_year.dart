import 'package:santali_calendar/src/models/santali_month.dart';

class SantaliCalendarYear {
  final int year;
  final DateTime startDate;
  final DateTime endDate;
  final List<SantaliMonth> months;

  const SantaliCalendarYear({
    required this.year,
    required this.startDate,
    required this.endDate,
    required this.months,
  });
}
