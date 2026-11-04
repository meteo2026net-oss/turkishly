import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/data/course_catalog.dart';

void main() {
  group('CEFR curriculum catalog integrity', () {
    const expectedUnits = <String, int>{
      'A1': 20,
      'A2': 8,
      'B1': 6,
      'B2': 12,
      'C1': 12,
      'C2': 78,
    };
    const expectedLessons = <String, int>{
      'A1': 180,
      'A2': 72,
      'B1': 60,
      'B2': 120,
      'C1': 120,
      'C2': 780,
    };

    test('contains the documented unit and lesson totals for every level', () {
      expect(CourseCatalog.levels.toSet(), expectedUnits.keys.toSet());
      for (final level in CourseCatalog.levels) {
        final units = CourseCatalog.units.where((unit) => unit.level == level);
        expect(units.length, expectedUnits[level], reason: '$level unit count');
        expect(
          units.fold<int>(0, (total, unit) => total + unit.lessonCount),
          expectedLessons[level],
          reason: '$level lesson count',
        );
      }

      expect(CourseCatalog.units.length, 136);
      expect(
        CourseCatalog.units.fold<int>(
          0,
          (total, unit) => total + unit.lessonCount,
        ),
        1332,
      );
    });

    test('unit identifiers are unique and every unit has complete metadata', () {
      final ids = CourseCatalog.units.map((unit) => unit.id).toList();
      expect(ids.toSet(), hasLength(ids.length));

      for (final unit in CourseCatalog.units) {
        expect(CourseCatalog.levels, contains(unit.level), reason: unit.id);
        expect(unit.id.trim(), isNotEmpty, reason: 'unit id');
        expect(unit.titleArabic.trim(), isNotEmpty, reason: unit.id);
        expect(unit.titleTurkish.trim(), isNotEmpty, reason: unit.id);
        expect(unit.description.trim(), isNotEmpty, reason: unit.id);
        expect(unit.lessons, isNotEmpty, reason: unit.id);
        expect(
          unit.lessons.every((lesson) => lesson.trim().isNotEmpty),
          isTrue,
          reason: 'Empty lesson title in ${unit.id}',
        );
      }
    });

    test('lesson titles are unique within each unit', () {
      for (final unit in CourseCatalog.units) {
        final titles = unit.lessons.toSet();
        expect(
          titles,
          hasLength(unit.lessons.length),
          reason: 'Duplicate lesson title in ${unit.id}',
        );
      }
    });
  });
}
