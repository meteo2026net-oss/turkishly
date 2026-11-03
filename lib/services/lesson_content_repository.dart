import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/course_unit.dart';

class LessonQuestionRecord {
  const LessonQuestionRecord({
    required this.id,
    required this.prompt,
    required this.options,
    required this.answerIndex,
    required this.explanation,
  });

  final String id;
  final String prompt;
  final List<String> options;
  final int answerIndex;
  final String explanation;

  factory LessonQuestionRecord.fromJson(Map<String, dynamic> json) {
    final options = (json['options'] as List<dynamic>? ?? const [])
        .map((value) => value.toString())
        .toList(growable: false);
    final answerIndex = (json['answerIndex'] as num?)?.toInt() ?? 0;
    if (options.length < 2 || answerIndex < 0 || answerIndex >= options.length) {
      throw FormatException('Invalid answer options for question ${json['id']}.');
    }
    return LessonQuestionRecord(
      id: json['id']?.toString() ?? '',
      prompt: json['prompt']?.toString() ?? '',
      options: options,
      answerIndex: answerIndex,
      explanation: json['explanation']?.toString() ?? '',
    );
  }
}

class LessonExampleRecord {
  const LessonExampleRecord({required this.turkish, required this.arabic});
  final String turkish;
  final String arabic;

  factory LessonExampleRecord.fromJson(Map<String, dynamic> json) =>
      LessonExampleRecord(
        turkish: json['tr']?.toString() ?? '',
        arabic: json['ar']?.toString() ?? '',
      );
}

class LessonDialogueLine {
  const LessonDialogueLine({
    required this.speaker,
    required this.turkish,
    required this.arabic,
  });
  final String speaker;
  final String turkish;
  final String arabic;

  factory LessonDialogueLine.fromJson(Map<String, dynamic> json) =>
      LessonDialogueLine(
        speaker: json['speaker']?.toString() ?? '',
        turkish: json['tr']?.toString() ?? '',
        arabic: json['ar']?.toString() ?? '',
      );
}

class LessonRecord {
  const LessonRecord({
    required this.id,
    required this.level,
    required this.unitId,
    required this.order,
    required this.titleArabic,
    required this.titleTurkish,
    required this.contentStatus,
    required this.goal,
    required this.rule,
    required this.examples,
    required this.dialogue,
    required this.speakingTask,
    required this.questions,
  });

  final String id;
  final String level;
  final String unitId;
  final int order;
  final String titleArabic;
  final String titleTurkish;
  final String contentStatus;
  final String goal;
  final String rule;
  final List<LessonExampleRecord> examples;
  final List<LessonDialogueLine> dialogue;
  final String speakingTask;
  final List<LessonQuestionRecord> questions;

  factory LessonRecord.fromJson(Map<String, dynamic> json) {
    final title = Map<String, dynamic>.from(json['title'] as Map? ?? const {});
    return LessonRecord(
      id: json['id']?.toString() ?? '',
      level: json['level']?.toString() ?? '',
      unitId: json['unitId']?.toString() ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      titleArabic: title['ar']?.toString() ?? '',
      titleTurkish: title['tr']?.toString() ?? '',
      contentStatus: json['contentStatus']?.toString() ?? 'metadata_only',
      goal: json['goal']?.toString() ?? '',
      rule: json['rule']?.toString() ?? '',
      examples: (json['examples'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((value) => LessonExampleRecord.fromJson(
                Map<String, dynamic>.from(value),
              ))
          .toList(growable: false),
      dialogue: (json['dialogue'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((value) => LessonDialogueLine.fromJson(
                Map<String, dynamic>.from(value),
              ))
          .toList(growable: false),
      speakingTask: json['speakingTask']?.toString() ?? '',
      questions: (json['questions'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((value) => LessonQuestionRecord.fromJson(
                Map<String, dynamic>.from(value),
              ))
          .toList(growable: false),
    );
  }
}

class LessonContentRepository {
  LessonContentRepository._();

  static const _catalogAsset = 'content/catalog.json';
  static Future<Map<String, dynamic>>? _catalogCache;

  static Future<Map<String, dynamic>> loadCatalog() {
    return _catalogCache ??= _readCatalog();
  }

  static Future<Map<String, dynamic>> _readCatalog() async {
    final source = await rootBundle.loadString(_catalogAsset);
    return Map<String, dynamic>.from(jsonDecode(source) as Map);
  }


  static Future<List<CourseUnit>> loadUnits() async {
    final catalog = await loadCatalog();
    final units = catalog['units'] as List<dynamic>? ?? const [];
    return Future.wait(units.whereType<Map>().map((rawUnit) async {
      final unit = Map<String, dynamic>.from(rawUnit);
      final title = Map<String, dynamic>.from(unit['title'] as Map? ?? const {});
      final lessons = unit['lessons'] as List<dynamic>? ?? const [];
      final lessonTitles = await Future.wait(lessons.whereType<Map>().map((rawLesson) async {
        final lesson = Map<String, dynamic>.from(rawLesson);
        final id = lesson['id']?.toString() ?? '';
        final path = 'content/lessons/${unit['level']}/${unit['id']}/$id.json';
        final source = await rootBundle.loadString(path);
        final record = Map<String, dynamic>.from(jsonDecode(source) as Map);
        final lessonTitle = Map<String, dynamic>.from(record['title'] as Map? ?? const {});
        return lessonTitle['ar']?.toString() ?? '';
      }));
      return CourseUnit(
        id: unit['id']?.toString() ?? '',
        level: unit['level']?.toString() ?? '',
        titleArabic: title['ar']?.toString() ?? '',
        titleTurkish: title['tr']?.toString() ?? '',
        description: unit['description']?.toString() ?? '',
        lessons: lessonTitles,
      );
    }));
  }

  static Future<LessonRecord> loadLesson(String unitId, int lessonOrder) async {
    final catalog = await loadCatalog();
    final units = catalog['units'] as List<dynamic>? ?? const [];
    for (final rawUnit in units.whereType<Map>()) {
      final unit = Map<String, dynamic>.from(rawUnit);
      if (unit['id'] != unitId) continue;
      final lessons = unit['lessons'] as List<dynamic>? ?? const [];
      for (final rawLesson in lessons.whereType<Map>()) {
        final lesson = Map<String, dynamic>.from(rawLesson);
        if ((lesson['order'] as num?)?.toInt() != lessonOrder) continue;
        final id = lesson['id']?.toString() ?? '';
        final level = unit['level']?.toString() ?? '';
        final path = 'content/lessons/$level/$unitId/$id.json';
        final source = await rootBundle.loadString(path);
        final record = LessonRecord.fromJson(
          Map<String, dynamic>.from(jsonDecode(source) as Map),
        );
        if (record.contentStatus != 'full') {
          throw StateError('Lesson $id is not fully migrated yet.');
        }
        return record;
      }
    }
    throw StateError('Lesson $unitId-$lessonOrder was not found in the JSON catalog.');
  }
}
