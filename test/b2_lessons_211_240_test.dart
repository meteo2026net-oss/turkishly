import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/data/b2_course_data.dart';
import 'package:turkishly/data/course_catalog.dart';

void main() {
  group('B2 lessons 181-240', () {
    test('all thirty new lessons are present exactly once', () {
      final lessons = B2CourseData.lessons.where((e) => e.globalNumber >= 211 && e.globalNumber <= 240).toList();
      expect(lessons, hasLength(30));
      expect(lessons.map((e) => e.globalNumber).toSet(), hasLength(30));
    });
    test('units four to six contain ten lessons each', () {
      for (var i = 4; i <= 6; i++) {
        final unit = CourseCatalog.units.firstWhere((e) => e.id == 'b2-u$i');
        expect(unit.level, 'B2');
        expect(unit.lessons, hasLength(10));
        for (var j = 1; j <= 10; j++) {
          expect(B2CourseData.find('b2-u$i', j), isNotNull);
        }
      }
    });
    test('each new lesson has five four-option questions', () {
      for (final lesson in B2CourseData.lessons.where((e) => e.globalNumber >= 211)) {
        expect(lesson.questions, hasLength(5));
        for (final question in lesson.questions) {
          expect(question.options, hasLength(4));
          expect(question.answer, inInclusiveRange(0, 3));
          expect(question.explanation, isNotEmpty);
        }
      }
    });
  });
}
