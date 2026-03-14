# Context: Rebase current branch onto claude/event-recording-search-app-fh3vy

## Execution rules (IMPORTANT)

- NEVER combine `cd` with output redirections (`2>/dev/null`, `>/dev/null`, `| ...`) in a single compound bash command. This triggers Claude Code safety prompts and blocks autonomous execution.
- Instead, either: (a) run commands without `cd` (use repo root as working directory), or (b) split into separate Bash calls.
- Do NOT append `|| echo "..."` fallbacks — handle errors in your logic instead.

1. First, run `git status` to check if the working tree is clean.
   - If there are uncommitted changes, STOP and ask me if I want to stash or commit them first.

2. Run `git fetch origin claude/event-recording-search-app-fh3vy` to ensure we have the absolute latest code from the remote.

3. **ALWAYS** execute `git rebase origin/claude/event-recording-search-app-fh3vy`, even if `git status` says "up to date".
   - Note: We use the remote branch (`origin/...`) directly to avoid issues with outdated local branches.
   - **IMPORTANT**: Do NOT skip this step. `git status` "up to date" refers to the old tracking ref, NOT the freshly fetched remote. The fetch in step 2 may have pulled new commits that `git status` won't reflect. Always run the rebase unconditionally.

4. Check the result:
   - **If there are conflicts:** Do NOT ask me — resolve them yourself following these rules:
     1. Run `git status` to list all conflicting files.
     2. For each conflicting file, read the full file, carefully analyze both sides of the conflict (ours vs theirs).
     3. Merge intelligently: preserve the intent of both changes. If both sides modify the same logic, combine them logically. If one side deletes code that the other side modifies, prefer keeping the modification.
     4. After resolving, remove all conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`).
     5. Present a brief summary of each conflict file and how you resolved it (e.g., "file.ts: kept both feature A from ours and refactor from theirs").
     6. Run `git add <resolved-files>` then `git rebase --continue`.
     7. If new conflicts appear in subsequent commits, repeat the same process.
   - **If successful (no conflicts):** Run `git log --oneline -n 5` to show me the new history graph.
