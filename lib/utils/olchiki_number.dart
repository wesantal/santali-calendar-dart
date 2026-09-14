String toOlChikiNumeral(int number) {
  const digits = ['᱐', '᱑', '᱒', '᱓', '᱔', '᱕', '᱖', '᱗', '᱘', '᱙'];

  return number
      .toString()
      .split('')
      .map((digit) => digits[int.parse(digit)])
      .join();
}
