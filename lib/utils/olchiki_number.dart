/// Ol Chiki numeral conversion utilities.
///
/// Converts standard Arabic numerals to their Ol Chiki script
/// equivalents used in the Santali calendar.
library;

/// Converts [number] to its Ol Chiki numeral representation.
///
/// Each decimal digit is mapped to the corresponding Ol Chiki
/// numeral character (᱐–᱙).
///
/// ```dart
/// toOlChikiNumeral(2026); // "᱒᱐᱒᱖"
/// toOlChikiNumeral(42);   // "᱔᱒"
/// ```
String toOlChikiNumeral(int number) {
  const digits = ['᱐', '᱑', '᱒', '᱓', '᱔', '᱕', '᱖', '᱗', '᱘', '᱙'];

  return number
      .toString()
      .split('')
      .map((digit) => digits[int.parse(digit)])
      .join();
}
