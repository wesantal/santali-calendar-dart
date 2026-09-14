import 'package:santali_calendar/santali_calendar.dart';

void main() {
  final calendar = SantaliCalendar();
  final date = calendar.getDate(DateTime.now());
  final today = calendar.getCalendarToday();

  print("Date: ${date.toString()}");
  print("Day: ${today.toString()}");
  print("Month: ${today.month.name} (${today.month.roman})");
  print("Year: ${today.year}");
  print("Week Day: ${today.weekDay}");
  print("Is Purnima: ${today.isPurnima}");
  print("Is Amavasya: ${today.isAmavasya}");
  print("Is Leap Month: ${today.isLeapMonth}");
  print("Month ID: ${today.month.id}");

  // months
  final months = calendar.getCalendar(2026).months;
  for (int i = 0; i < months.length; i++) {
    final month = months[i];
    print("\n=======\n");
    print("Month: ${month.name} (${month.roman}) [${month.id.name}]");
    print("Month Start: ${month.startDate.toLocal()}");
    print("Month End: ${month.endDate.toLocal()}");
    print("Month Display End: ${month.displayEndDate.toLocal()}");
    print("Purnima: ${month.fullMoonDate.toLocal()}");
    print("Amavasya: ${month.newMoonDate.toLocal()}");
  }

  // festivals
  print("\n======= FESTIVALS 2026 =======\n");
  final festivals = calendar.getFestivals(2026);
  for (final f in festivals) {
    print("${f.roman}: ${f.date.toLocal()} (${f.type.name})");
  }
}
