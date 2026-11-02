import 'package:shared_preferences/shared_preferences.dart';

/// Progress is stored locally on this device/browser. No personal data is sent.
class LearningProgress {
  LearningProgress._();
  static const _completedKey = 'sara_turkii_completed_lessons_v1';
  static const _attemptPrefix = 'sara_turkii_attempts_v1_';

  static Future<Set<String>> completedLessons() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_completedKey) ?? <String>[]).toSet();
  }

  static Future<void> recordAttempt(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_attemptPrefix$lessonId';
    await prefs.setInt(key, (prefs.getInt(key) ?? 0) + 1);
  }

  static Future<void> completeLesson(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    final lessons = prefs.getStringList(_completedKey) ?? <String>[];
    if (!lessons.contains(lessonId)) {
      lessons.add(lessonId);
      await prefs.setStringList(_completedKey, lessons);
    }
  }

  static Future<int> attemptsFor(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_attemptPrefix$lessonId') ?? 0;
  }
}
