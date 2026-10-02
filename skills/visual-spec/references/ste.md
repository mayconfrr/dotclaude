# ASD-STE100 style for the spec and the stakeholder PDF

Write the first pass of both documents in ASD-STE100 Simplified Technical English. English is the working language of the first pass. Translation into another language comes later, on request, from this text.

This file holds the writing rules. The standard also has an approved dictionary. This skill does not embed it. Apply the rules below, choose common simple words, and do not say the text is "STE compliant".

## Classify each passage first

- **Procedural text** (steps, instructions, acceptance steps): imperative mood, **20 words or fewer** per sentence, one instruction per sentence. Put the condition before the instruction.
- **Descriptive text** (current state, rationale, impact, boundaries): simple tenses, **25 words or fewer** per sentence, one topic per paragraph.
- Do not mix the two in one passage.

## Rules

1. **Paragraphs:** six sentences or fewer.
2. **Active voice.** Name the actor: "The listener calls `fillFields`", not "`fillFields` is called".
3. **Simple tenses.** Use the simple present for facts. Use the simple past or future only when time matters.
4. **No -ing forms as nouns or as filler verbs.** Write "Open the file", not "Opening the file".
5. **One word, one meaning.** Pick one word for each idea and keep it through the whole document. Do not rotate synonyms.
6. **Noun chains of three words or fewer.** Break a longer chain with a preposition.
7. **Use articles** (a, an, the). Do not drop them to save space.
8. **No contractions, no idioms, no filler** ("basically", "simply", "of course").
9. **One instruction per sentence**, unless the actions happen at the same time.

## What stays exact

- Code, identifiers, file paths, `file:line` references, config keys and values stay exact and in code font. They are technical names. Do not simplify them.
- Define each domain term once at its first use (for example `parecer`, `teto`), then use it the same way every time. A defined term is a technical name.
- Quote the **source request** verbatim, in its original language, even when it is not English. Everything else is STE.

## Check before you hand over

Count the words of every sentence in procedural text (limit 20) and descriptive text (limit 25). Look for passive voice, -ing forms, synonym rotation, and noun chains longer than three words. Fix what you find.
