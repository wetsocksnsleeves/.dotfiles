---
name: local-login
description: Log the chrome-devtools MCP browser into a local puma-dev environment (https://<worktree>.test) using directions and credentials kept in a local file outside the dotfiles repo. Use when browser QA lands on a Tanda login page, or when the user says "log in", "sign in", "log into local" or "local login".
---

# Local login

The directions and credentials live in `~/.local/share/agent-logins/puma-dev.md`. That file is local to this machine and is not part of the dotfiles repo. Never copy its contents into the dotfiles repo, a commit, a PR, a memory file or the chat.

1. Read `~/.local/share/agent-logins/puma-dev.md`.
2. Run its "Am I in a puma-dev environment?" check from the current working directory.
3. If the check passes, follow that file's login steps.
4. If the check fails, or the file is missing, don't log in. Tell the user which tab needs a login and wait for them to say it's done.
