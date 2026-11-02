import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/data/b1_course_data.dart';
import 'package:turkishly/data/c2_course_data.dart';
import 'package:turkishly/data/course_catalog.dart';

void main() {
  group('C2 lessons 571-600', () {
    final batch = C2CourseData.lessons
        .where((lesson) => lesson.globalNumber >= 571 && lesson.globalNumber <= 600)
        .toList();

    test('C2 now contains 210 lessons with continuous global numbering', () {
      expect(C2CourseData.lessons, hasLength(510));
      expect(batch, hasLength(30));
      expect(
        batch.map((lesson) => lesson.globalNumber).toList()..sort(),
        List<int>.generate(30, (index) => 571 + index),
      );
    });

    test('new C2 units expose ten correctly numbered lessons each', () {
      for (var unitNumber = 16; unitNumber <= 18; unitNumber++) {
        final id = 'c2-u$unitNumber';
        final unit = CourseCatalog.units.firstWhere((item) => item.id == id);
        expect(unit.level, 'C2');
        expect(unit.lessons, hasLength(10));
        for (var lessonNumber = 1; lessonNumber <= 10; lessonNumber++) {
          final lesson = C2CourseData.find(id, lessonNumber);
          expect(lesson, isNotNull, reason: '$id lesson $lessonNumber');
          expect(lesson!.lessonNumber, lessonNumber);
        }
      }
    });

    test('all lessons contain complete learning content and five valid MCQs', () {
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

    test('every lesson uses the shared B1 lesson model', () {
      expect(batch.every((lesson) => lesson is B1Lesson), isTrue);
    });
  });
}
