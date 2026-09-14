const int metonicCycleStart = 2026;

const Set<int> metonicLeapPositions = {1, 4, 7, 9, 12, 15, 18};

bool isLeapYear(int year) {
  final position = (((year - metonicCycleStart) % 19) + 19) % 19 + 1;
  return metonicLeapPositions.contains(position);
}
