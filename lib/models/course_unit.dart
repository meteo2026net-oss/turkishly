class CourseUnit {
  const CourseUnit({
    required this.id,
    required this.level,
    required this.titleArabic,
    required this.titleTurkish,
    required this.description,
    required this.lessons,
    this.isCompleted = false,
  });

  final String id;
  final String level;
  final String titleArabic;
  final String titleTurkish;
  final String description;
  final List<String> lessons;
  final bool isCompleted;

  int get lessonCount => lessons.length;
}
