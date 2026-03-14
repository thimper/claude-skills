# Context: Create Branch Smartly
# Usage: /new-branch <description>

## Execution rules (IMPORTANT)

- NEVER combine `cd` with output redirections (`2>/dev/null`, `>/dev/null`, `| ...`) in a single compound bash command. This triggers Claude Code safety prompts and blocks autonomous execution.
- Instead, either: (a) run commands without `cd` (use repo root as working directory), or (b) split into separate Bash calls.
- Do NOT append `|| echo "..."` fallbacks — handle errors in your logic instead.

Step 1: Analyze the user's input arguments as the "Requirement".
   - (If input is empty, ask for requirement first).

Step 2: Based on the requirement, IMMEDIATELY propose 3 distinct, kebab-case branch names (e.g., `feat/...`, `fix/...`).

Step 3: Ask me to pick a number (1-3) OR type a custom name.

Step 4: Once I reply with a selection or name:
   - Determine the base branch using this priority:
     1. If `$ARGUMENTS` contains `--base <branch>`, use it.
     2. Read `.claude/workspace.json` → use `base_branch` field if it exists.
     3. If neither exists:
        - Run `git fetch --all` then `git branch -r --list 'origin/*' --format='%(refname:short)' | sed 's|origin/||' | head -20` to list remote branches.
        - Present the branches as a numbered list and ask: "默认基础分支是哪个？请选择编号或输入分支名："
        - Save the answer to `.claude/workspace.json` as `{"base_branch": "<answer>"}`.
   - Run `git fetch origin <BASE_BRANCH>`
   - Run `git checkout -b <FINAL_BRANCH_NAME> origin/<BASE_BRANCH>`
   - This automatically sets the upstream tracking, so downstream commands (`/gh-pr`, `/rebase-api`, `/sync-branch`) can auto-detect the base branch.
