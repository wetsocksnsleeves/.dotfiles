---
name: understand
description: Use when the user explicitly requests this functionality.
disable-model-invocation: true
---

Take a look at the current branch, it's changes, and the related PR, and PR body.

Also take a look at unstaged changes.

## Linear ticket

Gather context from the Linear ticket behind this work when one exists.

- Find the ticket ID or URL from, in order: the user's message, the PR body and title (look for `linear.app/...` links and IDs like `ENG-1234`), then the branch name (e.g. `fix/eng-5542-...` means `ENG-5542`).
- Fetch the issue with `mcp__linear-server__get_issue`. Read the description, status, priority, labels, assignee, parent issue and project.
- Read the comments with `mcp__linear-server__list_comments`. Repro steps, scope changes and decisions often live there, not in the description.
- Follow links that bear on the goal: a parent issue, related or duplicate issues, attached Linear documents (`mcp__linear-server__get_document`), and screenshots (`mcp__linear-server__extract_images`). Stop at one hop. Don't crawl the whole project.
- Compare the ticket against the branch. Note acceptance criteria the diff doesn't cover yet, and changes in the diff the ticket doesn't ask for. Use this when judging completion.

If no ticket turns up, skip this section without comment. If the Linear MCP tools are missing, fail to authenticate, or return errors, skip this section and carry on with the rest of the command. Don't retry or ask the user to fix it mid-task. Mention it in the final line of the reply instead (see below).

Think about what has changed and why.

Do you understand the context here and what is trying to be achieved?

Once you have done all of this, briefly summarise what you believe the purpose of this work is, and what you believe it's level of completion is.

If you don't understand, ask some brief questions one by one until you completely understand the context and the goals of this work.

## File guide

End your reply with a bullet list of every file the branch modifies, so the user has context before reading the code. If you skipped the Linear ticket because the MCP was unavailable, add one line after the list saying so and naming the ticket ID you couldn't read.

- Include files changed on the branch (`git diff master...HEAD --name-only`) and files with staged, unstaged or untracked changes (`git status --short`).
- Leave out test files (anything under `test/` or `spec/`, or ending in `_test.rb`, `.test.js` or `.test.tsx`) and Sorbet RBI files (`*.rbi`).
- Give one bullet per file: the path in backticks, then one or two sentences on what changed in it and why it matters to the feature. Describe the change, not the whole file.
- Order the bullets so the user can read top to bottom: core models and logic first, then the jobs, controllers and notifiers that call them, then views, JS and config.
