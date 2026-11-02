import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkishly/services/learning_progress.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('Spaced word review', () {
    test('schedules progressively longer intervals after successful recall', () async {
      const wordId = 'a1-u1-word-1';
      final expectedDays = <int>[1, 3, 7, 14, 30];

      for (var index = 0; index < expectedDays.length; index++) {
        final before = DateTime.now();
        await LearningProgress.recordWordReview(wordId, recalled: true);
        final due = await LearningProgress.wordReviewDueAt(wordId);
        expect(due, isNotNull);
        final hours = due!.difference(before).inHours;
        expect(hours, inInclusiveRange(expectedDays[index] * 24 - 1, expectedDays[index] * 24));
        expect(await LearningProgress.wordReviewStreak(wordId), index + 1);
      }
    });

    test('resets a missed word to a same-day review', () async {
      const wordId = 'a1-u1-word-2';
      await LearningProgress.recordWordReview(wordId, recalled: true);
      await LearningProgress.recordWordReview(wordId, recalled: true);

      final before = DateTime.now();
      await LearningProgress.recordWordReview(wordId, recalled: false);
      final due = await LearningProgress.wordReviewDueAt(wordId);

      expect(due, isNotNull);
      expect(due!.difference(before).inSeconds.abs(), lessThan(2));
      expect(await LearningProgress.wordReviewStreak(wordId), 0);
    });
  });

  group('Adaptive review recommendations', () {
    test('ranks recurring missed topics by frequency and limits the result', () async {
      Future<void> save(String prompt, String topic) =>
          LearningProgress.recordMissedQuestionDetails(
            prompt: prompt,
            selectedAnswer: 'wrong',
            correctAnswer: 'right',
            explanation: 'review',
            topic: topic,
          );

      await save('question-1', 'الأفعال والتصريف');
      await save('question-2', 'المفردات الأساسية');
      await save('question-3', 'الأفعال والتصريف');
      await save('question-4', 'الأفعال والتصريف');
      await save('question-5', 'المفردات الأساسية');

      final summary = await LearningProgress.missedQuestionTopicSummary(limit: 2);

      expect(summary, hasLength(2));
      expect(summary.first['topic'], 'الأفعال والتصريف');
      expect(summary.first['count'], 3);
      expect(summary.last['topic'], 'المفردات الأساسية');
      expect(summary.last['count'], 2);
      expect(await LearningProgress.missedQuestionTopicSummary(limit: 0), isEmpty);
    });

    test('returns no recommendations when the learner has no saved mistakes', () async {
      expect(await LearningProgress.missedQuestionTopicSummary(), isEmpty);
    });
  });

  group('Conversation practice history', () {
    test('persists completed scenario scores and returns newest attempts first', () async {
      await LearningProgress.recordConversationResult(
        scenarioId: 'cafe',
        title: 'في المقهى',
        level: 'A1',
        score: 2,
        total: 2,
      );
      await LearningProgress.recordConversationResult(
        scenarioId: 'directions',
        title: 'الاتجاهات والطريق',
        level: 'A2',
        score: 1,
        total: 2,
      );

      final history = await LearningProgress.conversationHistory();
      expect(history, hasLength(2));
      expect(history.first['scenarioId'], 'directions');
      expect(history.first['percent'], 50);
      expect(history.last['title'], 'في المقهى');
      expect(history.last['percent'], 100);
      expect(await LearningProgress.conversationHistory(limit: 1), hasLength(1));
    });

    test('clamps scores to the valid range', () async {
      await LearningProgress.recordConversationResult(
        scenarioId: 'bounds',
        title: 'اختبار حدود النتيجة',
        level: 'A1',
        score: 9,
        total: 2,
      );
      final history = await LearningProgress.conversationHistory();
      expect(history.single['score'], 2);
      expect(history.single['percent'], 100);
    });

    test('includes conversation history in portable backups', () async {
      await LearningProgress.recordConversationResult(
        scenarioId: 'cafe',
        title: 'في المقهى',
        level: 'A1',
        score: 1,
        total: 2,
      );
      final backup = await LearningProgress.exportBackup();
      SharedPreferences.setMockInitialValues(<String, Object>{});

      final restored = await LearningProgress.restoreBackup(backup);
      final history = await LearningProgress.conversationHistory();

      expect(restored, greaterThan(0));
      expect(history, hasLength(1));
      expect(history.single['scenarioId'], 'cafe');
      expect(history.single['percent'], 50);
    });
  });

  group('Level assessment history', () {
    test('stores one history item per explicit completed attempt', () async {
      await LearningProgress.recordLevelAssessment('B2', 80);
      await LearningProgress.recordLevelAssessmentAttempt(
        level: 'B2',
        score: 8,
        total: 10,
      );

      final history = await LearningProgress.levelAssessmentHistory();
      expect(history, hasLength(1));
      expect(history.single['level'], 'B2');
      expect(history.single['score'], 8);
      expect(history.single['total'], 10);
      expect(history.single['percent'], 80);
      expect(await LearningProgress.levelAssessmentBest('B2'), 80);
      expect(await LearningProgress.isLevelPassed('B2'), isTrue);
    });

    test('retains the best percentage independently from attempt history', () async {
      await LearningProgress.recordLevelAssessment('C1', 70);
      await LearningProgress.recordLevelAssessment('C1', 90);
      await LearningProgress.recordLevelAssessment('C1', 60);

      expect(await LearningProgress.levelAssessmentBest('C1'), 90);
      expect(await LearningProgress.isLevelPassed('C1'), isTrue);
    });
  });
}
