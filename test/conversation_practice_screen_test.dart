import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkishly/screens/conversation_practice_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('learner can complete a conversation and see answer feedback', (tester) async {
    await tester.view.physicalSize = const Size(900, 1400);
    await tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: ConversationPracticeScreen()));
    expect(find.text('تحدث بالتركية في مواقف يومية'), findsOneWidget);

    await tester.tap(find.text('التعارف لأول مرة'));
    await tester.pumpAndSettle();
    expect(find.text('Merhaba! Benim adım Ayşe. Senin adın ne?'), findsOneWidget);

    await tester.tap(find.text('متابعة الحوار'));
    await tester.pumpAndSettle();
    expect(find.text('كيف تسأل: من أين أنت؟'), findsOneWidget);

    await tester.tap(find.text('Nerelisin?'));
    await tester.pumpAndSettle();
    expect(find.text('Nerelisin? تعني: من أين أنت؟'), findsOneWidget);

    await tester.tap(find.text('متابعة الحوار'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('متابعة الحوار'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rica ederim.'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('إنهاء المحادثة'));
    await tester.pumpAndSettle();

    expect(find.text('أحسنت! أنهيت المحادثة'), findsOneWidget);
    expect(find.text('2 من 2 إجابات صحيحة'), findsOneWidget);
  });
}
