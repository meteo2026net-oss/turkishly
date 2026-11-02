import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkishly/services/learning_progress.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'sara_turkii_completed_lessons_v1': <String>['a1-u1-1'],
      'unrelated_preference': 'keep-me',
    });
  });

  group('Learning progress backup', () {
    test('records a same-day activity streak', () async {
      await LearningProgress.recordLearningActivity();
      await LearningProgress.recordLearningActivity();
      expect(await LearningProgress.currentLearningStreak(), 1);
    });

    test('exports only app-owned preferences in a versioned format', () async {
      final backup = await LearningProgress.exportBackup();
      final decoded = jsonDecode(backup) as Map<String, dynamic>;
      expect(decoded['format'], 'sara_turkii_learning_backup');
      expect(decoded['version'], 1);
      expect(decoded['data'], isA<Map<String, dynamic>>());
      expect(backup, isNot(contains('unrelated_preference')));
    });

    test('restores recognized values without changing unrelated preferences', () async {
      const backup = '{"format":"sara_turkii_learning_backup","version":1,"data":{"sara_turkii_completed_lessons_v1":["a1-u1-1","a1-u1-2"],"sara_turkii_quiz_best_v1":90,"other_app_key":"ignored"}}';
      final count = await LearningProgress.restoreBackup(backup);
      expect(count, 2);
      expect(await LearningProgress.completedLessons(), containsAll(['a1-u1-1', 'a1-u1-2']));
      expect(await LearningProgress.bestQuizScore(), 90);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('unrelated_preference'), 'keep-me');
      expect(prefs.getString('other_app_key'), isNull);
    });

    test('rejects unsupported formats and oversized payloads', () async {
      await expectLater(LearningProgress.restoreBackup('{"format":"unknown","version":1,"data":{}}'), throwsFormatException);
      await expectLater(LearningProgress.restoreBackup(List<String>.filled(5 * 1024 * 1024 + 1, 'x').join()), throwsFormatException);
    });
  });
}
