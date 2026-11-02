import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/data/c2_course_data.dart';
import 'package:turkishly/data/course_catalog.dart';

void main() {
  group('C2 lessons 601-630', () {
    final batch = C2CourseData.lessons.where((lesson) =>
      lesson.globalNumber >= 601 && lesson.globalNumber <= 630).toList();

    test('C2 contains 210 lessons and the new global range is continuous', () {
      expect(C2CourseData.lessons, hasLength(510));
      expect(batch, hasLength(30));
      expect(batch.map((e) => e.globalNumber).toSet(),
        Set<int>.from(List<int>.generate(30, (i) => 601 + i)));
    });

    test('units 19-21 each expose ten lessons through catalog lookup', () {
      for (var unitNumber = 19; unitNumber <= 21; unitNumber++) {
        final id = 'c2-u$unitNumber';
        final unit = CourseCatalog.units.firstWhere((item) => item.id == id);
        expect(unit.level, 'C2');
        expect(unit.lessons, hasLength(10));
        for (var i = 1; i <= 10; i++) {
          expect(C2CourseData.find(id, i), isNotNull, reason: '$id lesson $i');
        }
      }
    });

    test('all new lessons have complete content and five four-option questions', () {
      for (final lesson in batch) {
        expect(lesson.title, isNotEmpty);
        expect(lesson.goal, isNotEmpty);
        expect(lesson.rule, isNotEmpty);
        expect(lesson.examples, hasLength(2));
        expect(lesson.dialogue, isNotEmpty);
        expect(lesson.speakingTask, isNotEmpty);
        expect(lesson.questions, hasLength(5));
        expect(lesson.questions.map((q) => q.answer).toSet().length, greaterThan(1));
        for (final question in lesson.questions) {
          expect(question.options, hasLength(4));
          expect(question.options.toSet(), hasLength(4));
          expect(question.answer, inInclusiveRange(0, 3));
          expect(question.explanation, isNotEmpty);
        }
      }
    });
  });
}