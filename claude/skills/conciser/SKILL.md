---
name: conciser
description: Strip AI-slop from prose and tighten it, by shelling out to the `conciser` script (cursor-agent CLI, Grok 4.6). User-invoked only — run it on a draft summary, findings, investigation or trace report, root-cause writeup, code-review writeup, PR or ticket description, doc, README, commit message or release note. Not for code.
disable-model-invocation: true
---

# Conciser

`~/.local/bin/conciser` sends the draft plus a fixed rule set to the cursor-agent CLI and prints the rewrite. Cursor's output is the deliverable. You are a pipe.

## The user cannot see the Bash result

Bash tool output goes to you, not to the user's screen. Running the script does not deliver anything. The rewrite reaches the user only when you type it, character for character, in your reply text after the tool call.

Running `conciser` and then stopping, or replying "done, the cleaned version is above", ships nothing. That is the failure this skill exists to prevent.

## The only allowed sequence

1. Write the finished draft to a file in the session scratchpad directory.
2. Run `conciser <file>`, adding `-s` when the draft has structure to fix (see below).
3. Reproduce the command's stdout as your reply, in full, byte for byte.

```bash
conciser "$SCRATCH/findings.md"
conciser -s "$SCRATCH/pr-body.md"
```

Nothing happens before step 1, between the steps, or after step 3.

## Step 3 in detail

Your reply after the tool call is the stdout and nothing else. First character of stdout is the first character of your reply. Last character of stdout is the last character of your reply.

Wrong:

> Ran it through conciser. The output is above.

Wrong:

> Here's the tightened version:
>
> The new caching layer cuts build times.
>
> Let me know if you want it shorter.

Right, when stdout was `The new caching layer cuts build times.`:

> The new caching layer cuts build times.

Do not:

- edit, reword, retitle, reformat, reorder or re-punctuate any part of it
- fix what looks like a mistake in it, including a rule you think it missed
- add a preamble, heading, framing sentence, sign-off, or "here's the cleaned version"
- append a summary, a diff, a note on what changed, or commentary on the output's quality
- merge it with your own draft, quote parts of it, or use it as a starting point
- summarise it, shorten it, or describe it instead of printing it
- run it through again, or through a second model

If the output looks wrong, print it anyway and say nothing. The user reads the same text you do.

## When it fires

Anything you hand the user as written work:

- summaries of what you did, found, or changed
- findings, investigation notes, root-cause writeups, code-review writeups
- trace and debug reports, incident notes, benchmark or profiling writeups
- descriptions: PR bodies, Linear tickets, commit messages, release notes
- docs, READMEs, comments meant for a human audience
- anything the user explicitly sends through it

Skip it for short conversational replies, direct answers to a question, tool output, code, config, SQL, YAML and log dumps.

## Choosing `-s`

Without `-s` the script edits sentences and keeps every fact and every heading. That is the right default when the draft is already shaped correctly and each fact has to survive: trace and debug reports, incident notes, benchmark numbers, anything the reader will audit.

Pass `-s` when the draft is hard to follow because of how it is arranged, not how it is worded. It lets the script delete sections, collapse lists into prose, reorder, and drop material. Reach for it when the draft:

- opens with background instead of the point
- narrates the investigation: what you searched, what you ruled out, which tool reported it
- lists the edits change by change instead of saying what is different now
- carries identifiers the reader will never use (process IDs, record IDs, log excerpts)
- asks the reader a question or hedges about what was left undone

PR bodies, Linear tickets and code-review writeups usually want `-s`. It will not drop links or checklists.

Choose once, before the call. Never run the draft through both modes.

## Failure

If the script exits non-zero or prints nothing, say so in one line and print the original draft in your reply unchanged. Do not substitute your own edit and do not retry with different flags.

## Options

| Flag | Effect |
|---|---|
| `-m, --model <name>` | cursor-agent model. Default `cursor-grok-4.6-high`, or `$CONCISER_MODEL`. `cursor-grok-4.6-high-fast` trades credits for latency; `cursor-agent --list-models` shows the rest. |
| `-r, --rules <file>` | Use a different rule set instead of the built-in one. |
| `-s, --structure` | Add the structural rules: cut sections, collapse lists, drop investigation notes. See above. |
| `--print-rules` | Print the rules the script sends. Combines with `-s`. |

A rules file at `~/.config/conciser/rules.md` overrides the built-in set for every call, and `-s` still appends to it. Do not end a rules file with `Text to rewrite:`; the script appends that itself. Change the rules there, never by editing the output.
