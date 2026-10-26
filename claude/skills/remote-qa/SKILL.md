---
name: remote-qa
description: Run visual-qa and hand the result back in a form that reads well in the herdr web UI on a phone or browser - a markdown report with before/after images stacked, opened by tapping its path in chat. Use when the user asks for "remote qa", "qa for my phone", "visual qa in the web ui", "show me the before and after on my phone", or runs /remote-qa. Also use instead of a plain visual-qa run when the user says they are on their phone or in the web UI.
---

# Remote QA

Visual QA whose result the user reads in the herdr web UI (`~/code/herdr-web-ui`), usually on a phone.

## What the web UI can show

- Chat renders the assistant's markdown but not its images. `![alt](path)` in a chat answer shows as text.
- A file path in a chat answer is a link, whether plain or in backticks. Tapping it opens the file in the web UI's file viewer.
- The file viewer renders a markdown file with its images inline. Relative image paths resolve from the markdown file's folder. It also shows images, GIFs and video, and renders HTML pages in a sandbox: scripts run, but the page has no origin, so the visual-qa report's copy-to-clipboard buttons may fail.
- The terminal view is xterm.js with no image support, so inline terminal images (iTerm2, kitty, sixel) don't show.

So the result goes in a markdown file next to the screenshots, and the chat answer links to it.

## When to use

Only when the user asks. The web UI's chat reads the Claude transcript from disk and leaves nothing in this session that shows someone is viewing it, so the session can't detect a web UI viewer.

## Steps

1. Run the `visual-qa` skill's phases 0 to 5 as written: the visual-change gate, the serving checkout, the shot list, both captures and the restore. The user may answer the shot-list question from a phone, so keep it short and number the shots.
2. Run its phase 6 to write `manifest.json` and build `report.html`, but skip `open <run_dir>/report.html`. That opens a browser on this Mac, not where the user is.
3. Write `<run_dir>/report.md` from the manifest:

   ```markdown
   # <title>

   <summary>

   `<branch>` against `<base>` on <url_base>

   ## <label>

   `<url>`. <note>

   **Before**

   ![<label> before](<slug>-before.png)

   **After**

   ![<label> after](<slug>-after.png)

   ## Capture conditions

   - <each entry in notes>
   ```

   - Put before above after, never side by side. A phone shows one 1440px-wide screenshot at a time.
   - Use image paths relative to the run directory, so they resolve from `report.md`.
   - When a shot's `before` is null, write its `before_missing_text` in place of the before image.
   - GIFs go in the same way. The viewer animates them.

4. Reply in chat in this shape and nothing more:

   ```
   <summary sentence>

   - <label>: <note>

   Report: <absolute path to report.md>
   Full report: <absolute path to report.html>

   Not covered: <what the screenshots did not cover, or "nothing">
   ```

   Put each path on its own line as an absolute path, outside any fenced code block, so chat turns it into a link.
