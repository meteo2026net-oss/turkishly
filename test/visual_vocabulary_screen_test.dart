import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/screens/visual_vocabulary_screen.dart';

void main() {
  testWidgets('visual vocabulary practice opens and exposes reading control', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: VisualVocabularyScreen()));
    await tester.pumpAndSettle();
    expect(find.text('اختر الكلمة التركية المناسبة للصورة'), findsOneWidget);
    expect(find.text('ما اسم هذا الشيء باللغة التركية؟'), findsOneWidget);
    expect(find.textContaining('الصورة 1 من'), findsOneWidget);
  });
}
