# ASD-STE100 style for the spec and the stakeholder PDF

Apply it to prose, table cells, headings, diagram labels and captions.

The standard's approved dictionary is not embedded. Apply the rules below, choose common simple words, and do not say the text is "STE compliant".

## Classify each passage first

- **Procedural text** (steps, instructions, acceptance steps): imperative mood, **20 words or fewer** per sentence, one instruction per sentence (unless the actions happen at the same time). Put the condition before the instruction.
- **Descriptive text** (current state, rationale, impact, boundaries): simple tenses, **25 words or fewer** per sentence, one topic per paragraph.
- Do not mix the two in one passage.
- Treat each Given/When/Then cell as procedural text of 20 words or fewer.

## Rules

1. **Paragraphs:** six sentences or fewer.
2. **Active voice.** Name the actor: "The scheduler calls `retryJob`", not "`retryJob` is called".
3. **Simple tenses.** Use the simple present for facts. Use the simple past or future only when time matters.
4. **No -ing forms as nouns or as filler verbs.** Write "Open the file", not "Opening the file".
5. **One word, one meaning.** Pick one word for each idea and keep it through the whole document. Do not rotate synonyms.
6. **Noun chains of three words or fewer.** Break a longer chain with a preposition.
7. **Use articles** (a, an, the). Do not drop them to save space.
8. **No contractions, no idioms, no filler** ("basically", "simply", "of course").

## What stays exact

- Code, identifiers, file paths, `file:line` references, config keys and values stay exact and in code font. They are technical names. Do not simplify them.
- Define each domain term once at its first use (for example `grace period`), then use it the same way every time. A defined term is a technical name and is exempt from rule 4, even when it ends in -ing.
- Quote the **source request** verbatim, in its original language, even when it is not English. Everything else is STE.

## Check before you hand over

Count the words of every sentence against the limits above. Look for passive voice, -ing forms, synonym rotation, and noun chains longer than three words. Fix what you find.
