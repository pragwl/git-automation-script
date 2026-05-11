# Git Automation Script — Complete User Guide

> **Requirements:** `git` and `gh` (GitHub CLI) must be installed on your Linux machine.  
> **IntelliJ users:** Run this script in the built-in terminal (`Alt + F12`).

---

## Table of Contents

1. [Installation & Setup](#installation--setup)
2. [Launching the Script](#launching-the-script)
3. [Main Menu Overview](#main-menu-overview)
4. [Module 1 — Worktree](#module-1--worktree-)
5. [Module 2 — Branch Management](#module-2--branch-management-)
6. [Module 3 — Stash](#module-3--stash-)
7. [Module 4 — Cherry-Pick](#module-4--cherry-pick-)
8. [Module 5 — Rebase](#module-5--rebase-)
9. [Module 6 — Reset / Undo](#module-6--reset--undo-)
10. [Module 7 — Tags & Releases](#module-7--tags--releases-)
11. [Module 8 — Create Pull Request](#module-8--create-pull-request-)
12. [Module 9 — Review Pull Request](#module-9--review-pull-request-)
13. [Module 10 — Merge Pull Request](#module-10--merge-pull-request-)
14. [Module 11 — Log & History](#module-11--log--history-)
15. [Module 12 — Diff](#module-12--diff-)
16. [Module 13 — Remote Operations](#module-13--remote-operations-)
17. [Module 14 — GitHub Issues](#module-14--github-issues-)
18. [Module 15 — Quick Status Dashboard](#module-15--quick-status-dashboard-)
19. [Real-World Workflows](#real-world-workflows)
20. [Tips & Tricks](#tips--tricks)

---

## Installation & Setup

### Step 1: Install Git

```bash
sudo apt update && sudo apt install git -y
git --version
# git version 2.x.x
```

### Step 2: Install GitHub CLI (`gh`)

```bash
sudo apt install gh -y
gh --version
# gh version 2.x.x
```

### Step 3: Authenticate with GitHub

```bash
gh auth login
# Choose: GitHub.com → HTTPS → Login with a web browser
# Paste the one-time code shown in the terminal into the browser
```

### Step 4: Download & make the script executable

```bash
chmod +x git-automation.sh
```

---

## Launching the Script

Navigate to your Git repository first, then run:

```bash
cd /path/to/your/repo
./git-automation.sh
```

> **Note:** The script checks that you are inside a Git repository before every operation. If you are not, it will show an error and exit.

---

## Main Menu Overview

```
╔══════════════════════════════════════════╗
║      Git Automation Script               ║
║      Complete Edition · gh CLI           ║
╚══════════════════════════════════════════╝

  Current branch: main

  1)  🌲  Worktree
  2)  🌿  Branch Management
  3)  📦  Stash
  4)  🍒  Cherry-Pick
  5)  ♻️   Rebase
  6)  ⏪  Reset / Undo
  7)  🏷️   Tags & Releases
  8)  🚀  Create Pull Request
  9)  🔍  Review Pull Request
  10) 🔀  Merge Pull Request
  11) 📜  Log & History
  12) 🔎  Diff
  13) 🌐  Remote Operations
  14) 🐛  GitHub Issues
  15) 📊  Quick Status Dashboard
  0)  ❌  Exit
```

Type the number and press **Enter** to enter a module. Type `0` inside any module to go back to the main menu.

---

## Module 1 — Worktree 🌲

**What is a worktree?**  
A Git worktree lets you check out multiple branches simultaneously in separate directories. Useful when you want to work on a hotfix while keeping your feature branch untouched.

### Option 1: Add worktree (new branch)

Creates a brand new branch and a new directory for it.

```
➤ New branch name: hotfix/login-crash
➤ Path for worktree: ../hotfix-work
```

**Result:** A new folder `../hotfix-work` is created, checked out to `hotfix/login-crash`.

```bash
# Equivalent git command
git worktree add -b hotfix/login-crash ../hotfix-work
```

### Option 2: Add worktree (existing branch)

Check out an existing branch into a new directory without switching your current branch.

```
➤ Branch name: feature/payment
➤ Path for worktree: ../payment-work
```

```bash
# Equivalent git command
git worktree add ../payment-work feature/payment
```

### Option 3: List all worktrees

Shows all active worktrees and their branches.

**Example output:**
```
/home/user/my-repo         abc1234 [main]
/home/user/hotfix-work     def5678 [hotfix/login-crash]
/home/user/payment-work    ghi9012 [feature/payment]
```

### Option 4: Remove a worktree

```
➤ Path of worktree to remove: ../hotfix-work
❓ Remove worktree at '../hotfix-work'? [y/N]: y
```

> This only removes the worktree link — the branch still exists.

### Option 5: Move/rename a worktree

```
➤ Current worktree path: ../hotfix-work
➤ New path: ../critical-fix
```

### Option 6: Prune stale worktree info

Cleans up references to worktrees whose directories no longer exist (e.g. manually deleted folders).

```bash
# Equivalent git command
git worktree prune
```

---

## Module 2 — Branch Management 🌿

### Option 1: Create new branch

```
➤ Base branch (leave blank for current HEAD): main
➤ New branch name: feature/user-profile
```

You will be switched to `feature/user-profile` automatically.

```bash
# Equivalent
git checkout -b feature/user-profile main
```

### Option 2: Switch branch

```
➤ Branch to switch to: develop
```

```bash
git checkout develop
```

### Option 3 / 4 / 5: List branches

| Option | Shows |
|--------|-------|
| 3 | Local branches with last commit |
| 4 | Remote branches |
| 5 | All branches (local + remote) |

### Option 6: Rename current branch

You are on `feature/old-name`:

```
➤ New name for current branch: feature/new-name
```

```bash
git branch -m feature/new-name
```

### Option 7: Delete local branch

```
➤ Branch to delete locally: feature/done
❓ Delete local branch 'feature/done'? [y/N]: y
```

If the branch has unmerged commits, it will ask:
```
⚠ Branch not fully merged.
❓ Force delete? [y/N]:
```

### Option 8: Delete remote branch

```
➤ Remote branch name to delete (without 'origin/'): feature/done
❓ Delete remote branch 'origin/feature/done'? [y/N]: y
```

```bash
git push origin --delete feature/done
```

### Option 9: Push branch to remote

Pushes the current branch and sets upstream tracking automatically.

```bash
git push -u origin feature/user-profile
```

### Option 10: Pull latest from remote

```bash
git pull
```

### Option 11: Track remote branch

```
➤ Remote branch to track: origin/develop
```

```bash
git branch --set-upstream-to=origin/develop
```

### Option 12: Cleanup merged branches

Lists all locally merged branches (excluding `main`, `master`, `develop`) and offers to delete them all.

```
ℹ Merged branches (to be deleted):
  feature/done
  bugfix/old-fix
❓ Delete all listed merged branches? [y/N]: y
```

---

## Module 3 — Stash 📦

**What is stash?**  
Temporarily saves your uncommitted changes so you can switch context, then come back and restore them.

### Option 1: Stash current changes

Saves all tracked modified files instantly.

```bash
git stash
```

### Option 2: Stash with message

```
➤ Stash message: WIP - half done user profile form
```

```bash
git stash push -m "WIP - half done user profile form"
```

### Option 3: Stash including untracked files

Also stashes new files that haven't been `git add`-ed yet.

```
➤ Stash message (optional): including new config file
```

```bash
git stash push -u -m "including new config file"
```

### Option 4: List all stashes

**Example output:**
```
stash@{0}: On feature/profile: WIP - half done user profile form
stash@{1}: On main: quick save before meeting
```

### Option 5 / 6: Apply vs Pop

| Option | Behaviour |
|--------|-----------|
| 5 Apply | Restores stash but **keeps** it in the list |
| 6 Pop   | Restores stash and **removes** it from the list |

### Option 7: Apply specific stash

```
➤ Stash index (e.g. 0 for stash@{0}): 1
```

```bash
git stash apply stash@{1}
```

### Option 8: Drop specific stash

```
➤ Stash index to drop: 0
❓ Drop stash@{0}? [y/N]: y
```

### Option 9: Clear all stashes

```
❓ Clear ALL stashes? This cannot be undone. [y/N]: y
```

### Option 10: Show stash diff

```
➤ Stash index to show diff (default 0): 0
```

Shows what changes are saved in that stash (full diff).

### Option 11: Create branch from stash

Creates a new branch at the commit where the stash was made, then applies it. Very useful when a stash now conflicts with your current branch.

```
➤ Stash index: 0
➤ New branch name: feature/revived-work
```

```bash
git stash branch feature/revived-work stash@{0}
```

---

## Module 4 — Cherry-Pick 🍒

**What is cherry-pick?**  
Takes a specific commit from one branch and applies it to your current branch, without merging the entire branch.

### Option 1: Cherry-pick single commit

The script shows your recent 15 commits first:

```
abc1234 Fix payment calculation bug
def5678 Add user profile page
ghi9012 Update README

➤ Commit SHA: abc1234
```

```bash
git cherry-pick abc1234
```

### Option 2: Cherry-pick a range of commits

Picks all commits from `from` (exclusive) to `to` (inclusive).

```
➤ From SHA (oldest, exclusive): abc1234
➤ To SHA (newest, inclusive):   ghi9012
```

```bash
git cherry-pick abc1234..ghi9012
```

### Option 3: Cherry-pick from another branch (tip)

Picks only the latest commit of another branch.

```
➤ Branch name: hotfix/payment
ℹ Tip commit: xyz9999
❓ Cherry-pick this? [y/N]: y
```

### Option 4: Cherry-pick without committing

Applies the changes as staged but does **not** create a commit. Useful when you want to cherry-pick and then amend before committing.

```
➤ Commit SHA: abc1234
```

```bash
git cherry-pick -n abc1234
```

### Options 5 / 6 / 7: Conflict resolution

If cherry-pick hits a conflict:

1. Resolve the conflict in your editor
2. Stage the resolved files: `git add <file>`
3. Come back and choose **Option 5 (Continue)**

Or choose **Option 6 (Abort)** to undo the cherry-pick entirely.  
Or choose **Option 7 (Skip)** to skip that commit and continue.

---

## Module 5 — Rebase ♻️

**What is rebase?**  
Moves your branch's commits on top of another branch, creating a cleaner linear history.

> ⚠️ Never rebase commits that have already been pushed to a shared remote branch.

### Option 1: Rebase onto another branch

```
➤ Branch to rebase onto: main
❓ Rebase current branch onto 'main'? [y/N]: y
```

```bash
git rebase main
```

**Before rebase:**
```
main:    A - B - C
feature:         D - E
```

**After rebase:**
```
main:    A - B - C
feature:             D' - E'
```

### Option 2: Interactive rebase (last N commits)

Opens your default editor with a list of the last N commits. You can reorder, squash, edit, or drop them.

```
➤ How many commits back? (e.g. 3): 3
```

```bash
git rebase -i HEAD~3
```

**Editor opens with:**
```
pick abc1234 Add login page
pick def5678 Fix typo in login
pick ghi9012 Add tests for login

# Commands: pick, reword, edit, squash, fixup, drop
```

Change `pick` to `squash` on the last two lines to combine all three into one commit.

### Options 3 / 4 / 5: Conflict resolution

Same as cherry-pick — resolve conflicts, then Continue / Abort / Skip.

---

## Module 6 — Reset / Undo ⏪

### Option 1: Soft reset

Undoes the commit but keeps all changes **staged**.

```
➤ Reset to: HEAD~1
```

```bash
git reset --soft HEAD~1
```

Use case: You committed too early and want to re-do the commit with a better message.

### Option 2: Mixed reset

Undoes the commit and keeps changes **unstaged** (in working directory).

```
➤ Reset to: HEAD~2
```

```bash
git reset --mixed HEAD~2
```

### Option 3: Hard reset ⚠️

Undoes the commit AND discards all changes permanently.

```
➤ Reset to: HEAD~1
⚠ Hard reset will DISCARD all changes!
❓ Are you sure? [y/N]: y
```

```bash
git reset --hard HEAD~1
```

### Option 4: Unstage a file

```
➤ File to unstage: src/Login.java
```

```bash
git restore --staged src/Login.java
```

### Option 5: Discard changes in a file

```
➤ File to discard changes in: src/Login.java
❓ Discard all changes in 'src/Login.java'? [y/N]: y
```

```bash
git restore src/Login.java
```

### Option 6: Discard ALL unstaged changes ⚠️

```
⚠ This will discard ALL unstaged changes!
❓ Proceed? [y/N]: y
```

```bash
git restore .
```

### Option 7: Undo last commit (keep changes staged)

One-click shortcut for `git reset --soft HEAD~1`.

### Option 8: Revert a commit (safe)

Creates a **new commit** that reverses the changes of a previous commit. Safe to use on shared branches because it doesn't rewrite history.

```
➤ Commit SHA to revert: abc1234
```

```bash
git revert abc1234
```

### Option 9: Clean untracked files

Shows untracked files first, then asks confirmation before deleting.

```
ℹ Untracked files:
  temp.log
  build/output.jar
❓ Delete all untracked files? [y/N]: y
```

```bash
git clean -fd
```

---

## Module 7 — Tags & Releases 🏷️

### Option 1: List all tags

Shows tags sorted by version number (newest first).

```
v2.1.0
v2.0.0
v1.9.5
```

### Option 2: Create lightweight tag

A simple pointer to a commit — no message.

```
➤ Tag name: v2.2.0
```

```bash
git tag v2.2.0
```

### Option 3: Create annotated tag

Includes a message, tagger name, and date. Recommended for releases.

```
➤ Tag name: v2.2.0
➤ Tag message: Release v2.2.0 — added payment module
```

```bash
git tag -a v2.2.0 -m "Release v2.2.0 — added payment module"
```

### Option 4: Push a specific tag

```
➤ Tag to push: v2.2.0
```

```bash
git push origin v2.2.0
```

### Option 5: Push all tags

```
❓ Push ALL tags to remote? [y/N]: y
```

```bash
git push origin --tags
```

### Option 6 / 7: Delete tags

| Option | Deletes |
|--------|---------|
| 6 | Local tag only |
| 7 | Remote tag on GitHub |

### Option 8: Checkout a tag

Puts you in "detached HEAD" state at that tag's commit. Good for reviewing old releases.

```
➤ Tag to checkout: v1.9.5
```

### Option 9: Create GitHub Release from tag

```
➤ Tag name for the release: v2.2.0
➤ Release notes: Adds payment module and fixes login bug
❓ Mark as pre-release? [y/N]: n
❓ Mark as latest? [y/N]: y
```

```bash
# Equivalent
gh release create v2.2.0 --notes "Adds payment module and fixes login bug" --latest
```

### Option 10: List GitHub Releases

Shows all releases on GitHub with their tag, title, and date.

---

## Module 8 — Create Pull Request 🚀

### Full walkthrough example

**Scenario:** You are on `feature/user-profile` and want to open a PR into `main`.

**Step 1:** The script detects if the branch is pushed. If not:
```
⚠ Branch 'feature/user-profile' is not on remote.
❓ Push now? [y/N]: y
✔ Branch pushed.
```

**Step 2:** Fill in the details:
```
➤ Base branch: main
➤ PR Title: Add user profile page
```

**Step 3:** Choose body input method:
```
  1) Type inline (single line)
  2) Open in editor (with template)
Choose [1-2]: 2
```

Choosing **option 2** opens your editor (`nano` by default) with this pre-filled template:

```markdown
## Description
<!-- What does this PR do? -->

## Changes Made
<!-- List the key changes -->

## Testing Done
<!-- How was this tested? -->

## Screenshots (if applicable)
<!-- Add screenshots here -->

## Checklist
- [ ] Code reviewed
- [ ] Tests added/updated
- [ ] Documentation updated
```

Fill it in, save and close the editor.

**Step 4:** Additional options:
```
❓ Mark as Draft? [y/N]: n
➤ Reviewers: john,sarah
➤ Labels: feature,frontend
➤ Assignees: @me
➤ Milestone: Sprint-5
```

**Result:** PR is created and the URL is printed in the terminal.

---

## Module 9 — Review Pull Request 🔍

### Option 1: List open PRs

```
#42  Add user profile page    feature/user-profile  about 2 hours ago
#38  Fix payment bug          bugfix/payment         about 1 day ago
```

### Option 2: List all PRs with filter

```
  1) Open  2) Closed  3) Merged  4) All
```

### Option 3: View PR details

```
➤ PR number: 42
```

Shows full PR info: title, body, labels, reviewers, CI status.

### Option 4: View PR diff

```
➤ PR number: 42
```

Shows the full code diff of the PR in the terminal.

### Option 5: Checkout PR locally

Downloads and checks out the PR's branch locally so you can run/test it.

```
➤ PR number to checkout: 42
✔ PR #42 checked out locally.
```

```bash
# Equivalent
gh pr checkout 42
```

### Option 6: Approve PR

```
➤ PR number to approve: 42
➤ Approval comment (optional): Looks great! Ship it.
✔ PR #42 approved.
```

### Option 7: Request changes

```
➤ PR number: 42
➤ Change request feedback: Please add unit tests for the new profile service.
✔ Change request submitted on PR #42.
```

### Option 8: Comment on PR

```
➤ PR number: 42
➤ Comment: Can we extract this logic into a helper method?
✔ Comment added.
```

### Option 9: View PR checks / CI status

```
➤ PR number: 42
```

Shows all CI checks (GitHub Actions, etc.) and their pass/fail status.

### Option 10: Mark ready for review (un-draft)

```
➤ PR number to mark ready: 42
✔ PR #42 marked as ready for review.
```

### Option 11: Convert PR to Draft

```
➤ PR number to convert to draft: 42
✔ PR #42 converted to draft.
```

---

## Module 10 — Merge Pull Request 🔀

### Option 2: Merge commit

Preserves all commits from the branch with a merge commit.

```
➤ PR number to merge: 42
❓ Delete source branch after merge? [y/N]: y
❓ Enable auto-merge when checks pass? [y/N]: n
✔ PR #42 merged.
```

```bash
gh pr merge 42 --merge --delete-branch
```

### Option 3: Squash and merge

Combines all PR commits into a single commit on the base branch. Cleaner history.

```
➤ PR number to squash-merge: 42
❓ Delete branch after merge? [y/N]: y
```

```bash
gh pr merge 42 --squash --delete-branch
```

### Option 4: Rebase and merge

Replays each PR commit on top of the base branch. Linear history, no merge commit.

```
➤ PR number to rebase-merge: 42
```

```bash
gh pr merge 42 --rebase
```

### Option 5: Close PR (without merging)

```
➤ PR number to close: 42
❓ Close PR #42 without merging? [y/N]: y
```

### Option 6: Reopen a closed PR

```
➤ PR number to reopen: 42
✔ PR #42 reopened.
```

---

## Module 11 — Log & History 📜

### Option 1: Recent commits (pretty)

```
➤ How many commits? (default 20): 10
```

**Example output:**
```
abc1234 (HEAD -> feature/profile) Add avatar upload
def5678 Add profile form validation
ghi9012 (origin/main) Fix login redirect
```

### Option 2: Full log with graph

Visualises branch merges and divergences.

```
* abc1234 (HEAD) Add avatar
| * def5678 (feature/other) Another feature
|/
* ghi9012 Base commit
```

### Option 3: Log for a specific file

```
➤ File path: src/UserProfile.java
```

Shows every commit that touched that file.

### Option 4: Log between two branches

```
➤ From branch: main
➤ To branch: feature/profile
```

Shows commits in `feature/profile` that are not in `main`.

### Option 5: Search commits by message

```
➤ Search keyword: payment
```

```bash
git log --oneline --grep="payment"
```

### Option 6: Search commits by author

```
➤ Author name or email: john
```

### Option 7: Show a specific commit

```
➤ Commit SHA: abc1234
```

Shows full diff, author, date, and message for that commit.

### Option 8: Commits not yet in target branch

```
➤ Target branch: main
```

Shows commits on your current branch that haven't been merged into `main` yet.

### Option 9: Reflog

Shows local history including resets, rebases, and checkouts — very useful for recovering lost commits.

```
abc1234 HEAD@{0}: commit: Add avatar upload
def5678 HEAD@{1}: reset: moving to HEAD~1
ghi9012 HEAD@{2}: commit: Add profile form
```

---

## Module 12 — Diff 🔎

### Option 1: Diff working directory (unstaged)

Shows changes you've made but haven't staged yet.

```bash
git diff
```

### Option 2: Diff staged changes

Shows what will be in your next commit.

```bash
git diff --cached
```

### Option 3: Diff between two branches

```
➤ Branch 1: main
➤ Branch 2: feature/profile
```

```bash
git diff main..feature/profile
```

### Option 4: Diff between two commits

```
➤ Commit SHA 1: abc1234
➤ Commit SHA 2: def5678
```

### Option 5: Diff a specific file

```
➤ File path: src/UserProfile.java
➤ Compare with (e.g. HEAD, main, SHA — or blank for unstaged): main
```

```bash
git diff main -- src/UserProfile.java
```

### Option 6: Word-level diff

Highlights changed words instead of whole lines — great for documentation changes.

```bash
git diff --word-diff
```

**Example output:**
```
The [-old text-]{+new text+} was updated here.
```

---

## Module 13 — Remote Operations 🌐

### Option 1: List remotes

```
origin    https://github.com/yourorg/repo.git (fetch)
origin    https://github.com/yourorg/repo.git (push)
```

### Option 2: Add remote

Useful when contributing to a forked repository (add the original as `upstream`).

```
➤ Remote name: upstream
➤ Remote URL: https://github.com/original-org/repo.git
```

```bash
git remote add upstream https://github.com/original-org/repo.git
```

### Option 3 / 4: Remove / Rename remote

```
➤ Remote name to remove: old-origin
❓ Remove remote 'old-origin'? [y/N]: y
```

### Option 5: Fetch all remotes

Downloads all latest changes from all remotes without merging.

```bash
git fetch --all
```

### Option 6: Fetch specific remote

```
➤ Remote to fetch: upstream
```

### Option 7: Pull with rebase

Fetches and replays your local commits on top of the upstream changes. Cleaner than a regular pull merge.

```bash
git pull --rebase
```

### Option 8: Show remote info

```
➤ Remote name: origin
```

Shows tracked branches, fetch/push URLs, and whether branches are up to date.

---

## Module 14 — GitHub Issues 🐛

### Option 1: List open issues

```
#15  Login button broken        bug       opened 2 days ago by alice
#12  Add dark mode support      feature   opened 5 days ago by bob
```

### Option 2: View an issue

```
➤ Issue number: 15
```

Shows full issue details, body, comments, labels, and assignees.

### Option 3: Create an issue

```
➤ Issue title: Payment gateway timeout on large orders
➤ Issue body: When order total exceeds $1000, the payment call times out after 30s.
➤ Label (optional): bug
```

```bash
gh issue create --title "Payment gateway timeout on large orders" \
  --body "When order total exceeds $1000..." --label "bug"
```

### Option 4 / 5: Close / Reopen an issue

```
➤ Issue number to close: 15
✔ Issue #15 closed.
```

### Option 6: Comment on an issue

```
➤ Issue number: 15
➤ Comment: Reproduced locally. The timeout is in the PaymentService.java line 234.
✔ Comment added.
```

### Option 7: Assign issue to yourself

```
➤ Issue number: 15
✔ Assigned to you.
```

---

## Module 15 — Quick Status Dashboard 📊

A one-stop view of everything at once. No inputs needed — just select option 15.

**Example output:**
```
── Git Status ──────────────────────────
M  src/UserProfile.java
?? temp.log

── Current Branch ──────────────────────
feature/user-profile

── Recent Commits ──────────────────────
abc1234 (HEAD) Add avatar upload
def5678 Add profile form validation
ghi9012 Fix login redirect

── Active Stashes ──────────────────────
stash@{0}: WIP - half done user profile form

── Remotes ─────────────────────────────
origin  https://github.com/yourorg/repo.git

── My PR Status ────────────────────────
Relevant pull requests in yourorg/repo

Current branch
  #42  Add user profile page  [open]

── Issues Assigned to Me ───────────────
#15  Login button broken   bug   2 days ago
```

---

## Real-World Workflows

### Workflow 1: Start a new feature

```
Main Menu → 2 (Branch) → 1 (Create new branch)
  Base: main
  Name: feature/shopping-cart

Main Menu → 13 (Remote) → 9 (Push branch)
  # Work on your code in IntelliJ...

Main Menu → 8 (Create PR)
  Base: main
  Title: Add shopping cart feature
```

### Workflow 2: Hotfix on production

```
Main Menu → 1 (Worktree) → 1 (Add new worktree)
  Branch: hotfix/payment-crash
  Path: ../hotfix-work
  # Fix the bug in the new directory without disturbing your feature branch

Main Menu → 7 (Tags) → 3 (Annotated tag): v2.1.1
Main Menu → 7 (Tags) → 4 (Push tag): v2.1.1
Main Menu → 7 (Tags) → 9 (GitHub Release): v2.1.1
```

### Workflow 3: Pick a bug fix from another branch

```
Main Menu → 4 (Cherry-Pick) → 1 (Single commit)
  # Copy just the fix commit, not the whole branch

Main Menu → 8 (Create PR)
  # Open PR with the cherry-picked fix
```

### Workflow 4: Clean up a messy commit history before PR

```
Main Menu → 5 (Rebase) → 2 (Interactive, last 4 commits)
  # Squash 4 commits into 1 clean commit in the editor

Main Menu → 13 (Remote) → 9 (Push with force — run manually if needed)
  git push --force-with-lease origin feature/my-branch
```

### Workflow 5: Recover a lost commit

```
Main Menu → 11 (Log) → 9 (Reflog)
  # Find the lost commit SHA in the reflog

Main Menu → 4 (Cherry-Pick) → 1 (Single commit)
  # Apply the recovered commit to your branch
```

### Workflow 6: Full review cycle

```
Main Menu → 9 (Review PR) → 1 (List open PRs)
Main Menu → 9 (Review PR) → 5 (Checkout PR locally)
  # Run and test the code in IntelliJ

Main Menu → 9 (Review PR) → 6 (Approve PR)
  # Or option 7 to request changes

Main Menu → 10 (Merge PR) → 3 (Squash and merge)
```

---

## Tips & Tricks

**Use IntelliJ terminal:** Press `Alt + F12` to open the terminal inside IntelliJ. Run the script there so you never leave your IDE.

**Set your preferred editor:** If you prefer VS Code or vim for PR bodies:
```bash
export EDITOR=vim      # add to ~/.bashrc
export EDITOR=code     # for VS Code (opens and waits)
```

**Auto-merge PRs:** When creating a merge in Module 10, enable auto-merge so GitHub merges automatically once all CI checks pass — no need to come back.

**Recover from hard reset:** If you accidentally hard reset, open Module 11 → Option 9 (Reflog) to find the previous HEAD SHA, then cherry-pick or reset back to it.

**Stash before switching tasks:** Always stash (Module 3 → Option 2) before switching to a different task. Name your stash with a clear message so you remember what's in it.

**Prune worktrees regularly:** After removing worktree directories manually, run Module 1 → Option 6 (Prune) to keep Git's internal references clean.

**Check CI before merging:** Always run Module 9 → Option 9 (PR checks) before merging to confirm all tests pass.
