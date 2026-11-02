import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/data/b2_course_data.dart';
import 'package:turkishly/data/course_catalog.dart';

void main() {
  group('B2 curriculum', () {
    test('contains lessons 181 through 300 exactly once', () {
      final lessons = B2CourseData.lessons;
      expect(lessons, hasLength(120));
      final numbers = lessons.map((e) => e.globalNumber).toList()..sort();
      expect(numbers, List<int>.generate(120, (i) => i + 181));
      expect(lessons.map((e) => e.globalNumber).toSet(), hasLength(30));
    });

    test('contains twelve catalog units with ten lessons each', () {
      for (var i = 1; i <= 12; i++) {
        final id = 'b2-u$i';
        final unit = CourseCatalog.units.firstWhere((e) => e.id == id);
        expect(unit.level, 'B2');
        expect(unit.lessons, hasLength(10));
        for (var j = 1; j <= 10; j++) {
          expect(B2CourseData.find(id, j), isNotNull);
        }
      }
    });

    test('every lesson has five four-choice questions with explanations', () {
      for (final lesson in B2CourseData.lessons) {
        expect(lesson.questions, hasLength(5));
        for (final q in lesson.questions) {
          expect(q.options, hasLength(4));
          expect(q.answer, inInclusiveRange(0, 3));
          expect(q.explanation, isNotEmpty);
        }
      }
    });

    test('every lesson has examples, dialogue and an output task', () {
      for (final lesson in B2CourseData.lessons) {
        expect(lesson.examples, isNotEmpty);
        expect(lesson.dialogue, isNotEmpty);
        expect(lesson.speakingTask, isNotEmpty);
      }
    });
  });
}
