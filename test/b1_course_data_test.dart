import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/data/b1_course_data.dart';

void main() {
  group('B1 course curriculum', () {
    test('contains all 60 lessons numbered from 121 to 180', () {
      final lessons = B1CourseData.lessons;
      expect(lessons, hasLength(60));
      final numbers = lessons.map((lesson) => lesson.globalNumber).toList()..sort();
      expect(numbers, List<int>.generate(60, (index) => index + 121));
    });

    test('contains six units with ten lessons each and correct local indexes', () {
      for (var unit = 1; unit <= 6; unit++) {
        final unitId = 'b1-u$unit';
        final lessons = B1CourseData.lessons
            .where((lesson) => lesson.unitId == unitId)
            .toList()
          ..sort((a, b) => a.lessonNumber.compareTo(b.lessonNumber));
        expect(lessons, hasLength(10), reason: unitId);
        expect(
          lessons.map((lesson) => lesson.lessonNumber).toList(),
          List<int>.generate(10, (index) => index + 1),
          reason: unitId,
        );
      }
    });

    test('every lesson has five four-option questions with valid answer indexes', () {
      for (final lesson in B1CourseData.lessons) {
        expect(lesson.questions, hasLength(5), reason: 'Lesson ${lesson.globalNumber}');
        for (final question in lesson.questions) {
          expect(question.options, hasLength(4));
          expect(question.answer, inInclusiveRange(0, 3));
          expect(question.explanation, isNotEmpty);
        }
      }
    });

    test('every lesson includes examples, a dialogue and a speaking task', () {
      for (final lesson in B1CourseData.lessons) {
        expect(lesson.examples, isNotEmpty, reason: 'Lesson ${lesson.globalNumber}');
        expect(lesson.dialogue, isNotEmpty);
        expect(lesson.speakingTask, isNotEmpty);
      }
    });
  });
}
