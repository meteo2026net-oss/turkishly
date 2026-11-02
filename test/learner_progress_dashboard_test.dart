import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkishly/screens/learner_progress_dashboard.dart';
import 'package:turkishly/services/learning_progress.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('shows evidence-based review topics and opens the mistake review', (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1500));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await LearningProgress.recordMissedQuestionDetails(
      prompt: 'ما معنى bugün؟',
      selectedAnswer: 'غداً',
      correctAnswer: 'اليوم',
      explanation: 'Bugün تعني اليوم.',
      topic: 'الزمن والأيام',
    );

    await tester.pumpWidget(const MaterialApp(
      home: LearnerProgressDashboard(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('مراجعة مقترحة حسب أخطائك'), findsOneWidget);
    expect(find.text('الزمن والأيام'), findsOneWidget);

    await tester.tap(find.text('ابدأ مراجعة الأخطاء'));
    await tester.pumpAndSettle();

    expect(find.text('مراجعة أخطائي'), findsOneWidget);
    expect(find.text('ما معنى bugün؟'), findsOneWidget);
  });
}
