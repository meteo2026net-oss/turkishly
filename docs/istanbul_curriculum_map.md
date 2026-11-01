# Turkishly — İstanbul Aligned Curriculum

## Editorial policy
Turkishly follows the unit sequence and communicative progression of the İstanbul Yabancılar İçin Türkçe course, while all explanations, examples, dialogues, exercises, illustrations and assessments are newly authored for Turkishly. This is a curriculum alignment, not a reproduction of textbook pages or copyrighted lesson text.

The exact scope below is the six-unit A1/A2 table of contents reviewed for this project. Before publishing later levels, verify the corresponding edition and contents rather than assuming every edition is identical.

## A1 — İstanbul sequence

| Unit | İstanbul unit | Communicative themes | Turkishly development |
|---|---|---|---|
| 1 | MERHABA | Greetings, introductions, alphabet, asking who/what | Turkish sounds and spelling; greetings; names, countries and languages; personal information; classroom mini-dialogues |
| 2 | NEREDE? | At school, numbers, in the city | Numbers and contact details; classroom objects; places in town; asking where; simple location and direction tasks |
| 3 | NE YAPIYORSUN? | Daily life, free time, a tour of Istanbul | Present continuous in context; daily routines; hobbies; invitations; describing a simple city visit |
| 4 | BENİM DÜNYAM | Family, friends, away from family | Family and relationships; possessive forms; describing people; belongings; short personal profiles |
| 5 | ZAMAN ZAMAN | Clock time, holidays, special occasions | Telling time; dates and calendars; days and months; arranging meetings; celebrations and invitations |
| 6 | ÇEVREMİZ VE BİZ | Family/relatives, where, our bodies | Relatives and relationships; body vocabulary; location questions; describing people and surroundings; integrated A1 review |

### A1 learning design
Every unit contains nine learning steps:
1. Visual vocabulary introduction
2. Core phrases and pronunciation
3. Grammar discovery with a short Arabic explanation
4. Guided examples (Turkish + Arabic meaning)
5. Listening/reading-style dialogue authored for Turkishly
6. Controlled practice
7. Real-life communication task
8. Mixed skills practice
9. Unit review and assessment

## A2 — İstanbul sequence

| Unit | İstanbul unit | Communicative themes | Turkishly development |
|---|---|---|---|
| 1 | GEZELİM GÖRELİM | In the kitchen, at a restaurant, on the internet | Food and kitchen vocabulary; restaurant interaction; imperative; request/desire forms; word-building patterns |
| 2 | HABERİNİZ OLSUN | Inventions, last weekend, news | Describing inventions; past experiences; definite past; past in nominal sentences; cause/result connectors; ile |
| 3 | NELER OLACAK? | Future plans, where to go, weather | Future tense; planning and predictions; weather; future nominal sentences; comparisons with gibi/kadar |
| 4 | EVVEL ZAMAN İÇİNDE | Who did what, stories and legends, jokes | Reported past; storytelling sequence; intensifying and diminutive forms; diye; paired alternatives and conjunctions |
| 5 | NE OLUR NE OLMAZ | Natural phenomena, habits and requests, summaries | Aorist (geniş zaman); habits and general truths; polite requests; -DIr in common contexts |
| 6 | NELER YAPABİLİRSİNİZ? | Abilities, polite requests, visitor activities | Ability -(y)Abil; polite requests and possibilities; verbal connectors -(y)Ip and -mAdAn; practical visitor tasks |

### A2 learning design
Each unit uses the same nine-step rhythm as A1, with longer texts, richer dialogues, integrated grammar, and more open-ended speaking/writing tasks.

## Existing Turkishly material: migration policy
- Preserve the existing A1/A2 lesson content and identifiers during the transition.
- Do not delete or silently overwrite the current 20-unit-per-level pathway.
- Reclassify useful existing lessons into the İstanbul-aligned units, rewrite or supplement gaps, and retain unrelated enrichment as a clearly labelled Turkishly Extra track.
- Keep lesson IDs stable until all navigation, progress tracking and assessment references have been migrated and verified.
- A unit must not be marked complete merely because its content has been drafted; completion requires all nine lessons, practice and review to be checked.

## Original visual identity and image plan
All instructional visuals must be commissioned/generated specifically for Turkishly:
- Original scene illustrations for each unit (not scans, screenshots, covers or copied figures from İstanbul).
- Custom vocabulary picture sets with consistent characters, palette and art direction.
- Grammar diagrams and visual examples designed from scratch.
- Unit-specific cover art and lesson thumbnails, with accessible descriptions.
- No third-party textbook page images and no unlicensed stock-image reuse.

### Visual production specification
- Art direction: warm modern editorial illustration, clean shapes, soft natural lighting, culturally respectful everyday settings in Türkiye.
- Brand palette: ivory #F7F5EF, Turkishly green #31805C, deep green #203B30, pale green #DDECE0.
- Composition: landscape 16:9 for unit covers; square 1:1 for vocabulary cards; leave uncluttered space for labels when needed.
- Avoid embedding long text in images. Turkish words and Arabic translations remain editable Flutter text.
- Store assets under `assets/images/curriculum/<level>/<unit-id>/` and register them in `pubspec.yaml`.
- Use descriptive filenames and provide alt-text/semantic descriptions in lesson metadata.

## Release gates
1. Approve the curriculum map and lesson outcomes.
2. Map legacy lessons to the new sequence without breaking IDs.
3. Write and review all nine lessons for the first unit.
4. Produce the original unit cover and vocabulary illustrations.
5. Integrate the unit into Flutter and verify navigation, RTL/LTR text, and progress state.
6. Repeat unit by unit.
