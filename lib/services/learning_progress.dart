import 'dart:convert';

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
  static const _quizHistoryKey = 'sara_turkii_quiz_history_v1';
  static const _missedQuestionsKey = 'sara_turkii_missed_questions_v1';
  static const _missedQuestionDetailsKey = 'sara_turkii_missed_question_details_v1';
  static const _wordReviewPrefix = 'sara_turkii_word_review_v1_';
  static const _wordStreakPrefix = 'sara_turkii_word_streak_v1_';
  static const _levelPassPrefix = 'sara_turkii_level_pass_v1_';
  static const _levelHistoryKey = 'sara_turkii_level_assessment_history_v1';
  static const _levelHistoryKey = 'sara_turkii_level_assessment_history_v1';

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

  /// Records recall quality and schedules the next local review.
  /// Successful recall intervals grow gradually; missed words return to today's queue.
  static Future<void> recordWordReview(String wordId, {required bool recalled}) async {
    final prefs = await SharedPreferences.getInstance();
    final streakKey = '$_wordStreakPrefix$wordId';
    final streak = recalled ? (prefs.getInt(streakKey) ?? 0) + 1 : 0;
    const intervals = <int>[1, 3, 7, 14, 30];
    final days = recalled ? intervals[(streak - 1).clamp(0, intervals.length - 1)] : 0;
    final due = DateTime.now().add(Duration(days: days)).millisecondsSinceEpoch;
    await prefs.setInt(streakKey, streak);
    await prefs.setInt('$_wordReviewPrefix$wordId', due);
  }

  static Future<DateTime?> wordReviewDueAt(String wordId) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt('$_wordReviewPrefix$wordId');
    return value == null ? null : DateTime.fromMillisecondsSinceEpoch(value);
  }

  static Future<int> wordReviewStreak(String wordId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_wordStreakPrefix$wordId') ?? 0;
  }

  static Future<void> recordQuizResult({required int score, required int total, String source = 'الاختبار الشامل'}) async {
    final prefs = await SharedPreferences.getInstance();
    final percent = total <= 0 ? 0 : (score * 100 ~/ total);
    final best = prefs.getInt(_quizBestKey) ?? 0;
    await prefs.setInt(_quizLatestKey, percent);
    if (percent > best) await prefs.setInt(_quizBestKey, percent);
    await prefs.setInt(_quizCountKey, (prefs.getInt(_quizCountKey) ?? 0) + 1);
    final history = prefs.getStringList(_quizHistoryKey) ?? <String>[];
    history.add(jsonEncode(<String, dynamic>{
      'score': score,
      'total': total,
      'percent': percent,
      'source': source,
      'completedAt': DateTime.now().toIso8601String(),
    }));
    if (history.length > 100) history.removeRange(0, history.length - 100);
    await prefs.setStringList(_quizHistoryKey, history);
  }

  /// Returns the latest completed attempts, newest first. Legacy aggregate scores remain intact.
  static Future<List<Map<String, dynamic>>> quizHistory({int limit = 30}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_quizHistoryKey) ?? <String>[];
    final result = <Map<String, dynamic>>[];
    for (final value in raw.reversed) {
      try {
        result.add(Map<String, dynamic>.from(jsonDecode(value) as Map));
      } catch (_) {
        // Skip an incomplete history entry without affecting other records.
      }
      if (result.length >= limit) break;
    }
    return result;
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

  /// Saves a complete review card while preserving the legacy prompt-only list.
  static Future<void> recordMissedQuestionDetails({
    required String prompt,
    required String selectedAnswer,
    required String correctAnswer,
    required String explanation,
    required String topic,
    String? unitId,
    int? lessonNumber,
    String? lessonTitle,
    String? source,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_missedQuestionDetailsKey) ?? <String>[];
    final items = raw.map((value) {
      try {
        return Map<String, dynamic>.from(jsonDecode(value) as Map);
      } catch (_) {
        return <String, dynamic>{};
      }
    }).where((item) => item.isNotEmpty).toList();
    items.removeWhere((item) => item['prompt'] == prompt);
    items.add(<String, dynamic>{
      'prompt': prompt,
      'selectedAnswer': selectedAnswer,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'topic': topic,
      if (source != null) 'source': source,
      if (unitId != null) 'unitId': unitId,
      if (lessonNumber != null) 'lessonNumber': lessonNumber,
      if (lessonTitle != null) 'lessonTitle': lessonTitle,
      'updatedAt': DateTime.now().toIso8601String(),
    });
    await prefs.setStringList(
      _missedQuestionDetailsKey,
      items.map((item) => jsonEncode(item)).toList(),
    );
    await recordMissedQuestion(prompt);
  }

  static Future<List<Map<String, dynamic>>> missedQuestionDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_missedQuestionDetailsKey) ?? <String>[];
    final result = <Map<String, dynamic>>[];
    for (final value in raw) {
      try {
        result.add(Map<String, dynamic>.from(jsonDecode(value) as Map));
      } catch (_) {
        // Ignore malformed legacy or interrupted entries safely.
      }
    }
    return result;
  }

  static Future<void> clearMissedQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_missedQuestionsKey);
    await prefs.remove(_missedQuestionDetailsKey);
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

  static Future<void> recordLevelAssessment(String level, int percent) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_levelPassPrefix$level';
    final previous = prefs.getInt(key) ?? 0;
    if (percent > previous) await prefs.setInt(key, percent);
  }

  static Future<void> recordLevelAssessmentAttempt({required String level, required int score, required int total}) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_levelHistoryKey) ?? <String>[];
    final percent = total <= 0 ? 0 : score * 100 ~/ total;
    history.add(jsonEncode(<String, dynamic>{
      'level': level, 'score': score, 'total': total, 'percent': percent,
      'completedAt': DateTime.now().toIso8601String(),
    }));
    if (history.length > 100) history.removeRange(0, history.length - 100);
    await prefs.setStringList(_levelHistoryKey, history);
  }

  static Future<List<Map<String, dynamic>>> levelAssessmentHistory({int limit = 30}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_levelHistoryKey) ?? <String>[];
    final result = <Map<String, dynamic>>[];
    for (final value in raw.reversed) {
      try { result.add(Map<String, dynamic>.from(jsonDecode(value) as Map)); }
      catch (_) { /* Ignore malformed entries. */ }
      if (result.length >= limit) break;
    }
    return result;
  }

  static Future<void> recordLevelAssessmentAttempt({required String level, required int score, required int total}) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_levelHistoryKey) ?? <String>[];
    final percent = total <= 0 ? 0 : score * 100 ~/ total;
    history.add(jsonEncode(<String, dynamic>{'level': level, 'score': score, 'total': total, 'percent': percent, 'completedAt': DateTime.now().toIso8601String()}));
    if (history.length > 100) history.removeRange(0, history.length - 100);
    await prefs.setStringList(_levelHistoryKey, history);
  }

  static Future<List<Map<String, dynamic>>> levelAssessmentHistory({int limit = 30}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_levelHistoryKey) ?? <String>[];
    final result = <Map<String, dynamic>>[];
    for (final value in raw.reversed) {
      try { result.add(Map<String, dynamic>.from(jsonDecode(value) as Map)); } catch (_) {}
      if (result.length >= limit) break;
    }
    return result;
  }

  static Future<int> levelAssessmentBest(String level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_levelPassPrefix$level') ?? 0;
  }

  static Future<bool> isLevelPassed(String level) async =>
      (await levelAssessmentBest(level)) >= 80;

  static Future<int> attemptsFor(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_attemptPrefix$lessonId') ?? 0;
  }
}
