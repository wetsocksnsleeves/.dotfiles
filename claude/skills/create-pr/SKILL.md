---
name: create-pr
description: Create a GitHub pull request for the current branch with gh, with a conventional-commit title and a short PROBLEM / CAUSE / SOLUTION / QA body. Use when the user asks to create, open, raise or make a PR or pull request, push the branch up as a PR, or write the body for a new PR.
user-invocable: false
---

# Create PR

Open a pull request for the current branch with `gh pr create`, using the title format and body template below.

## Steps

1. Check the branch. If it is `master` or `main`, stop and ask which branch the PR is for.
2. Run `git status`. If there are uncommitted changes, ask whether to commit them before you continue. Never commit without asking.
3. Work out what the branch does from `git log master..HEAD` and `git diff master...HEAD`. If the branch name or a commit names a Linear ticket (for example `ENG-1234`), read the ticket for the problem it describes.
4. Push the branch with `git push -u origin HEAD`.
5. Write the body into a file in the session scratchpad. Passing it with `--body-file` keeps backticks and markdown away from the shell.
6. Run `gh pr create --title "<title>" --body-file <file>`. If the repo's AGENTS.md or CLAUDE.md sets more PR rules, such as draft status, assignee or labels, add those flags.
7. Reply with the PR URL.

## Title

Start with a conventional commit type: `feat`, `fix`, `chore`, `refactor`, `perf`, `test`, `docs`, `build` or `ci`. When there is a Linear ticket, add it in lowercase after a slash. Then a colon and a short lowercase summary of what changes for the user.

- `feat: allow profile image upload on web view`
- `fix/eng-5716: square split by category not creating streams`

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
