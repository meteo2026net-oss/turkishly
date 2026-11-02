import 'package:shared_preferences/shared_preferences.dart';

/// Progress is stored locally on this device/browser. No personal data is sent.
class LearningProgress {
  LearningProgress._();
  static const _completedKey = 'sara_turkii_completed_lessons_v1';
  static const _attemptPrefix = 'sara_turkii_attempts_v1_';
  static const _learnedWordsKey = 'sara_turkii_learned_words_v1';
  static const _quizBestKey = 'sara_turkii_quiz_best_v1';
  static const _quizLatestKey = 'sara_turkii_quiz_latest_v1';
  static const _quizCountKey = 'sara_turkii_quiz_count_v1';
  static const _missedQuestionsKey = 'sara_turkii_missed_questions_v1';

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

  static Future<Set<String>> learnedWords() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_learnedWordsKey) ?? <String>[]).toSet();
  }

  static Future<void> setWordLearned(String wordId, bool learned) async {
    final prefs = await SharedPreferences.getInstance();
    final words = (prefs.getStringList(_learnedWordsKey) ?? <String>[]).toSet();
    if (learned) {
      words.add(wordId);
    } else {
      words.remove(wordId);
    }
    await prefs.setStringList(_learnedWordsKey, words.toList());
  }

  static Future<void> recordQuizResult({required int score, required int total}) async {
    final prefs = await SharedPreferences.getInstance();
    final percent = total <= 0 ? 0 : (score * 100 ~/ total);
    final best = prefs.getInt(_quizBestKey) ?? 0;
    await prefs.setInt(_quizLatestKey, percent);
    if (percent > best) await prefs.setInt(_quizBestKey, percent);
    await prefs.setInt(_quizCountKey, (prefs.getInt(_quizCountKey) ?? 0) + 1);
  }

  static Future<void> recordMissedQuestion(String prompt) async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList(_missedQuestionsKey) ?? <String>[];
    if (!items.contains(prompt)) {
      items.add(prompt);
      await prefs.setStringList(_missedQuestionsKey, items);
    }
  }

  static Future<List<String>> missedQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_missedQuestionsKey) ?? <String>[];
  }

  static Future<void> clearMissedQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_missedQuestionsKey);
  }

  static Future<int> bestQuizScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_quizBestKey) ?? 0;
  }

  static Future<int> latestQuizScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_quizLatestKey) ?? 0;
  }

  static Future<int> quizCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_quizCountKey) ?? 0;
  }

  static Future<int> attemptsFor(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_attemptPrefix$lessonId') ?? 0;
  }
}
