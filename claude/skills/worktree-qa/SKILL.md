---
name: worktree-qa
description: Manages worktree QA workflow by switching branches between worktree and ~/dev/payaus for testing. Use when user mentions "qa", "test this", "qa the work", or when they indicate QA is done ("done with qa", "qa passed", further work instructions).
---

# Worktree QA Workflow

Manages the workflow for QA testing changes from worktrees using branch switching.

## Workflow Overview

Instead of copying files, this workflow uses git branch switching:
- **Start QA:** Switch worktree to `temporary` branch, then checkout feature branch in ~/dev/payaus
- **End QA:** Switch ~/dev/payaus back to `master`, then checkout feature branch in worktree

## Starting QA

When the user wants to QA their work:

1. **Verify worktree context:**
   ```bash
   git branch --show-current
   ```
   - Must NOT be on `master` branch
   - If on master, warn user and abort
   - Record the feature branch name (e.g., `course-allergies-and-dietaries`)

2. **Switch worktree to temporary branch:**
   ```bash
   git checkout temporary
   ```
   - If `temporary` branch doesn't exist, create it first:
     ```bash
     git checkout -b temporary
     ```
   - This prevents the feature branch from being checked out in two places simultaneously

3. **Checkout feature branch in ~/dev/payaus:**
   ```bash
   cd ~/dev/payaus && git checkout <feature-branch>
   ```
   - Use the feature branch name from step 1
   - All changes from the feature branch are now available for testing in ~/dev/payaus

4. **Confirm QA ready:**
   - Tell user the feature branch is checked out in ~/dev/payaus
   - Remind them servers/services are running there
   - Wait for feedback

## Ending QA

**IMPORTANT:** QA cleanup happens in TWO scenarios:
1. User explicitly says QA is done ("done with qa", "qa passed", "finish qa")
2. **User requests further work** ("add error handling", "update tests", "fix this bug")

**When user requests further work, AUTOMATICALLY clean up FIRST before proceeding with the new work.**

Steps to end QA:

1. **Switch ~/dev/payaus back to master:**
   ```bash
   cd ~/dev/payaus && git checkout master
   ```
   - This removes the feature branch changes from ~/dev/payaus

2. **Switch worktree back to feature branch:**
   ```bash
   git checkout <feature-branch>
   ```
   - Use the feature branch name recorded during "Starting QA"
   - This restores the worktree to the original working state

3. **Verify cleanup:**
   ```bash
   cd ~/dev/payaus && git branch --show-current
   ```
   - Should show `master`
   - Confirm to user that ~/dev/payaus is back on master

4. **Then proceed with requested work** (if applicable)

## State Tracking

**CRITICAL:** Always track QA state in the conversation:

After starting QA:
- Set **qa_active** = true
- Record **qa_feature_branch** = name of the feature branch

When ending QA (explicit or implicit):
- Switch ~/dev/payaus to master
- Switch worktree back to qa_feature_branch
- Set **qa_active** = false
- Clear **qa_feature_branch**

**Automatic Cleanup Trigger:**
If **qa_active** is true and user requests ANY new work (code changes, tests, fixes), you MUST:
1. Clean up ~/dev/payaus first (checkout master)
2. Switch worktree back to feature branch
3. Set qa_active = false
4. Then proceed with the new work

## Error Handling

- **On master branch**: Warn user they're already on master, abort
- **~/dev/payaus doesn't exist**: Warn user and abort
- **Feature branch doesn't exist in ~/dev/payaus**: Fetch it first with `git fetch origin <branch>`
- **Uncommitted changes in ~/dev/payaus**: Warn user and ask if they want to stash or discard changes
- **Branch switch fails**: Report issue with details

## Examples

### Example 1: Starting QA
**User:** "qa this work"
- Check branch → `course-allergies-and-dietaries` ✓
- Switch worktree to `temporary`
- Switch ~/dev/payaus to `course-allergies-and-dietaries`
- Set qa_active = true, qa_feature_branch = "course-allergies-and-dietaries"
- Report: "✓ Feature branch `course-allergies-and-dietaries` is now checked out in ~/dev/payaus for QA"

### Example 2: Explicit QA Completion
**User:** "QA done"
- Check qa_active → true ✓
- Switch ~/dev/payaus to `master`
- Switch worktree to `course-allergies-and-dietaries`
- Set qa_active = false
- Report: "✓ Cleaned up ~/dev/payaus (back on master)"

### Example 3: Implicit QA Completion (New Work Requested)
**User:** "Let's add error handling now"
- Check qa_active → true ✓
- **FIRST:** Switch ~/dev/payaus to `master`
- **FIRST:** Switch worktree back to `course-allergies-and-dietaries`
- Set qa_active = false
- Report: "✓ Cleaned up ~/dev/payaus from previous QA"
- **THEN:** Continue with error handling work
