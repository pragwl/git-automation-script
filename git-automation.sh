#!/bin/bash

# ============================================================
#   Git Automation Script
#   Operations: worktree, cherry-pick, create/merge/review PR
#   Requirements: git, gh (GitHub CLI)
# ============================================================

# ---------- Colors ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ---------- Helpers ----------
log()     { echo -e "${GREEN}[✔]${RESET} $1"; }
info()    { echo -e "${BLUE}[ℹ]${RESET} $1"; }
warn()    { echo -e "${YELLOW}[⚠]${RESET} $1"; }
error()   { echo -e "${RED}[✘]${RESET} $1"; }
heading() { echo -e "\n${BOLD}${CYAN}══════════════════════════════${RESET}"; echo -e "${BOLD}${CYAN}  $1${RESET}"; echo -e "${BOLD}${CYAN}══════════════════════════════${RESET}\n"; }
divider() { echo -e "${CYAN}──────────────────────────────${RESET}"; }

confirm() {
  read -rp "$(echo -e "${YELLOW}$1 [y/N]: ${RESET}")" ans
  [[ "$ans" =~ ^[Yy]$ ]]
}

prompt() {
  read -rp "$(echo -e "${BLUE}$1: ${RESET}")" val
  echo "$val"
}

check_deps() {
  local missing=0
  for cmd in git gh; do
    if ! command -v "$cmd" &>/dev/null; then
      error "'$cmd' is not installed. Please install it first."
      missing=1
    fi
  done
  [[ $missing -eq 1 ]] && exit 1

  if ! gh auth status &>/dev/null; then
    warn "Not logged in to GitHub CLI."
    info "Running: gh auth login"
    gh auth login || { error "Authentication failed."; exit 1; }
  fi
}

inside_git_repo() {
  git rev-parse --is-inside-work-tree &>/dev/null
}

require_git_repo() {
  if ! inside_git_repo; then
    error "Not inside a Git repository. Please cd into your repo first."
    exit 1
  fi
}

press_enter() {
  echo ""
  read -rp "$(echo -e "${CYAN}  Press Enter to continue...${RESET}")"
}

# ============================================================
#   1. WORKTREE OPERATIONS
# ============================================================
worktree_menu() {
  heading "Git Worktree"
  echo "  1) Add new worktree"
  echo "  2) List worktrees"
  echo "  3) Remove a worktree"
  echo "  4) Back"
  divider
  read -rp "$(echo -e "${BLUE}Choose [1-4]: ${RESET}")" choice

  case $choice in
    1)
      local branch path
      branch=$(prompt "Branch name for new worktree (new or existing)")
      path=$(prompt "Directory path to create worktree (e.g. ../my-feature)")

      if git show-ref --verify --quiet "refs/heads/$branch"; then
        info "Branch '$branch' exists. Checking it out in worktree..."
        git worktree add "$path" "$branch" && log "Worktree created at: $path"
      else
        if confirm "Branch '$branch' does not exist. Create it?"; then
          git worktree add -b "$branch" "$path" && log "New branch '$branch' + worktree created at: $path"
        fi
      fi
      ;;
    2)
      info "Current worktrees:"
      git worktree list
      ;;
    3)
      git worktree list
      local path
      path=$(prompt "Enter worktree path to remove")
      if confirm "Remove worktree at '$path'?"; then
        git worktree remove "$path" && log "Worktree removed."
      fi
      ;;
    4) return ;;
    *) warn "Invalid choice." ;;
  esac
  press_enter
}

# ============================================================
#   2. CHERRY-PICK OPERATIONS
# ============================================================
cherrypick_menu() {
  heading "Cherry-Pick"
  echo "  1) Cherry-pick a single commit"
  echo "  2) Cherry-pick a range of commits"
  echo "  3) Cherry-pick from another branch (pick tip commit)"
  echo "  4) Abort cherry-pick (if in conflict)"
  echo "  5) Continue cherry-pick (after resolving conflicts)"
  echo "  6) Back"
  divider
  read -rp "$(echo -e "${BLUE}Choose [1-6]: ${RESET}")" choice

  case $choice in
    1)
      info "Recent commits:"
      git log --oneline -15
      local sha
      sha=$(prompt "Enter commit SHA to cherry-pick")
      git cherry-pick "$sha" && log "Cherry-pick successful."
      ;;
    2)
      info "Recent commits:"
      git log --oneline -15
      local from to
      from=$(prompt "From commit SHA (oldest, exclusive)")
      to=$(prompt "To commit SHA (newest, inclusive)")
      git cherry-pick "${from}..${to}" && log "Range cherry-pick successful."
      ;;
    3)
      local branch
      git branch -a
      branch=$(prompt "Branch to pick tip commit from")
      local sha
      sha=$(git rev-parse "$branch")
      info "Tip commit of '$branch': $sha"
      if confirm "Cherry-pick this commit?"; then
        git cherry-pick "$sha" && log "Cherry-pick successful."
      fi
      ;;
    4)
      git cherry-pick --abort && log "Cherry-pick aborted."
      ;;
    5)
      git cherry-pick --continue && log "Cherry-pick continued."
      ;;
    6) return ;;
    *) warn "Invalid choice." ;;
  esac
  press_enter
}

# ============================================================
#   3. CREATE PULL REQUEST
# ============================================================
create_pr_menu() {
  heading "Create Pull Request"

  local current_branch
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  info "Current branch: ${BOLD}$current_branch${RESET}"

  # Ensure branch is pushed
  if ! git ls-remote --exit-code origin "$current_branch" &>/dev/null; then
    warn "Branch '$current_branch' is not pushed to origin."
    if confirm "Push it now?"; then
      git push -u origin "$current_branch" && log "Branch pushed."
    else
      error "Cannot create PR without pushing the branch."
      press_enter; return
    fi
  fi

  local base title body draft reviewers labels assignees

  base=$(prompt "Base branch to merge into (e.g. main, develop)")
  title=$(prompt "PR Title")

  info "Enter PR body (press Enter twice when done):"
  body=""
  while IFS= read -r line; do
    [[ -z "$line" && -z "$(echo "$body" | tail -c1)" ]] && break
    body+="$line"$'\n'
  done

  local cmd="gh pr create --base \"$base\" --title \"$title\" --body \"$body\""

  if confirm "Mark as Draft PR?"; then
    cmd+=" --draft"
  fi

  reviewers=$(prompt "Reviewers (comma-separated GitHub usernames, or leave blank)")
  [[ -n "$reviewers" ]] && cmd+=" --reviewer \"$reviewers\""

  labels=$(prompt "Labels (comma-separated, or leave blank)")
  [[ -n "$labels" ]] && cmd+=" --label \"$labels\""

  assignees=$(prompt "Assignees (comma-separated usernames, or @me, or leave blank)")
  [[ -n "$assignees" ]] && cmd+=" --assignee \"$assignees\""

  info "Running: $cmd"
  eval "$cmd" && log "Pull Request created successfully!" || error "Failed to create PR."
  press_enter
}

# ============================================================
#   4. REVIEW PULL REQUEST
# ============================================================
review_pr_menu() {
  heading "Review Pull Request"
  echo "  1) List open PRs"
  echo "  2) View a PR (details + diff)"
  echo "  3) Checkout a PR locally"
  echo "  4) Approve a PR"
  echo "  5) Request changes on a PR"
  echo "  6) Add a comment to a PR"
  echo "  7) Back"
  divider
  read -rp "$(echo -e "${BLUE}Choose [1-7]: ${RESET}")" choice

  case $choice in
    1)
      info "Open PRs:"
      gh pr list
      ;;
    2)
      gh pr list
      local pr
      pr=$(prompt "Enter PR number to view")
      gh pr view "$pr"
      echo ""
      if confirm "View the diff?"; then
        gh pr diff "$pr"
      fi
      ;;
    3)
      gh pr list
      local pr
      pr=$(prompt "Enter PR number to checkout locally")
      gh pr checkout "$pr" && log "Checked out PR #$pr locally."
      ;;
    4)
      gh pr list
      local pr body
      pr=$(prompt "Enter PR number to approve")
      body=$(prompt "Approval comment (optional)")
      if [[ -n "$body" ]]; then
        gh pr review "$pr" --approve --body "$body" && log "PR #$pr approved."
      else
        gh pr review "$pr" --approve && log "PR #$pr approved."
      fi
      ;;
    5)
      gh pr list
      local pr body
      pr=$(prompt "Enter PR number to request changes on")
      body=$(prompt "Feedback / change request message")
      gh pr review "$pr" --request-changes --body "$body" && log "Change request submitted on PR #$pr."
      ;;
    6)
      gh pr list
      local pr comment
      pr=$(prompt "Enter PR number to comment on")
      comment=$(prompt "Your comment")
      gh pr comment "$pr" --body "$comment" && log "Comment added to PR #$pr."
      ;;
    7) return ;;
    *) warn "Invalid choice." ;;
  esac
  press_enter
}

# ============================================================
#   5. MERGE PULL REQUEST
# ============================================================
merge_pr_menu() {
  heading "Merge Pull Request"
  echo "  1) List open PRs"
  echo "  2) Merge a PR (choose strategy)"
  echo "  3) Close a PR (without merging)"
  echo "  4) Back"
  divider
  read -rp "$(echo -e "${BLUE}Choose [1-4]: ${RESET}")" choice

  case $choice in
    1)
      gh pr list
      ;;
    2)
      gh pr list
      local pr
      pr=$(prompt "Enter PR number to merge")

      echo -e "\n${BOLD}Merge strategy:${RESET}"
      echo "  1) Merge commit"
      echo "  2) Squash and merge"
      echo "  3) Rebase and merge"
      read -rp "$(echo -e "${BLUE}Choose [1-3]: ${RESET}")" strategy

      local flag
      case $strategy in
        1) flag="--merge" ;;
        2) flag="--squash" ;;
        3) flag="--rebase" ;;
        *) warn "Invalid. Defaulting to merge commit."; flag="--merge" ;;
      esac

      if confirm "Delete source branch after merge?"; then
        flag+=" --delete-branch"
      fi

      gh pr merge "$pr" $flag && log "PR #$pr merged successfully!"
      ;;
    3)
      gh pr list
      local pr
      pr=$(prompt "Enter PR number to close")
      if confirm "Close PR #$pr without merging?"; then
        gh pr close "$pr" && log "PR #$pr closed."
      fi
      ;;
    4) return ;;
    *) warn "Invalid choice." ;;
  esac
  press_enter
}

# ============================================================
#   6. QUICK STATUS
# ============================================================
quick_status() {
  heading "Quick Status"
  info "Git Status:"
  git status -s
  divider
  info "Current Branch:"
  git rev-parse --abbrev-ref HEAD
  divider
  info "Recent Commits:"
  git log --oneline -8
  divider
  info "My PR Status:"
  gh pr status
  press_enter
}

# ============================================================
#   MAIN MENU
# ============================================================
main_menu() {
  while true; do
    clear
    echo -e "${BOLD}${CYAN}"
    echo "  ╔══════════════════════════════════╗"
    echo "  ║     Git Automation Script        ║"
    echo "  ║     Powered by gh CLI            ║"
    echo "  ╚══════════════════════════════════╝"
    echo -e "${RESET}"
    echo "  1)  🌲  Worktree Operations"
    echo "  2)  🍒  Cherry-Pick"
    echo "  3)  🚀  Create Pull Request"
    echo "  4)  🔍  Review Pull Request"
    echo "  5)  🔀  Merge Pull Request"
    echo "  6)  📊  Quick Status"
    echo "  7)  ❌  Exit"
    divider
    read -rp "$(echo -e "${BLUE}Choose [1-7]: ${RESET}")" choice

    case $choice in
      1) require_git_repo; worktree_menu ;;
      2) require_git_repo; cherrypick_menu ;;
      3) require_git_repo; create_pr_menu ;;
      4) require_git_repo; review_pr_menu ;;
      5) require_git_repo; merge_pr_menu ;;
      6) require_git_repo; quick_status ;;
      7) echo -e "\n${GREEN}Goodbye!${RESET}\n"; exit 0 ;;
      *) warn "Invalid option. Try again."; sleep 1 ;;
    esac
  done
}

# ---------- Entry Point ----------
check_deps
main_menu
