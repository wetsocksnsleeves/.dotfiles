---
name: visual-qa
description: Decide whether a branch's changes are visible in the UI and, if so, drive a browser through before/after screenshots (or GIFs for interactions) at a user-specified URL, then build a self-contained HTML comparison report. Use when the user asks to "visual qa", "qa the visuals", "check how this looks", "screenshot before and after", "show me the before and after", "did this change render correctly", "record a gif of this flow", or runs /visual-qa. Do NOT use for branch-switching QA setup alone (that is worktree-qa) or for non-visual changes.
---

# Visual QA

Prove a branch's UI change with evidence: capture the same screens on the feature branch and on the base branch, and hand back one HTML report.

Base URL and scope come from the user. Never guess a URL — ask.

## Phase 0 — Gate: is this change even visual?

```bash
bash scripts/detect_visual_changes.sh master
```

Act on the verdict:

- **not visual** — say so, name the changed files, and stop. Do not screenshot to look thorough.
- **possibly visual** — read the MAYBE files. A helper that returns markup or a controller that swaps a template or flash is visual; one that changes an ivar consumed by an unchanged partial usually is not. Decide, state the reasoning in one line, then continue or stop.
- **visual** — continue.

Then check for `db/migrate/` in the diff. If migrations are present, the baseline pass will run master's code against a migrated database. Tell the user, and offer to skip the baseline (after-only report) rather than capture a broken BEFORE.

## Phase 1 — Resolve the serving checkout

The URL is served by exactly one working copy. Switching *that* copy's branch is what produces the before/after pair. Working in a worktree and flipping the worktree's own branch changes nothing if a different directory backs the URL.

| URL | Serving checkout | Restart |
|---|---|---|
| `https://<user>.dev.<region>.adnat.co` | `~/dev/payaus` | handled by the dev box; poll |
| `https://<name>.test` (puma-dev) | the directory symlinked at `~/.puma-dev/<name>` | `touch <dir>/tmp/restart.txt` |
| `http://localhost:3000` | ask the user which directory it was booted from | ask |

Confirm the resolved directory with the user before touching any branch.

If the serving checkout is **not** the directory you are working in, the feature branch cannot be checked out in both places at once. Invoke the `worktree-qa` skill to do the swap — it parks the current worktree on `temporary` and checks the feature branch out in `~/dev/payaus`. Do not reimplement that dance here.

Record, before changing anything:

```bash
SERVING_DIR=<resolved>
FEATURE_BRANCH=$(git -C "$SERVING_DIR" branch --show-current)
ORIGINAL_BRANCH=$FEATURE_BRANCH
```

## Phase 2 — Agree the shot list

Propose the screens and get confirmation before capturing. For each: a label, a path, and what the user should be looking at. Derive candidates from the changed view files, not from imagination.

Mark each shot **still** or **GIF**:

- **still** — layout, spacing, colour, copy, a row appearing or disappearing.
- **GIF** — the change is only visible in motion: modal open/close, dropdown, hover state, drag, multi-step form, a Turbo Stream update landing.

Default to stills. A GIF costs 3–6 captures and a lot more report weight.

## Phase 3 — Capture AFTER (feature branch)

The serving checkout is already on the feature branch, so capture this side first.

Run directory: `tmp/visual-qa/<timestamp>/` inside the repo (gitignored). Fall back to the session scratchpad if `tmp/` is not ignored.

Use the chrome-devtools MCP tools:

1. `resize_page` to **1440x900** and keep it identical for every capture in both passes. A different viewport makes the pair uncomparable.
2. `navigate_page` to the URL, then `wait_for` real page content — not a fixed sleep.
3. Confirm you are not looking at a login redirect. If you are, stop and ask the user to log the browser in; do not screenshot a login page and call it a baseline.
4. `take_screenshot` with `filePath` set, `fullPage: true` unless the user wants a specific region.

Name files `<slug>-after.png`. For a GIF, capture ordered frames into `<slug>-after-frames/frame-01.png`, `frame-02.png`, … then:

```bash
bash scripts/make_gif.sh <frames_dir> <out.gif> 1.2 900
```

Keep captures deterministic: same window size, same logged-in user, same seed record. If a page shows a live clock or "2 minutes ago", note it so the report reader does not read it as a regression.

## Phase 4 — Capture BEFORE (base branch)

```bash
git -C "$SERVING_DIR" checkout master
bash scripts/wait_for_app.sh "<base_url>" 180
```

If the change touched SCSS/JS and the environment compiles assets, the bundle must rebuild before the baseline is meaningful — wait for the watcher, or say the baseline is unverified.

Repeat Phase 3 exactly: same viewport, same URLs, same order. Name files `<slug>-before.png`.

A 404 or missing element on master is a legitimate result — the screen is new. Record it as a null `before` with `before_missing_text`, do not fake a baseline.

## Phase 5 — Restore (mandatory)

Restore even if capture failed midway. Never leave the user's checkouts moved.

```bash
git -C "$SERVING_DIR" checkout "$ORIGINAL_BRANCH"
bash scripts/wait_for_app.sh "<base_url>" 180
git -C "$SERVING_DIR" branch --show-current
```

If `worktree-qa` performed the swap in Phase 1, run its "Ending QA" steps to put `~/dev/payaus` back on `master` and the worktree back on the feature branch.

## Phase 6 — Build the report

Write `manifest.json` in the run directory, then:

```bash
ruby scripts/build_report.rb <run_dir>/manifest.json
open <run_dir>/report.html
```

Manifest schema — image paths absolute, `before` may be `null`:

```json
{
  "title": "Wage comparison profiles list",
  "branch": "bug/eng-5107",
  "base": "master",
  "url_base": "https://etaotsai.dev.apac.adnat.co",
  "summary": "One plain sentence on what changed for the user.",
  "shots": [
    {
      "label": "Profiles index",
      "url": "/users/1/wage_comparisons",
      "note": "Current profile row no longer duplicated.",
      "before": "/abs/path/index-before.png",
      "after": "/abs/path/index-after.png"
    },
    {
      "label": "Compare modal",
      "url": "/users/1/wage_comparisons",
      "note": "Interaction recorded.",
      "before": null,
      "after": "/abs/path/modal-after.gif",
      "before_missing_text": "Modal did not exist on master"
    }
  ],
  "notes": ["1440x900 viewport", "Logged in as sysadmin", "No console errors on either branch"]
}
```

The builder embeds every image as a data URI, so the report is a single portable file. Images are click-to-zoom.

Keep it minimal — the report is evidence, not a writeup. `summary` is one sentence. `note` is one line per screen, describing what to look at. `notes` records the capture conditions so the reader can trust the pair.

Finally, report to the user in chat: the report path, and anything the screenshots did **not** cover.

## Gotchas

- **Browser profile lock** — chrome-devtools MCP holds a per-worktree user data dir. If another Claude session has it open, every browser call fails with "browser is already running". Ask the user to close the other session's browser; do not silently skip the capture.
- **Never `git stash`** — the stash stack is shared across worktrees. Commit or leave changes in place.
- **Uncommitted changes in the serving checkout** block the branch flip. Stop and ask; do not discard them.
- **Full-page screenshots of long pages** produce large PNGs and a heavy report. Capture the relevant region or set a sensible viewport for pages over ~4000px tall.
- **`before` and `after` must differ.** If they are identical, the change is not visible at that URL — say so rather than shipping a report that proves nothing.
