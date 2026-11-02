import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/data/c1_course_data.dart';
import 'package:turkishly/data/course_catalog.dart';

void main() {
  group('C1 lessons 301-330', () {
    test('all thirty lessons exist with unique global numbers', () {
      final lessons = C1CourseData.lessons;
      expect(lessons, hasLength(30));
      expect(lessons.map((e) => e.globalNumber).toSet(), hasLength(30));
      expect(lessons.map((e) => e.globalNumber).toSet(), containsAll(List.generate(30, (i) => 301 + i)));
    });

    test('three C1 units expose ten lessons each through lookup', () {
      for (var unit = 1; unit <= 3; unit++) {
        final id = 'c1-u$unit';
        final catalogUnit = CourseCatalog.units.firstWhere((e) => e.id == id);
        expect(catalogUnit.level, 'C1');
        expect(catalogUnit.lessons, hasLength(10));
        for (var lesson = 1; lesson <= 10; lesson++) {
          expect(C1CourseData.find(id, lesson), isNotNull, reason: '$id lesson $lesson');
        }
      }
    });

    test('every lesson has five valid multiple-choice questions', () {
      for (final lesson in C1CourseData.lessons) {
        expect(lesson.questions, hasLength(5), reason: lesson.title);
        expect(lesson.examples, hasLength(2), reason: lesson.title);
        expect(lesson.examples.every((e) => e.trim().isNotEmpty), isTrue);
        expect(lesson.dialogue.trim(), isNotEmpty);
        expect(lesson.speakingTask.trim(), isNotEmpty);
        for (final q in lesson.questions) {
          expect(q.options, hasLength(4), reason: q.prompt);
          expect(q.answer, inInclusiveRange(0, 3));
          expect(q.explanation.trim(), isNotEmpty);
        }
      }
    });
  });
}
