# Turkishly JSON lesson content

The JSON directory is the canonical lesson-content source. The Flutter app reads unit metadata, lesson names, ordering and lesson bodies through `LessonContentRepository`; the home curriculum opens the JSON-driven lesson screen.

## Layout

`lessons/<LEVEL>/<unit-id>/<lesson-id>.json`

- Every one of the **1,332 lessons across 136 units** has its own JSON file.
- The lesson JSON file is the single source of truth for its display name. New records use `title.ar` and `title.tr` strings; the early A1/A2 migration records retain their original nested `title.ar.titleAr` shape for backward compatibility. The reader accepts both forms. Edit the Arabic title in the record itself; keep the stable `id` and file path unchanged. Keep the stable `id` and file path unchanged.
- `catalog.json` stores unit ordering and references each lesson by stable ID and order; it does not duplicate lesson titles.
- Lesson records contain goals, explanations, vocabulary where available, examples, dialogue, speaking tasks, quiz options, answer indexes and explanations.
- `schema/lesson.schema.json` describes the record format.

## Migration status

All 1,332 canonical catalog lessons are marked `contentStatus: "full"`. All original Dart curriculum files and former lesson screens are retained unchanged as a rollback/reference source.

## Media

Lesson JSON may refer to image, audio or video files by relative path or stable asset ID. Keep binary files under the media asset tree rather than embedding base64 in JSON.

## Validation

The Flutter app bundles `content/catalog.json` and each of the 136 unit directories. A repository test loads every catalog lesson, checks record identity and answer indexes, and confirms that displayed lesson names come from the corresponding lesson JSON files. Legacy Dart files remain in place until all builds are reviewed.
