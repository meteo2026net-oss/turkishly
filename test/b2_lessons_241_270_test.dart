import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/data/b2_course_data.dart';
import 'package:turkishly/data/course_catalog.dart';

void main() {
  group('B2 lessons 241-270', () {
    test('all thirty lessons exist with unique global numbers', () {
      final lessons = B2CourseData.lessons.where((e) => e.globalNumber >= 241 && e.globalNumber <= 270).toList();
      expect(lessons, hasLength(30));
      expect(lessons.map((e) => e.globalNumber).toSet(), hasLength(30));
    });
    test('units seven through nine expose ten lessons each', () {
      for (var i = 7; i <= 9; i++) {
        final unit = CourseCatalog.units.firstWhere((e) => e.id == 'b2-u$i');
        expect(unit.level, 'B2');
        expect(unit.lessons, hasLength(10));
        for (var j = 1; j <= 10; j++) {
          expect(B2CourseData.find('b2-u$i', j), isNotNull);
        }
      }
    });
    test('every lesson has five complete multiple choice questions', () {
      for (final lesson in B2CourseData.lessons.where((e) => e.globalNumber >= 241 && e.globalNumber <= 270)) {
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
