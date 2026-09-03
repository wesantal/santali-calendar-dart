class SantaliMonth {
  final int days;
  final String name;
  final String english;
  final DateTime? startDate;
  final DateTime? endDate;

  const SantaliMonth({
    required this.days,
    required this.name,
    required this.english,
    this.startDate,
    this.endDate,
  });

  SantaliMonth copyWith({
    int? days,
    String? name,
    String? english,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return SantaliMonth(
      days: days ?? this.days,
      name: name ?? this.name,
      english: english ?? this.english,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  String toString() {
    return '$name ($english)';
  }
}
