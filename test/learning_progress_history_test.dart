import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkishly/services/learning_progress.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('Learning progress history and review', () {
    test('clamps quiz scores and returns history newest first with a limit', () async {
      await LearningProgress.recordQuizResult(score: 15, total: 10, source: 'اختبار أول');
      await LearningProgress.recordQuizResult(score: -2, total: 10, source: 'اختبار ثانٍ');

      expect(await LearningProgress.latestQuizScore(), 0);
      expect(await LearningProgress.bestQuizScore(), 100);
      expect(await LearningProgress.quizCount(), 2);

      final history = await LearningProgress.quizHistory(limit: 1);
      expect(history, hasLength(1));
      expect(history.single['source'], 'اختبار ثانٍ');
      expect(history.single['score'], 0);
      expect(history.single['percent'], 0);
      expect(await LearningProgress.quizHistory(limit: 0), isEmpty);
    });

    test('handles zero-question quizzes without division errors', () async {
      await LearningProgress.recordQuizResult(score: 5, total: 0);

      expect(await LearningProgress.latestQuizScore(), 0);
      expect(await LearningProgress.bestQuizScore(), 0);
      expect((await LearningProgress.quizHistory()).single['total'], 0);
    });

    test('deduplicates missed prompts and updates their review details', () async {
      await LearningProgress.recordMissedQuestionDetails(
        prompt: 'Hangi kitabı okuyorsun?',
        selectedAnswer: 'أين تذهب؟',
        correctAnswer: 'أي كتاب تقرأ؟',
        explanation: 'Hangi asks which.',
        topic: 'أدوات الاستفهام',
        source: 'اختبار A1',
      );
      await LearningProgress.recordMissedQuestionDetails(
        prompt: 'Hangi kitabı okuyorsun?',
        selectedAnswer: 'متى تقرأ؟',
        correctAnswer: 'أي كتاب تقرأ؟',
        explanation: 'Hangi asks which.',
        topic: 'أدوات الاستفهام',
        source: 'مراجعة',
      );
      await LearningProgress.recordMissedQuestionDetails(
        prompt: 'Nereye gidiyorsun?',
        selectedAnswer: 'من أنت؟',
        correctAnswer: 'إلى أين تذهب؟',
        explanation: 'Nereye asks where to.',
        topic: 'أدوات الاستفهام',
      );

      expect(await LearningProgress.missedQuestions(), hasLength(2));
      final details = await LearningProgress.missedQuestionDetails();
      expect(details, hasLength(2));
      expect(details.first['source'], 'مراجعة');
      expect(details.first['selectedAnswer'], 'متى تقرأ؟');
      expect(await LearningProgress.missedQuestionTopicSummary(), [
        {'topic': 'أدوات الاستفهام', 'count': 2},
      ]);

      await LearningProgress.clearMissedQuestions();
      expect(await LearningProgress.missedQuestions(), isEmpty);
      expect(await LearningProgress.missedQuestionDetails(), isEmpty);
    });

    test('records conversation results with bounded scores and newest-first history', () async {
      await LearningProgress.recordConversationResult(
        scenarioId: 'greetings',
        title: 'التعارف',
        level: 'A1',
        score: 8,
        total: 10,
      );
      await LearningProgress.recordConversationResult(
        scenarioId: 'travel',
        title: 'السفر',
        level: 'A2',
        score: 12,
        total: 10,
      );

      final history = await LearningProgress.conversationHistory(limit: 1);
      expect(history, hasLength(1));
      expect(history.single['title'], 'السفر');
      expect(history.single['score'], 10);
      expect(history.single['percent'], 100);
      expect(await LearningProgress.conversationHistory(limit: 0), isEmpty);
    });

    test('keeps best level score and records individual attempts', () async {
      await LearningProgress.recordLevelAssessment('B1', 75);
      await LearningProgress.recordLevelAssessment('B1', 60);
      await LearningProgress.recordLevelAssessment('B1', 125);
      await LearningProgress.recordLevelAssessmentAttempt(
        level: 'B1',
        score: 7,
        total: 10,
      );

      expect(await LearningProgress.levelAssessmentBest('B1'), 100);
      expect(await LearningProgress.isLevelPassed('B1'), isTrue);
      expect(await LearningProgress.isLevelPassed('A1'), isFalse);
      final history = await LearningProgress.levelAssessmentHistory();
      expect(history.single['level'], 'B1');
      expect(history.single['percent'], 70);
    });

    test('calculates streaks by calendar dates across daylight-saving boundaries', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'sara_turkii_learning_activity_dates_v1': <String>[
          '2026-03-27',
          '2026-03-28',
          '2026-03-29',
        ],
      });

      expect(
        await LearningProgress.currentLearningStreak(
          now: DateTime(2026, 3, 29, 23, 30),
        ),
        3,
      );
      expect(
        await LearningProgress.currentLearningStreak(
          now: DateTime(2026, 3, 30, 12),
        ),
        3,
      );
      expect(
        await LearningProgress.currentLearningStreak(
          now: DateTime(2026, 4, 2),
        ),
        0,
      );
    });

    test('ignores malformed history entries while reading valid quiz records', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'sara_turkii_quiz_history_v1': <String>[
          jsonEncode({'score': 4, 'total': 5, 'source': 'سجل صحيح'}),
          '{broken-json',
        ],
      });

      final history = await LearningProgress.quizHistory();
      expect(history, hasLength(1));
      expect(history.single['source'], 'سجل صحيح');
    });
  });
}
