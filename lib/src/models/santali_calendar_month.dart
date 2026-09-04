import 'package:santali_calendar/src/models/santali_calendar_day.dart';

class SantaliCalendarMonth {
  final String name;
  final String english;
  final DateTime startDate;
  final DateTime endDate;
  final List<SantaliCalendarDay?> days;

  const SantaliCalendarMonth({
    required this.days,
    required this.name,
    required this.english,
    required this.endDate,
    required this.startDate,
  });
}
