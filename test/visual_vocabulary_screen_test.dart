import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/screens/visual_vocabulary_screen.dart';
void main(){
 testWidgets('visual vocabulary practice opens and displays picture choices',(tester) async {
  await tester.view.setPhysicalSize(const Size(1200,1800));
  await tester.view.setDevicePixelRatio(1);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const MaterialApp(home:VisualVocabularyScreen()));
  await tester.pumpAndSettle();
  expect(find.text('اختر الكلمة التركية المناسبة للصورة'),findsOneWidget);
  expect(find.text('تدرب على القراءة'),findsOneWidget);
 });
}