import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkishly/services/learning_progress.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'unrelated_user_setting': 'keep-me',
      'sara_turkii_quiz_best_v1': 25,
      'sara_turkii_unrecognized_v1': 77,
    });
  });

  group('Learning backup restore safety', () {
    test('restores app data without changing unrelated preferences', () async {
      final restored = await LearningProgress.restoreBackup(jsonEncode({
        'format': 'sara_turkii_learning_backup',
        'version': 1,
        'exportedAt': DateTime.now().toIso8601String(),
        'data': <String, dynamic>{
          'sara_turkii_quiz_best_v1': 92,
          'another_app_setting': 'must-not-be-imported',
          'sara_turkii_unrecognized_v1': 66,
        },
      }));

      final prefs = await SharedPreferences.getInstance();
      expect(restored, 1);
      expect(prefs.getInt('sara_turkii_quiz_best_v1'), 92);
      expect(prefs.getString('unrelated_user_setting'), 'keep-me');
      expect(prefs.containsKey('another_app_setting'), isFalse);
      expect(prefs.getInt('sara_turkii_unrecognized_v1'), 77);
    });

    test('rejects unsupported format and version before writing anything', () async {
      final invalidBackups = <String>[
        jsonEncode({
          'format': 'unknown',
          'version': 1,
          'data': {'sara_turkii_quiz_best_v1': 99},
        }),
        jsonEncode({
          'format': 'sara_turkii_learning_backup',
          'version': 99,
          'data': {'sara_turkii_quiz_best_v1': 99},
        }),
        jsonEncode({
          'format': 'sara_turkii_learning_backup',
          'version': 1,
          'data': <dynamic>[],
        }),
      ];

      for (final backup in invalidBackups) {
        await expectLater(
          LearningProgress.restoreBackup(backup),
          throwsFormatException,
        );
      }

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('sara_turkii_quiz_best_v1'), 25);
    });

    test('rejects an oversized backup before decoding or writing', () async {
      final oversized = ' ' * (5 * 1024 * 1024 + 1);

      await expectLater(
        LearningProgress.restoreBackup(oversized),
        throwsFormatException,
      );

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('sara_turkii_quiz_best_v1'), 25);
    });

    test('ignores unsupported value types while restoring valid entries', () async {
      final restored = await LearningProgress.restoreBackup(jsonEncode({
        'format': 'sara_turkii_learning_backup',
        'version': 1,
        'data': <String, dynamic>{
          'sara_turkii_quiz_best_v1': 88,
          'sara_turkii_invalid_nested_value': {'unexpected': true},
          'sara_turkii_invalid_list_value': [1, 2, 3],
        },
      }));

      final prefs = await SharedPreferences.getInstance();
      expect(restored, 1);
      expect(prefs.getInt('sara_turkii_quiz_best_v1'), 88);
      expect(prefs.containsKey('sara_turkii_invalid_nested_value'), isFalse);
      expect(prefs.containsKey('sara_turkii_invalid_list_value'), isFalse);
    });

    test('round-trips recognized per-lesson and per-word progress keys', () async {
      await LearningProgress.recordAttempt('a1-u1-1');
      await LearningProgress.recordWordReview('word-7', recalled: true);
      final backup = await LearningProgress.exportBackup();
      SharedPreferences.setMockInitialValues(<String, Object>{});

      await LearningProgress.restoreBackup(backup);

      expect(await LearningProgress.attemptsFor('a1-u1-1'), 1);
      expect(await LearningProgress.wordReviewStreak('word-7'), 1);
    });

    test('rejects values whose types do not match their recognized keys', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'sara_turkii_completed_lessons_v1': <String>['a1-u1-1'],
        'sara_turkii_attempts_v1_a1-u1-1': 2,
        'unrelated_user_setting': 'keep-me',
      });

      final restored = await LearningProgress.restoreBackup(jsonEncode({
        'format': 'sara_turkii_learning_backup',
        'version': 1,
        'data': <String, dynamic>{
          'sara_turkii_quiz_best_v1': 88,
          'sara_turkii_completed_lessons_v1': 123,
          'sara_turkii_attempts_v1_a1-u1-1': 'not-an-integer',
          'sara_turkii_attempts_v1_a1-u1-2': 4,
        },
      }));

      final prefs = await SharedPreferences.getInstance();
      expect(restored, 2);
      expect(await LearningProgress.bestQuizScore(), 88);
      expect(await LearningProgress.completedLessons(), {'a1-u1-1'});
      expect(await LearningProgress.attemptsFor('a1-u1-1'), 2);
      expect(await LearningProgress.attemptsFor('a1-u1-2'), 4);
      expect(prefs.getString('unrelated_user_setting'), 'keep-me');
    });

    test('exports only values matching the recognized key schema', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'sara_turkii_quiz_best_v1': 45,
        'sara_turkii_completed_lessons_v1': <String>['a1-u1-1'],
        'sara_turkii_attempts_v1_a1-u1-1': 3,
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('sara_turkii_quiz_latest_v1', 'invalid-type');

      final backup = await LearningProgress.exportBackup();
      final decoded = jsonDecode(backup) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>;

      expect(data['sara_turkii_quiz_best_v1'], 45);
      expect(data['sara_turkii_completed_lessons_v1'], ['a1-u1-1']);
      expect(data['sara_turkii_attempts_v1_a1-u1-1'], 3);
      expect(data.containsKey('sara_turkii_quiz_latest_v1'), isFalse);
    });

    test('exports only recognized app keys', () async {
      final backup = await LearningProgress.exportBackup();
      final decoded = jsonDecode(backup) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>;

      expect(data.keys, contains('sara_turkii_quiz_best_v1'));
      expect(data.keys, isNot(contains('sara_turkii_unrecognized_v1')));
      expect(data.keys, isNot(contains('unrelated_user_setting')));
    });

    test('exported backup round-trips current learner progress', () async {
      await LearningProgress.recordQuizResult(score: 7, total: 10);
      final backup = await LearningProgress.exportBackup();
      SharedPreferences.setMockInitialValues(<String, Object>{
        'unrelated_user_setting': 'still-here',
      });

      final restored = await LearningProgress.restoreBackup(backup);
      final prefs = await SharedPreferences.getInstance();

      expect(restored, greaterThan(0));
      expect(await LearningProgress.latestQuizScore(), 70);
      expect((await LearningProgress.quizHistory()).single['score'], 7);
      expect(prefs.getString('unrelated_user_setting'), 'still-here');
    });
  });
}
