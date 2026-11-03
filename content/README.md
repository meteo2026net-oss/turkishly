# Turkishly JSON lesson content

Every lesson has its own JSON file under `lessons/<LEVEL>/<unit-id>/<lesson-id>.json`. The stable `id` and file path do not change when the display title is renamed; edit `title.ar` or `title.tr` instead.

## Content states
- `full`: complete lesson body has been migrated and validated, including explanations, examples, dialogue, tasks, and quiz answers.
- `metadata_only`: catalog title and unit metadata have been exported, but the teaching body and assessments still need migration. These records must not be presented as completed lessons.

## Safety of migration
This migration is additive. Existing Dart files, screens, and lesson data remain in place. `catalog.json` preserves all unit and lesson ordering and points to each lesson JSON file. Do not delete legacy sources until parity checks and app-side JSON loading have passed.

Current manifest contains 1,272 catalog lesson records across 130 units. One B1 lesson is fully migrated as a pilot; the remaining files are explicit metadata-only records awaiting complete content export.
