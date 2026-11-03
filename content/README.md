# Turkishly JSON lesson content

The JSON directory is the canonical lesson-content source. The Flutter app reads unit names, lesson display titles, ordering and lesson records through `LessonContentRepository`; the home curriculum opens the JSON-driven lesson screen.

## Layout

`lessons/<LEVEL>/<unit-id>/<lesson-id>.json`

- Every one of the 1,272 lessons in the canonical catalog has a separate JSON file.
- Stable IDs and file paths are independent from display names. Rename a lesson by editing `title.ar` or `title.tr`; do not rename the ID for an ordinary title change.
- Lesson records contain goals, explanations, vocabulary where available, examples, dialogue, speaking tasks, quiz options, answer indexes and explanations.
- `catalog.json` controls unit ordering and maps each lesson to its JSON file.
- `schema/lesson.schema.json` describes the record format.

## Migration status

All 1,272 canonical catalog lessons are marked `contentStatus: "full"`. Existing Dart curriculum files and the former lesson screens are retained unchanged as a rollback/reference source. The legacy B2 Dart data includes 60 additional lesson definitions with unit IDs absent from the canonical 60-lesson B2 catalog; those unlinked definitions are preserved in the legacy source and are not part of the canonical JSON catalog.

## Media

Lesson JSON may refer to image, audio or video files by relative path or stable asset ID. Keep binary files under the media asset tree rather than embedding base64 in JSON.

## Validation

The Flutter app bundles `content/catalog.json` and `content/lessons/`. A repository test loads every catalog lesson and checks record identity, completion status, question presence and answer-index bounds. Legacy Dart files remain in place; do not remove them until CI and device/web validation are successful.
