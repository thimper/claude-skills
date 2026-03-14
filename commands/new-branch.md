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
   - Run `git fetch origin claude/event-recording-search-app-fh3vy`
   - Run `git checkout -b <FINAL_BRANCH_NAME> origin/claude/event-recording-search-app-fh3vy`
