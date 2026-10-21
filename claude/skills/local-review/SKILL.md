---
name: local-review
description: Run the project's code-review skill without labelling the PR, and report findings as one severity-ranked list. Use when the user runs /local-review or asks for a "local review".
argument-hint: "[scope] [personality...] [as comments]"
---

# Local review

1. Invoke the `code-review` skill with the Skill tool, passing through any arguments the user gave.
2. Follow its instructions, with these overrides:
   - Skip its `reviewed-by-ai` label step. See "Forbidden tools" below.
   - Ignore its output format. Do not print the linter pass, the personality reviews, the synthesis or any praise. Use the format below instead.

## Forbidden tools

The review is read-only on GitHub. Never run a `gh` command that creates, changes or deletes anything. That includes:

- `gh pr edit`, `gh pr comment`, `gh pr review`, `gh pr create`, `gh pr close`, `gh pr reopen`, `gh pr merge`, `gh pr ready`
- `gh issue` create, edit, comment, close, reopen, delete or transfer
- `gh label` create, edit, delete or clone
- `gh api` with `-X POST`, `PUT`, `PATCH` or `DELETE`, or with `-f`/`-F` fields (these switch the request to POST)
- any GitHub MCP tool that writes, such as adding a comment or a review

Read-only calls are fine, for example `gh pr view`, `gh pr diff`, `gh pr checks` and a GET `gh api`.

Subagents don't see this skill. Copy this section into every subagent prompt.

## Output format

Merge the findings from every subagent into one list. When two subagents report the same problem, keep one entry. Give each finding a severity: Critical, High, Medium or Low.

Put app code findings under `# App code` and test findings under `# Tests`. Inside each, group findings under `##` severity headings, from Critical down to Low. Leave out any severity group or section that has no findings. Number findings continuously through the whole review so the user can refer to one by number.

Format each finding like this:

- Write the number and issue name together in bold, as `**1. <issue name>**`. Don't start the line with a bare `1.`, because markdown would turn it into a list and renumber it.
- Put `Where`, `What` and `Fix` on separate lines below the name, not indented, with each label in sentence case and bold, followed by a colon.
- Leave one empty line between the fields, and one empty line between each finding and the next.

```
# App code

## Critical

**1. <issue name>**

**Where:** <file_path:line_number>

**What:** <description>, and why it has this severity

**Fix:** <recommended fix>

**2. <issue name>**

**Where:** ...

## High

**3. <issue name>**

...

# Tests

## Medium

**4. <issue name>**

...
```

If nothing survives, print `No issues found.`

Write every `What` and `Fix` following the `unslop` skill. Keep them short and concrete: name the consequence, not the pattern.

Write `What` as a reviewer talking the author through the problem, not as a report entry. Address the author as "you", walk through what the code does and where it goes wrong, then say why that earns the severity. Use full sentences, not labelled fragments.

Report style, don't write this:

> N+1 query detected in `approver_names`. Performance impact on large organisations. Severity: High due to production load.

Commentary style, write this:

> `approver_names` calls `user.name` for every approver, and nothing preloads `user`, so you get one query per approver. The settings page renders this for every team, which on a large organisation means hundreds of queries per load. It's High because the page slows down as the org grows, though nothing breaks.
