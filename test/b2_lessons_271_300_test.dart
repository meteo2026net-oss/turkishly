import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/data/b2_course_data.dart';
import 'package:turkishly/data/course_catalog.dart';

void main() {
  group('B2 lessons 271-300', () {
    test('B2 lesson content has usable examples and speaking tasks', () {
      for (final lesson in B2CourseData.lessons.where((e) => e.globalNumber >= 181 && e.globalNumber <= 300)) {
        expect(lesson.examples, isNotEmpty);
        expect(lesson.examples.every((example) => example.trim().isNotEmpty), isTrue);
        expect(lesson.speakingTask.trim(), isNotEmpty);
      }
    });
    test('thirty lessons are present with unique global numbers', () {
      final lessons = B2CourseData.lessons.where((e) => e.globalNumber >= 271 && e.globalNumber <= 300).toList();
      expect(lessons, hasLength(30));
      expect(lessons.map((e) => e.globalNumber).toSet(), hasLength(30));
    });
    test('units ten through twelve contain ten accessible lessons', () {
      for (var i = 10; i <= 12; i++) {
        final unit = CourseCatalog.units.firstWhere((e) => e.id == 'b2-u$i');
        expect(unit.level, 'B2');
        expect(unit.lessons, hasLength(10));
        for (var j = 1; j <= 10; j++) {
          expect(B2CourseData.find('b2-u$i', j), isNotNull);
        }
      }
    });
    test('each lesson has five valid four-choice questions', () {
      for (final lesson in B2CourseData.lessons.where((e) => e.globalNumber >= 271 && e.globalNumber <= 300)) {
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
