---
name: cool-words
description: Generate a list of evocative, atmospheric words tuned to a given context (a project name, a theme, a band, a character, a codebase, a mood), matched to the user's taste for words like cathedral, gothic, celestial, gorgoroth, vestigial. Use when the user invokes /cool-words, asks for "cool words", "words for X", naming ideas with a dark/ornate/ancient feel, or wants vocabulary for a theme.
---

# Cool words

Generate words the user will find cool, filtered through a specific context.

## Arguments

`/cool-words [context]`

- **context**: what the words are for: a theme ("deep sea"), a use ("names for a CLI tool"), a feeling ("cold and abandoned"), or a domain ("networking terms"). If empty, generate a general mixed list in the user's taste.

## The user's taste

Words the user has said they like:

- cathedral
- gothic
- celestial
- gorgoroth
- vestigial

What these have in common, and what to aim for:

- **Weight and sound.** Multi-syllable, sonorous, often with hard consonants or a rolling rhythm (gor-go-roth, ca-the-dral). Words that feel good to say aloud.
- **Ancient, sacred, or monumental.** Medieval architecture, religion, ritual, ruins, things built to outlast people.
- **Dark or vast.** Shadow, decay, the cosmos, the void, mythic evil. Not cute, not cheerful.
- **Remnant and residue.** Things left over from something larger or older (vestigial).
- **Real vocabulary plus invented-sounding names.** Latinate/Greek terms sit next to fantasy proper nouns (Gorgoroth is Tolkien). Both are in scope: real words, mythological and literary names, and archaic or obscure terms.

Avoid: corporate or startup words, generic fantasy filler ("epic", "legendary"), words that are only cool because they are long, and anything already in the list above.

## How to generate

1. Read the context and pick 3 to 5 angles that connect it to the user's taste. For "a database", angles might be: archives and reliquaries, geology and strata, memory and ossuaries, cartography.
2. Generate 25 to 40 words across those angles. Mix registers: common-but-strong words, obscure real words, and proper nouns from myth, literature, astronomy, or history.
3. Cut anything weak. Every word that stays should be something the user would plausibly add to their list.

## Output format

Group by angle. One line per word: the word in bold, then a short definition or origin, and how it fits the context when that isn't obvious.

```
### Reliquary and archive
- **ossuary**: a chamber for bones; fits a store of deleted records
- **palimpsest**: a manuscript scraped and rewritten, older text still visible beneath
```

End with a short **Picks** line naming the 3 to 5 strongest words for the context.

Keep the output to the list. No preamble about what makes a word cool.
