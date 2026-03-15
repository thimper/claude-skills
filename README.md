# Claude Code Git Skills

A collection of Claude Code skills that automate common git workflows.

## Skills

| Skill | Command | Description |
|-------|---------|-------------|
| **new-branch** | `/new-branch <description>` | Create a new branch from base with smart naming suggestions |
| **gh-pr** | `/gh-pr [issue-numbers]` | Create a PR with auto-detected base branch, optional issue linking, and auto review monitoring |
| **gh-pr-watch** | `/gh-pr-watch [PR_NUMBER]` | Auto-monitor a PR: fix review comments, push fixes, reply to reviewers |
| **rebase-api** | `/rebase-api [branch]` | Rebase onto base branch with automatic conflict resolution |
| **sync-branch** | `/sync-branch [branch]` | Sync local branch to remote latest after PR merge |

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI installed
- [GitHub CLI](https://cli.github.com/) (`gh`) installed and authenticated
- Git configured with your user info

## Installation

### Quick Install

```bash
git clone <repo-url> ~/claude-skills/git-skills
~/claude-skills/git-skills/install.sh
```

This clones the repo into `~/claude-skills/git-skills` and appends a `claude` wrapper function to your `~/.zshrc`. The wrapper automatically passes all repos under `~/claude-skills/` as `--add-dir` to Claude Code.

### Manual Install

1. Clone this repo under `~/claude-skills/`:

```bash
mkdir -p ~/claude-skills
git clone <repo-url> ~/claude-skills/git-skills
```

2. Add the following function to your `~/.zshrc`:

```bash
claude() {
  local dirs=()
  for repo in ~/claude-skills/*/; do
    dirs+=(--add-dir "$repo")
  done
  command claude "${dirs[@]}" "$@"
}
```

3. Reload your shell:

```bash
source ~/.zshrc
```

All skills repos under `~/claude-skills/` will be automatically loaded by Claude Code. To add more skill collections, just clone them into `~/claude-skills/`.

## Usage

Inside Claude Code, type `/` to see available skills, or invoke directly:

```
/new-branch add user authentication
/gh-pr 42 implement login flow
/rebase-api
/sync-branch
```

## Workflow Example

A typical feature development flow:

1. `/new-branch add-payment-api` - create a feature branch
2. _(write code)_
3. `/gh-pr 15,23` - create PR linked to issues #15 and #23, auto-starts review monitoring
4. `/gh-pr-watch` runs automatically via `/loop`, fixing review comments and replying
5. After merge, `/sync-branch` to reset local to latest

## Uninstall

```bash
./install.sh --uninstall
```

This removes the repo directory and the `claude` wrapper function from `~/.zshrc`.
