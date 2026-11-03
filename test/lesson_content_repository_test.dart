import 'package:flutter_test/flutter_test.dart';

import 'package:turkishly/services/lesson_content_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every catalog lesson loads from its own JSON file', () async {
    final catalog = await LessonContentRepository.loadCatalog();
    final units = catalog['units'] as List<dynamic>;
    final displayedUnits = await LessonContentRepository.loadUnits();
    expect(displayedUnits.length, units.length);
    var loaded = 0;

    for (final rawUnit in units) {
      final unit = Map<String, dynamic>.from(rawUnit as Map);
      final unitId = unit['id'] as String;
      final lessons = unit['lessons'] as List<dynamic>;

      for (final rawLesson in lessons) {
        final lesson = Map<String, dynamic>.from(rawLesson as Map);
        final order = (lesson['order'] as num).toInt();
        final record = await LessonContentRepository.loadLesson(unitId, order);

        expect(record.id, lesson['id']);
        expect(record.unitId, unitId);
        expect(record.contentStatus, 'full');
        expect(record.titleArabic, isNotEmpty);
        expect(record.questions, isNotEmpty);

        for (final question in record.questions) {
          expect(question.options.length, greaterThanOrEqualTo(2));
          expect(question.answerIndex, inInclusiveRange(0, question.options.length - 1));
        }
        loaded++;
      }
    }

    expect(loaded, catalog['declaredLessonCount']);
  });
}
