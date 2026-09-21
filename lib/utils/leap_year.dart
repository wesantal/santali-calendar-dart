/// Metonic cycle leap-year calculation for the Santali calendar.
///
/// The Santali calendar follows the 19-year Metonic cycle:
/// leap years occur at positions 1, 4, 7, 9, 12, 15, and 18
/// within each cycle starting from [metonicCycleStart].
library;

/// First Gregorian year of the current Metonic cycle.
const int metonicCycleStart = 2026;

/// Positions within the 19-year Metonic cycle that are leap years.
const Set<int> metonicLeapPositions = {1, 4, 7, 9, 12, 15, 18};

/// Returns whether [year] is a Santali leap year.
///
/// Leap years contain 13 months (including Sarcha) instead of the
/// usual 12, giving a total of 384 days instead of 354.
///
/// ```dart
/// isLeapYear(2026); // true (position 1)
/// isLeapYear(2027); // false
/// ```
bool isLeapYear(int year) {
  final position = (((year - metonicCycleStart) % 19) + 19) % 19 + 1;
  return metonicLeapPositions.contains(position);
}
