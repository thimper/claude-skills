# Context: Create a PR targeting claude/event-recording-search-app-fh3vy
# Usage: /gh-pr [issue-numbers] [optional-context]
# Examples:
#   /gh-pr              — create PR without linked issues
#   /gh-pr 12 34        — link issues #12 and #34
#   /gh-pr 12,34,56     — link issues #12, #34, and #56

## Execution rules (IMPORTANT)

- NEVER combine `cd` with output redirections (`2>/dev/null`, `>/dev/null`, `| ...`) in a single compound bash command. This triggers Claude Code safety prompts and blocks autonomous execution.
- Instead, either: (a) run commands without `cd` (use repo root as working directory), or (b) split into separate Bash calls.
- Do NOT append `|| echo "..."` fallbacks — handle errors in your logic instead.

Step 0: Parse the arguments — extract any numbers (separated by spaces, commas, or both) as GitHub issue numbers. Everything else is optional context.
- If NO issue numbers were provided, ask: "关联 issue 编号？(输入编号，或直接回车跳过)"
  - If user provides numbers, use them as issue numbers.
  - If user presses enter / says no / says skip, continue without issue numbers.

Step 1: Check if there are uncommitted changes (`git status`).
- If there are staged or unstaged tracked file changes, or untracked files that look project-relevant: list them and ask "要先提交这些修改吗？(y/n)"
  - If yes: stage the relevant files, commit (ask for commit message or auto-generate), then continue.
  - If no: continue without committing.

Step 2: Rebase onto the base branch before pushing.
- Run `git fetch origin claude/event-recording-search-app-fh3vy`
- Run `git rebase origin/claude/event-recording-search-app-fh3vy`
- **If there are conflicts:** Automatically resolve them following these rules:
  1. For each conflicting file, read the full conflict markers carefully.
  2. **Keep ALL changes from both sides** — merge both the base branch changes and the current branch changes together. Never discard either side's code.
  3. If both sides modified the same lines, integrate both changes logically (e.g. keep both new functions, combine both modifications). When in doubt, keep both versions.
  4. After resolving each file, `git add` it, then `git rebase --continue`.
  5. Repeat until the rebase completes.
  6. After all conflicts are resolved, briefly list what was merged (files and summary) so I can verify.
- **If successful (no conflicts):** Continue to Step 3.

Step 3: Execute `git push origin HEAD --force-with-lease` to ensure remote has the latest rebased code.

Step 4: Analyze the differences between the current branch and `claude/event-recording-search-app-fh3vy` (using `git log` and `git diff`).
- Based on this, generate a concise **Title** and a Markdown **Body** (bullet points of changes).
- If issue numbers were provided, append a "## Related Issues" section at the end of the Body:
  ```
  ## Related Issues
  Related to #12
  Related to #34
  ```
  Use `Related to #N` (not `Closes`/`Fixes`) — only reference the issues, do NOT auto-close them.

Step 5: Directly create the PR (no confirmation needed):
gh pr create --base claude/event-recording-search-app-fh3vy --title "<TITLE>" --body "<BODY>"

Step 6: After the PR is created successfully, capture the PR number from the output. Then immediately start autonomous monitoring:

> PR #<NUMBER> 已创建，启动自动监控评审模式...

Invoke `/loop 1m /gh-pr-watch <NUMBER>` to begin the autonomous review-fix-reply loop. This will poll every 1 minute, automatically fix review comments, push commits, reply to reviewers, and stop when the PR is merged or closed.