# Sync Branch After PR Merge

PR 合并后同步本地分支到远程最新代码。

## Execution rules (IMPORTANT)

- NEVER combine `cd` with output redirections (`2>/dev/null`, `>/dev/null`, `| ...`) in a single compound bash command. This triggers Claude Code safety prompts and blocks autonomous execution.
- Instead, either: (a) run commands without `cd` (use repo root as working directory), or (b) split into separate Bash calls.
- Do NOT append `|| echo "..."` fallbacks — handle errors in your logic instead.

## Step 0: Detect base branch

Determine the sync target using this priority:
1. If `$ARGUMENTS` contains a branch name, use it.
2. Detect from the current branch's upstream tracking: `git rev-parse --abbrev-ref @{upstream}` → strip the `origin/` prefix.
3. Fall back to the repo's default branch: `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`

Store the result as `BASE_BRANCH`.

## Instructions

1. 获取远程最新代码并重置本地分支：

```bash
git fetch origin $BASE_BRANCH && git reset --hard origin/$BASE_BRANCH
```

2. 显示最新提交确认同步成功：

```bash
git log --oneline -5
```

## Note

- 此命令会丢弃本地未提交的更改
- 适用于 PR 已合并后同步本地分支
- 目标分支自动从 upstream tracking 检测，也可通过参数手动指定
