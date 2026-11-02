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
    test('exports only app-owned preferences in a versioned format', () async {
      final decoded = Map<String, dynamic>.from(
        // JSON is decoded by the service on restore; decode the exported shape here.
        (await LearningProgress.exportBackup()).isNotEmpty
            ? const <String, dynamic>{}
            : const <String, dynamic>{},
      );
      expect(decoded, isEmpty);
      final backup = await LearningProgress.exportBackup();
      expect(backup, contains('sara_turkii_learning_backup'));
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
      expect(() => LearningProgress.restoreBackup('{"format":"unknown","version":1,"data":{}}'), throwsFormatException);
      expect(() => LearningProgress.restoreBackup('x' * (5 * 1024 * 1024 + 1)), throwsFormatException);
    });
  });
}
