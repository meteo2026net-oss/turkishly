import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkishly/services/learning_progress.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('counts a streak ending on the reference calendar day', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'sara_turkii_learning_activity_dates_v1': <String>[
        '2026-03-28',
        '2026-03-29',
        '2026-03-30',
      ],
    });

    expect(
      await LearningProgress.currentLearningStreak(
        now: DateTime(2026, 3, 30, 23, 45),
      ),
      3,
    );
  });

  test('keeps yesterday streak when there is no activity today', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'sara_turkii_learning_activity_dates_v1': <String>[
        '2026-03-28',
        '2026-03-29',
      ],
    });

    expect(
      await LearningProgress.currentLearningStreak(
        now: DateTime(2026, 3, 30, 0, 5),
      ),
      2,
    );
  });

  test('returns zero after a missed calendar day', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'sara_turkii_learning_activity_dates_v1': <String>[
        '2026-03-27',
        '2026-03-29',
      ],
    });

    expect(
      await LearningProgress.currentLearningStreak(
        now: DateTime(2026, 3, 30),
      ),
      0,
    );
  });
}
