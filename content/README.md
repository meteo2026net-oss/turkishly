# Turkishly JSON lesson content

The JSON directory is the app's lesson-content source. The Flutter app loads the catalog and lesson records through `LessonContentRepository`; screens render the returned data and keep learning progress locally.

## Layout

`lessons/<LEVEL>/<unit-id>/<lesson-id>.json`

- Each of the 1,272 catalog lessons has its own JSON file.
- Stable IDs and file paths are independent from display names. Rename a lesson by editing `title.ar` or `title.tr`; do not rename the ID for an ordinary title change.
- Lesson files contain the teaching goal, explanation, vocabulary where available, examples, dialogue, speaking task, questions, answer indexes, explanations and media references.
- `catalog.json` controls unit ordering and maps each lesson to its JSON file.
- `schema/lesson.schema.json` describes the record format.

## Migration status

All 1,272 lessons in the canonical catalog have `contentStatus: "full"` and individual JSON records. The original Dart curriculum and legacy lesson screens are retained unchanged as a rollback/reference source. There are also 60 additional B2 lesson definitions in the legacy Dart source whose unit IDs are not present in the canonical catalog; those unlinked records have not been added to the 1,272-lesson catalog.

## Media

Lesson JSON may refer to image, audio or video files by relative path or stable asset ID. Keep binary files under the media asset tree rather than embedding base64 in JSON.

## Validation and safety

Do not delete the legacy Dart files until the JSON loader and UI have passed device/web tests and the old/new lesson counts, question counts and answer indexes have been compared. Do not present a record as complete if it is marked `metadata_only`.
