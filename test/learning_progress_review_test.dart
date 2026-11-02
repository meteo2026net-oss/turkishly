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
