import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkishly/services/learning_progress.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('zero and negative history limits return empty lists', () async {
    await LearningProgress.recordQuizResult(score: 1, total: 2);
    await LearningProgress.recordConversationResult(
      scenarioId: 'cafe',
      title: 'في المقهى',
      level: 'A1',
      score: 1,
      total: 2,
    );
    await LearningProgress.recordLevelAssessmentAttempt(
      level: 'A1',
      score: 1,
      total: 2,
    );

    expect(await LearningProgress.quizHistory(limit: 0), isEmpty);
    expect(await LearningProgress.quizHistory(limit: -1), isEmpty);
    expect(await LearningProgress.conversationHistory(limit: 0), isEmpty);
    expect(await LearningProgress.conversationHistory(limit: -1), isEmpty);
    expect(await LearningProgress.levelAssessmentHistory(limit: 0), isEmpty);
    expect(await LearningProgress.levelAssessmentHistory(limit: -1), isEmpty);
  });

  test('positive history limits still return the requested maximum', () async {
    for (var index = 0; index < 4; index++) {
      await LearningProgress.recordQuizResult(score: index, total: 4);
      await LearningProgress.recordConversationResult(
        scenarioId: 'scenario-$index',
        title: 'موقف $index',
        level: 'A1',
        score: index,
        total: 4,
      );
      await LearningProgress.recordLevelAssessmentAttempt(
        level: 'A1',
        score: index,
        total: 4,
      );
    }

    expect(await LearningProgress.quizHistory(limit: 2), hasLength(2));
    expect(await LearningProgress.conversationHistory(limit: 2), hasLength(2));
    expect(await LearningProgress.levelAssessmentHistory(limit: 2), hasLength(2));
  });
}
