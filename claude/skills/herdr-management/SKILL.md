---
name: herdr-management
description: Launch and drive Claude sessions ("threads") inside herdr, the terminal workspace manager. Use whenever the user talks about launching, starting, spinning up or opening a new thread, session, agent, Claude, tab or workspace; sending a prompt to another thread; or opening a PR or branch in a thread ("open #63845 in slot-2", "check this PR out here"); or spinning up a new PR in another thread, which creates a new slot-N worktree and workspace for it.
---

# Herdr session management

herdr runs a persistent server. Every pane started inside it has these env vars:

- `HERDR_WORKSPACE_ID`, `HERDR_TAB_ID`, `HERDR_PANE_ID` identify the pane this Claude runs in.
- `HERDR_SOCKET_PATH` is the API socket. The `herdr` CLI finds it on its own.

Check `HERDR_ENV=1` before anything else. If it is unset, this session is not inside herdr. Tell the user and stop.

A "thread" is a Claude session in a herdr pane. The user names threads by the workspace label (`slot-2`, `code-review`) or by the agent's terminal title.

## Scope

- **In scope.** Launching new threads, sending prompts to threads, focusing threads, checking a PR branch out in a thread's directory, and creating a slot-N worktree for a new PR thread (see "Spinning up a PR in a new thread").
- **Out of scope.** Removing or repairing git worktrees, creating any worktree other than a new slot-N, and freeing a branch that another worktree holds. Those belong to worktree management. Use the repo's worktree skill if there is one, or ask the user.
- **Only work where the user can follow.** Every worktree Claude works in must be open in a herdr workspace. Never `cd` into another worktree from this session, use `EnterWorktree`, or start a subagent with `isolation: "worktree"`. Work in another checkout happens in that checkout's own thread.
- **A new thread always runs Claude.** Start it in the new pane right after creating it. See "Launching a new thread".
- **No other defaults beyond the ones below.** Layout, labels, opening prompts, dependency installs and whether to wait on an agent all depend on what the user asks for. If the request doesn't say, do the minimum and don't invent a convention.

## Reading state

All commands print JSON.

```bash
herdr workspace list   # workspace_id, label, agent_status, tab_count, pane_count
herdr agent list       # every agent: pane_id, workspace_id, cwd, agent_status, terminal_title
herdr pane current     # the pane this command runs in
herdr tab list         # tabs
```

To resolve a thread name, match the workspace `label` from `workspace list`, then find its agent in `agent list` by `workspace_id`. The agent's `cwd` is the thread's checkout directory. If more than one agent matches, ask which one.

## Opening a PR

The PR opens in the current thread by default. That is the checkout this Claude session runs in (`git rev-parse --show-toplevel`). It opens in another thread only when the user names one, or in a new thread when the user asks for one (see "Launching a new thread").

1. Find the head branch with `gh pr view <number> --json headRefName,title`.
2. Find the target directory. For the current thread it is the repo root. For a named thread it is that agent's `cwd`.
3. Run `git -C <dir> status --porcelain`. If there are uncommitted changes, stop and ask.
4. Run `git -C <dir> fetch origin <branch>`, then `git -C <dir> switch <branch>`. If the branch only exists on the remote, use `git -C <dir> switch --track origin/<branch>`.
5. If `switch` fails because another worktree has the branch checked out, report which worktree (`git worktree list`) and stop. Freeing it is worktree management.

Don't stop the agent in a named thread to do this. If that agent is `working`, tell the user before switching its branch under it.

## Launching a new thread

A new thread always starts Claude in its first tab straight away. Never leave the new pane as a bare shell, even when the user asked for nothing else.

Pick where the thread goes from what the user said:

- A new workspace for a different directory: `herdr workspace create --cwd <dir> --label <label>`
- A new tab in an existing workspace: `herdr tab create --workspace <workspace_id> --cwd <dir> --label <label>`
- A split next to an existing pane: `herdr pane split <pane_id> --direction right|down --cwd <dir>`

Each create command returns the new `root_pane.pane_id`, or `pane_id` for a split. Pass `--focus` to a create command only if the user wants to switch to it.

Then run these steps in order:

1. Do any setup the request needs in `<dir>` before Claude starts, so the session opens on the right state. For "open #63845 in a new thread", follow "Opening a PR" with `<dir>` as the target directory.
2. Start Claude in the new pane:

   ```bash
   herdr agent start <name> --kind claude --pane <pane_id>
   ```

3. If the request names work for the new thread, such as running a skill or a task, send it as that thread's first prompt with `herdr agent prompt <pane_id> "<text>"`. A skill goes in as its slash command, for example `/understand`. Send only what the user asked for.

Example: "open #63845 in a new thread in slot-3 and run the understand skill" means create the workspace, check out the PR branch in slot-3's directory, start Claude, then prompt it with `/understand`.

If the user didn't say which directory the new thread uses, ask. The one exception is a new PR thread, which gets a new slot-N worktree (next section).

## Spinning up a PR in another thread

"Spin up a PR" with no thread named happens in the current thread. Use the create-pr skill and don't create anything here.

When the user names a thread ("spin up a PR in slot-3"), do it in that thread and create nothing new:

1. Resolve the thread to its agent and `cwd` (see "Reading state").
2. Run `git -C <dir> status --porcelain`. If there are uncommitted changes, stop and ask.
3. If the agent is `working`, tell the user and stop. Don't switch a branch under it.
4. Name the branch with the branch rules in the user's CLAUDE.md. If you can't tell the type or the ticket from the request, ask.
5. Run `git -C <dir> fetch origin master`, then `git -C <dir> switch --no-track -c <branch> origin/master`.
6. Settle the thread's old conversation as "Setting up an existing thread for a new task" describes, then send the task with `herdr agent prompt`: the user's description of the work, and that it ends with a PR. Don't do any of the work in this session.

When the user says "another thread" without naming one, look for a free slot thread first. A slot thread is free when all of these hold:

- Its workspace label is `slot-N` and it isn't this session's workspace (`HERDR_WORKSPACE_ID`).
- It has exactly one Claude agent in `agent list`, and that agent is `idle`.
- `git -C <dir> status --porcelain` prints nothing.
- Its branch has no work left to do. Either `gh pr list --head <branch> --state all --json state` shows the PR as `MERGED` or `CLOSED` and `git -C <dir> rev-list --count @{u}..HEAD` is 0, or the branch has no PR and `git -C <dir> rev-list --count origin/master..HEAD` is 0. Don't use the ahead-of-master count for a merged PR. A squash merge leaves the branch's commits ahead of master.

If any slot is free, use the lowest-numbered one and follow the named-thread steps above. The only difference is in step 6: clear the session without asking, because its work is already finished. Tell the user which slot you used and why it counted as free, for example "slot-3, #63823 merged". If no slot is free, create one as described below.

When the user asks for a new thread, or no slot is free, give the work its own slot worktree and workspace:

1. Pick the slot number. Take the highest N among `slot-N` directories in the worktrees folder (`../worktrees` from the main repo) and `slot-N` workspace labels in `herdr workspace list`, and add 1.
2. Name the branch with the branch rules in the user's CLAUDE.md. If you can't tell the type or the ticket from the request, ask.
3. Create the worktree from the main repo with the repo's worktree script. In payaus that is:

   ```bash
   bin/manage-worktrees --non-interactive <branch> slot-<N>
   ```

   It branches from master, keeps the branch name as given, and names the directory `slot-<N>`. If it fails because the branch already exists, report it and ask. Don't `cd` into the new worktree.
4. Create the workspace with `herdr workspace create --cwd <worktree path> --label slot-<N>`, then start Claude in its root pane (see "Launching a new thread").
5. Send the task as the new thread's first prompt: the user's description of the work, and that it ends with a PR. Don't do any of the work in this session.
6. Tell the user the slot number. If this thread has uncommitted changes that belong to the task, say that they did not carry over, because the new worktree starts from master.

Every create command runs as soon as it is called, even with no arguments. A bare `herdr workspace create` makes a real workspace in the current directory. Don't run create commands to read their usage. Read the schema instead (below).

## Setting up an existing thread for a new task

An existing thread's Claude still holds its earlier conversation. `/clear` deletes that conversation for good, so settle it before sending the new task:

- **The user says the new task replaces the thread's work** ("override", "replace", "start fresh", "wipe it"). Clear the session without asking.
- **The user doesn't say.** Ask whether to clear the session, and say that clearing loses track of the work already in it. Ask before sending anything to the thread.

To clear, check with `agent list` that the agent isn't `working`, then:

```bash
herdr agent prompt <pane_id> "/clear"
herdr agent read <pane_id> --source recent --lines 40
```

Don't pass `--wait` here. `/clear` never moves the agent to `working`, so `--wait` fails with `agent_prompt_stalled` even when the clear worked. Instead, read the pane and confirm the old conversation is gone and the status line shows `0%` context. Send the task prompt only after that.

## Talking to other threads

```bash
herdr agent prompt <target> "<text>"                    # submit a prompt
herdr agent prompt <target> "<text>" --wait --until idle --timeout <ms>
herdr agent wait <target> --until idle --timeout <ms>
herdr agent read <target> --source recent --lines 200   # read its output
herdr agent focus <target>
herdr workspace focus <workspace_id>
```

`<target>` is a pane id from `agent list`.

Send prompts only when the user asks for it. A task the user named while launching a thread counts as asking. A prompt to another thread is an instruction to another agent, so send the user's words, or a prompt the user approved, and nothing else. The one exception is a `/clear` that "Setting up an existing thread for a new task" allows.

## Closing things

Closing a tab, workspace or pane ends whatever runs in it. Do it only when the user asks for that specific item, and check with `agent list` that no agent there is `working`. Commands are `herdr tab close <tab_id>`, `herdr workspace close <workspace_id>` and `herdr pane close <pane_id>`.

## Looking up commands

`herdr <group> --help` lists a group's commands. Subcommand `--help` does not work: it prints the top-level help. Running a read-only subcommand with no arguments prints its usage line. For create commands, read the API schema instead:

```bash
herdr api schema --output <scratchpad>/herdr-schema.json
```

Request params are under `schemas.request.$defs`, for example `WorkspaceCreateParams`, `TabCreateParams`, `AgentStartParams` and `PaneSplitParams`.
