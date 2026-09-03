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

      // Test a specific Gregorian date
      final date2043 = calendar.getDate(DateTime.utc(2043, 8, 31));

      print('2043-08-31');
      print(date2043);

      print('\n------------------\n');

      // Get Bhador of 2026
      final bhador = calendar.getMonth(2026, 7);

      print('BHADOR 2026');
      print('Name: ${bhador.name}');
      print('English: ${bhador.english}');
      print('Start: ${bhador.startDate}');
      print('End: ${bhador.endDate}');
    });
  });
}
