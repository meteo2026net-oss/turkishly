import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkishly/services/learning_progress.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('Learning history retention limits', () {
    test('keeps only the newest 100 quiz attempts', () async {
      for (var index = 0; index < 105; index++) {
        await LearningProgress.recordQuizResult(
          score: index % 10,
          total: 10,
          source: 'quiz-$index',
        );
      }

      final history = await LearningProgress.quizHistory(limit: 200);
      expect(history, hasLength(100));
      expect(history.first['source'], 'quiz-104');
      expect(history.last['source'], 'quiz-5');
    });

    test('keeps only the newest 100 conversation attempts', () async {
      for (var index = 0; index < 105; index++) {
        await LearningProgress.recordConversationResult(
          scenarioId: 'scenario-$index',
          title: 'محادثة $index',
          level: 'A1',
          score: 1,
          total: 1,
        );
      }

      final history = await LearningProgress.conversationHistory(limit: 200);
      expect(history, hasLength(100));
      expect(history.first['scenarioId'], 'scenario-104');
      expect(history.last['scenarioId'], 'scenario-5');
    });

    test('keeps only the newest 100 level assessment attempts', () async {
      for (var index = 0; index < 105; index++) {
        await LearningProgress.recordLevelAssessmentAttempt(
          level: 'A1',
          score: index % 10,
          total: 10,
        );
      }

      final history = await LearningProgress.levelAssessmentHistory(limit: 200);
      expect(history, hasLength(100));
      expect(history.first['score'], 4);
      expect(history.last['score'], 5);
    });

    test('caps stored activity dates at 400 unique calendar days', () async {
      final dates = List<String>.generate(405, (index) {
        final date = DateTime(2025, 1, 1).add(Duration(days: index));
        return '${date.year.toString().padLeft(4, '0')}-'
            '${date.month.toString().padLeft(2, '0')}-'
            '${date.day.toString().padLeft(2, '0')}';
      });
      SharedPreferences.setMockInitialValues(<String, Object>{
        'sara_turkii_learning_activity_dates_v1': dates,
      });

      await LearningProgress.recordLearningActivity();

      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getStringList(
        'sara_turkii_learning_activity_dates_v1',
      )!;
      expect(stored, hasLength(400));
      expect(stored, orderedEquals(stored.toList()..sort()));
      expect(stored.first, dates[6]);
      expect(stored.last, dates.last);
    });

    test('skips malformed conversation history records', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'sara_turkii_conversation_history_v1': <String>[
          jsonEncode(<String, Object>{
            'scenarioId': 'valid',
            'title': 'محادثة سليمة',
            'percent': 80,
          }),
          '{invalid-json',
          jsonEncode(<String, Object>{'scenarioId': 'missing-fields'}),
        ],
      });

      final history = await LearningProgress.conversationHistory();
      expect(history, hasLength(1));
      expect(history.single['scenarioId'], 'valid');
    });
  });
}
