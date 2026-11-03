# Turkishly lesson content

This directory is the canonical, data-only home for lesson content. Flutter screens should render these records; lesson wording and titles must not be hard-coded into presentation widgets.

## Layout

`lessons/<CEFR>/<unit-id>/<lesson-id>.json`

- One lesson per JSON file.
- Each lesson has a stable `id` independent of its editable Arabic and Turkish titles.
- Rename a lesson by changing `title.ar` and/or `title.tr`; do not rename its ID or file as part of an ordinary title edit.
- Keep vocabulary, examples, dialogue, tasks, questions, answers and explanations inside that lesson's JSON record.
- Optional media references are relative paths or stable asset IDs; binary media stays in `assets/media`, not embedded as base64 in lesson JSON.
- Keep unit metadata and display order in `catalog.json`; do not duplicate lesson bodies there.

## Non-destructive migration

The current Dart curriculum files and legacy lesson screens are intentionally retained. Migration is additive: export and validate lesson records into this directory first, compare counts and IDs against the legacy catalog, and only then switch the reader to JSON. Do not delete or rewrite legacy sources as part of content migration.

## Current migration batch

The first record is a pilot conversion of B1 lesson 121. The remaining legacy records are not marked migrated until their complete lesson body and all question data have been exported and validated.
