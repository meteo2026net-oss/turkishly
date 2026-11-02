import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/data/b1_course_data.dart';
import 'package:turkishly/data/b2_course_data.dart';
import 'package:turkishly/data/c1_course_data.dart';
import 'package:turkishly/data/c2_course_data.dart';
import 'package:turkishly/data/course_catalog.dart';
import 'package:turkishly/screens/course_lesson_screen.dart';

void main() {
  group('Complete curriculum integrity', () {
    test('keeps the six CEFR levels and all 136 units in the catalog', () {
      expect(CourseCatalog.levels, ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']);
      expect(CourseCatalog.units, hasLength(136));

      final unitIds = CourseCatalog.units.map((unit) => unit.id).toList();
      expect(unitIds.toSet(), hasLength(unitIds.length));

      const expectedUnits = <String, int>{
        'A1': 20,
        'A2': 8,
        'B1': 6,
        'B2': 12,
        'C1': 12,
        'C2': 78,
      };
      for (final entry in expectedUnits.entries) {
        expect(
          CourseCatalog.units.where((unit) => unit.level == entry.key),
          hasLength(entry.value),
          reason: 'Unexpected unit count for ${entry.key}',
        );
      }
    });

    test('keeps all 1,332 catalog lessons connected to authored lesson content', () {
      const expectedLessons = <String, int>{
        'A1': 180,
        'A2': 72,
        'B1': 60,
        'B2': 120,
        'C1': 120,
        'C2': 780,
      };

      var total = 0;
      final lessonIds = <String>{};
      for (final unit in CourseCatalog.units) {
        expect(unit.lessons, isNotEmpty, reason: unit.id);
        total += unit.lessons.length;

        for (var index = 0; index < unit.lessons.length; index++) {
          final lessonId = '${unit.id}-${index + 1}';
          expect(lessonIds.add(lessonId), isTrue, reason: 'Duplicate lesson ID: $lessonId');

          switch (unit.level) {
            case 'A1':
            case 'A2':
              expect(
                LessonContent.find(unit.id, index),
                isNotNull,
                reason: 'Missing lesson content: $lessonId',
              );
              break;
            case 'B1':
              expect(B1CourseData.find(unit.id, index + 1), isNotNull, reason: lessonId);
              break;
            case 'B2':
              expect(B2CourseData.find(unit.id, index + 1), isNotNull, reason: lessonId);
              break;
            case 'C1':
              expect(C1CourseData.find(unit.id, index + 1), isNotNull, reason: lessonId);
              break;
            case 'C2':
              expect(C2CourseData.find(unit.id, index + 1), isNotNull, reason: lessonId);
              break;
            default:
              fail('Unsupported curriculum level: ${unit.level}');
          }
        }
      }

      expect(total, 1332);
      expect(lessonIds, hasLength(1332));
      for (final entry in expectedLessons.entries) {
        final levelTotal = CourseCatalog.units
            .where((unit) => unit.level == entry.key)
            .fold<int>(0, (sum, unit) => sum + unit.lessons.length);
        expect(levelTotal, entry.value, reason: 'Unexpected lesson count for ${entry.key}');
      }
    });

    test('keeps lesson assessment payloads usable', () {
      for (final unit in CourseCatalog.units) {
        for (var index = 0; index < unit.lessons.length; index++) {
          final Object? content = switch (unit.level) {
            'A1' || 'A2' => LessonContent.find(unit.id, index),
            'B1' => B1CourseData.find(unit.id, index + 1),
            'B2' => B2CourseData.find(unit.id, index + 1),
            'C1' => C1CourseData.find(unit.id, index + 1),
            'C2' => C2CourseData.find(unit.id, index + 1),
            _ => null,
          };
          expect(content, isNotNull, reason: '${unit.id}-${index + 1}');
          if (content is LessonContent) {
            expect(content.goal.trim(), isNotEmpty);
            expect(content.explanation.trim(), isNotEmpty);
            expect(content.examples, isNotEmpty);
            expect(content.options, hasLength(4));
            expect(content.answer, inInclusiveRange(0, 3));
            expect(content.feedback.trim(), isNotEmpty);
          } else if (content is B1Lesson) {
            expect(content.goal.trim(), isNotEmpty);
            expect(content.rule.trim(), isNotEmpty);
            expect(content.examples, isNotEmpty);
            expect(content.questions, isNotEmpty);
            for (final question in content.questions) {
              expect(question.options, hasLength(4));
              expect(question.answer, inInclusiveRange(0, 3));
              expect(question.explanation.trim(), isNotEmpty);
            }
          } else {
            fail('Unsupported lesson payload type for ${unit.id}-${index + 1}');
          }
        }
      }
    });
  });
}
