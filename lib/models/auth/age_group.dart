/// Age groups for child development stages
/// Used to filter content and determine appropriate chapters
enum AgeGroup {
  pregnancy(-1, 0, 'Expecting', 'pregnant_woman'),
  infant(0, 3, '0-3 Years', 'child_care'),
  toddler(3, 5, '3-5 Years', 'child_friendly'),
  child(6, 12, '6-12 Years', 'school'),
  teen(13, 17, '13-17 Years', 'person');

  final int minAge;
  final int maxAge;
  final String label;
  final String icon;

  const AgeGroup(this.minAge, this.maxAge, this.label, this.icon);

  /// Calculate age group from date of birth
  /// Returns pregnancy if DOB is in the future (expected due date)
  static AgeGroup fromDateOfBirth(DateTime dob) {
    final now = DateTime.now();

    // If DOB is in the future, it's an expected due date
    if (dob.isAfter(now)) {
      return AgeGroup.pregnancy;
    }

    // Calculate age in years
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }

    if (age < 0) return AgeGroup.pregnancy;
    if (age < 3) return AgeGroup.infant;
    if (age < 6) return AgeGroup.toddler;
    if (age < 13) return AgeGroup.child;
    return AgeGroup.teen;
  }

  /// Calculate exact age from date of birth
  static int calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  /// Get display text for age
  static String getAgeDisplay(DateTime dob) {
    final now = DateTime.now();

    // If DOB is in the future, show weeks until due
    if (dob.isAfter(now)) {
      final weeksUntilDue = dob.difference(now).inDays ~/ 7;
      if (weeksUntilDue <= 0) return 'Due soon';
      return '$weeksUntilDue weeks until due';
    }

    final age = calculateAge(dob);
    if (age < 1) {
      final months = now.difference(dob).inDays ~/ 30;
      return '$months months';
    }
    return '$age years';
  }

  /// Get chapters available for this age group
  List<int> get availableChapters {
    switch (this) {
      case AgeGroup.pregnancy:
        return [1, 2, 7, 8]; // Overview, Pregnancy, Cross-cutting, Self-care
      case AgeGroup.infant:
        return [1, 3, 7, 8]; // Overview, 0-3 years, Cross-cutting, Self-care
      case AgeGroup.toddler:
        return [1, 4, 7, 8]; // Overview, 3-5 years, Cross-cutting, Self-care
      case AgeGroup.child:
        return [1, 5, 7, 8]; // Overview, 6-12 years, Cross-cutting, Self-care
      case AgeGroup.teen:
        return [1, 6, 7, 8]; // Overview, 13-17 years, Cross-cutting, Self-care
    }
  }
}
