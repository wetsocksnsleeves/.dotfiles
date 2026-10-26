---
name: create-pr
description: Create a GitHub pull request for the current branch with gh, with a conventional-commit title and a short PROBLEM / CAUSE / SOLUTION / QA body. Use when the user asks to create, open, raise, make or spin up a PR or pull request, push the branch up as a PR, or write the body for a new PR.
user-invocable: false
---

# Create PR

Open a pull request with `gh pr create`, using the title format and body template below.

## Which thread

"Spin up a PR" with no thread named means the current thread. Do the work in this checkout (`git rev-parse --show-toplevel`) and follow the steps below.

If the user names a thread, or asks for another or a new thread, use the herdr-management skill ("Spinning up a PR in another thread") instead. A named thread does the work in its own checkout. An unnamed "another thread" reuses a free slot thread if there is one. Only a new thread, or an unnamed one with no free slot, gets a new slot-N worktree. Don't create a worktree from this session, and don't `cd` into one, use `EnterWorktree`, or start a subagent with `isolation: "worktree"`. The user only works in checkouts they can reach by navigating herdr.

## Steps

1. Check the branch. If it is `master` or `main`, create a new branch in this checkout with `git switch -c <branch>`, which carries uncommitted changes over. Name it with the branch rules in the user's CLAUDE.md: a type, a slash, the Linear ticket id in lowercase if there is one, then lowercase words joined by hyphens. If the branch is already a feature branch for this work, use it.
2. Run `git status`. If there are uncommitted changes, ask whether to commit them before you continue. Never commit without asking.
3. Work out what the branch does from `git log master..HEAD` and `git diff master...HEAD`. If the branch name or a commit names a Linear ticket (for example `ENG-1234`), read the ticket for the problem it describes.
4. Push the branch with `git push -u origin HEAD`.
5. Write the body into a file in the session scratchpad. Passing it with `--body-file` keeps backticks and markdown away from the shell.
6. Run `gh pr create --title "<title>" --body-file <file>` with a `--label` flag for each label from the Labels section below. If the repo's AGENTS.md or CLAUDE.md sets more PR rules, such as draft status, assignee or labels, add those flags.
7. Reply with the PR URL.

## Title

Start with a conventional commit type: `feat`, `fix`, `chore`, `refactor`, `perf`, `test`, `docs`, `build` or `ci`. Use `spike` for an exploratory PR that tries out an approach and isn't meant to merge as is. When there is a Linear ticket, add it in lowercase after a slash. Then a colon and a short lowercase summary of what changes for the user.

- `feat: allow profile image upload on web view`
- `fix/eng-5716: square split by category not creating streams`
- `spike: stream pos sales over websockets`

## Labels

Add every label that fits the PR:

- `feature` for new behaviour (usually a `feat` title)
- `bug` for a fix to broken behaviour (usually a `fix` title)
- `refactor` for a change to code structure that keeps behaviour the same
- `api-only` when the change only affects the API and nothing in the web or mobile UI
- `not-user-facing` when no user can see the change, such as tooling, CI, tests or internal cleanup
- `security` when the PR fixes or hardens a security issue, such as an IDOR, a permission check or data exposure

Most PRs get one of `feature`, `bug` or `refactor`, plus any of the other three that apply. If none fit, add no label. If you can't tell whether one applies, ask the user before you create the PR.

## Body

Keep it short. A reviewer should be able to read the whole body in under a minute. Each section gets one to three sentences. The diff carries the detail.

- Don't restate the title.
- Don't walk through the changes file by file or commit by commit.
- Leave out how the problem was found, and any questions for reviewers. Raise those with the user in chat.

```markdown
### PROBLEM

[What is broken or wrong from the user's perspective]

### CAUSE

[Root cause in the code. What specifically is wrong and why]

### SOLUTION

[What was changed and how it fixes the cause]

### QA

[Leave for the user to fill in]
```

Leave the QA section for the user. If there is a lot to QA, add checkboxes that list what to check, so the user has a guide.
