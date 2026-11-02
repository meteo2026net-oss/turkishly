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
        },
      }));

      final prefs = await SharedPreferences.getInstance();
      expect(restored, 1);
      expect(prefs.getInt('sara_turkii_quiz_best_v1'), 92);
      expect(prefs.getString('unrelated_user_setting'), 'keep-me');
      expect(prefs.containsKey('another_app_setting'), isFalse);
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
