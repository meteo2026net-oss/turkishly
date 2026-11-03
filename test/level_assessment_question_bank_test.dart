import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/data/b1_course_data.dart';
import 'package:turkishly/data/b2_course_data.dart';
import 'package:turkishly/data/c1_course_data.dart';
import 'package:turkishly/data/c2_course_data.dart';
import 'package:turkishly/data/course_catalog.dart';
import 'package:turkishly/screens/course_lesson_screen.dart';

void main() {
  group('Level assessment question banks', () {
    test('every CEFR level has at least ten valid questions from its own lessons', () {
      for (final level in CourseCatalog.levels) {
        var questionCount = 0;
        final units = CourseCatalog.units.where((unit) => unit.level == level);

        for (final unit in units) {
          for (var index = 0; index < unit.lessons.length; index++) {
            if (level == 'A1' || level == 'A2') {
              final lesson = LessonContent.find(unit.id, index);
              expect(lesson, isNotNull, reason: '${unit.id}-${index + 1}');
              if (lesson == null) continue;

              questionCount++;
              _expectValidQuestion(
                lesson.question,
                lesson.options,
                lesson.answer,
                lesson.feedback,
                '${unit.id}-${index + 1}',
              );
              continue;
            }

            final lesson = switch (level) {
              'B1' => B1CourseData.find(unit.id, index + 1),
              'B2' => B2CourseData.find(unit.id, index + 1),
              'C1' => C1CourseData.find(unit.id, index + 1),
              'C2' => C2CourseData.find(unit.id, index + 1),
              _ => null,
            };

            expect(lesson, isNotNull, reason: '${unit.id}-${index + 1}');
            if (lesson == null) continue;
            expect(lesson.questions, isNotEmpty, reason: '${unit.id}-${index + 1}');

            for (final question in lesson.questions) {
              questionCount++;
              _expectValidQuestion(
                question.prompt,
                question.options,
                question.answer,
                question.explanation,
                '${unit.id}-${index + 1}',
              );
            }
          }
        }

        expect(
          questionCount,
          greaterThanOrEqualTo(10),
          reason: 'The $level diagnostic bank must contain at least ten questions.',
        );
      }
    });
  });
}

void _expectValidQuestion(
  String prompt,
  List<String> options,
  int answer,
  String explanation,
  String lessonId,
) {
  expect(prompt.trim(), isNotEmpty, reason: lessonId);
  expect(options, hasLength(4), reason: lessonId);
  expect(options.every((option) => option.trim().isNotEmpty), isTrue, reason: lessonId);
  expect(options.toSet(), hasLength(4), reason: 'Duplicate choices in $lessonId');
  expect(answer, inInclusiveRange(0, 3), reason: lessonId);
  expect(explanation.trim(), isNotEmpty, reason: lessonId);
}
