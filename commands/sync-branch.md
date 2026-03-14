# Sync Branch After PR Merge

PR 合并后同步本地分支到远程最新代码。

## Execution rules (IMPORTANT)

- NEVER combine `cd` with output redirections (`2>/dev/null`, `>/dev/null`, `| ...`) in a single compound bash command. This triggers Claude Code safety prompts and blocks autonomous execution.
- Instead, either: (a) run commands without `cd` (use repo root as working directory), or (b) split into separate Bash calls.
- Do NOT append `|| echo "..."` fallbacks — handle errors in your logic instead.

## Instructions

1. 获取远程最新代码并重置本地分支：

```bash
git fetch origin claude/event-recording-search-app-fh3vy && git reset --hard origin/claude/event-recording-search-app-fh3vy
```

2. 显示最新提交确认同步成功：

```bash
git log --oneline -5
```

## Note

- 此命令会丢弃本地未提交的更改
- 适用于 PR 已合并后同步本地分支
- 目标分支: `claude/event-recording-search-app-fh3vy`
