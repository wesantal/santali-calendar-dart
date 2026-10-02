import 'package:santali_calendar/santali_calendar.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final calendar = SantaliCalendar();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      // Today
      final today = calendar.today();

      print('TODAY');
      print(today);

      print('');
      print('Ol Chiki Day: ${today.olChikiDay}');
      print('Ol Chiki Year: ${today.olChikiYear}');

      print('\n------------------\n');

      // Test 2026
      final calendar2026 = calendar.getCalendar(2026);

      print('YEAR 2026');
      print('Start: ${calendar2026.startDate}');
      print('End: ${calendar2026.endDate}');
      print(calendar2026.months);

      print('\n------------------\n');

      // Test 2043
      final calendar2043 = calendar.getCalendar(2043);

      print('YEAR 2043');
      print('Start: ${calendar2043.startDate}');
      print('End: ${calendar2043.endDate}');

      print('\n------------------\n');

      // Test 2043
      final calendar2049 = calendar.getCalendar(2049);
      print("2026 Festivals");
      for (final festival in calendar.getFestivals(2026)) {
        print("${festival.name}: ${festival.date.toString()}\n");
      }

      for (final month in calendar2049.months) {
        print("<=====${month.name}=====>");
        print("Season ${month.season.name}(${month.season.roman})");
        print("Start: ${month.startDate.toLocal()}");
        print("Kunami: ${month.fullMoonDate.toLocal()}");
        print("Next Amavasya: ${month.endDate.toLocal()}\n");
        for (final cell in month.days) {
          if (cell == null) continue;
          if (cell.isAmavasya || cell.isFirstMoonDay || cell.isPurnima) {
            print(
              "${cell.day} ${month.name} ${month.startDate.year} : ${cell.date.toLocal()}",
            );
          }
        }
      }
      print('\n------------------\n');

      // Test a specific Gregorian date
      final date2043 = calendar.getDate(DateTime.utc(2043, 8, 31));

      print('2043-08-31');
      print(date2043);

      print('\n------------------\n');

      // Get Bhador of 2026
      final bhador = calendar.getMonth(2026, 7);

      print('BHADOR 2026');
      print('Name: ${bhador.name}');
      print('English: ${bhador.roman}');
      print('Start: ${bhador.startDate}');
      print('End: ${bhador.endDate}');

      print('\n-------- Current Month ----------\n');

      // Get month by date
      final month = calendar.getCurrentMonth();
      print('Month Start: ${month.startDate}');
      print('Month End: ${month.displayEndDate}');
      for (final day in month.days) {
        print('Ol Chiki Day: ${day?.olChikiDay}');
        print('Day: ${day?.day} - Weekday: ${day?.weekDay}');
        print('Is Today: ${day?.isToday}');
        print('Date: ${day?.date.toLocal()}');
        print('\n===========\n');
      }

      // Seasons
      final seasons = calendar.getSeasons();
      for (final season in seasons) {
        print("Season ${season.name}");
        print("Roman: ${season.roman}");
        print("English: ${season.english}");
        print("Description: ${season.description}");
        print("\n===========\n");
      }
    });
  });
}
