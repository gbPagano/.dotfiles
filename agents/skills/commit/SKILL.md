---
name: commit
description: Writes git commit messages following Conventional Commits. Use whenever the user asks to commit changes, write or generate a commit message, or asks what a commit should say. Only produces the message text — never creates the commit itself.
---

# Commit messages

## The one hard rule

**Never make the commit.** Never run `git commit`, `git commit --amend`, or any
command/tool that creates or rewrites commits — even if the user asks to
"commit". Always answer with the message text only, in a fenced code block,
so the user can run it themselves. Never stage files unless explicitly asked.

## Writing the message

1. Gather context with read-only commands. Scope the message to what the
   commit would actually include:
   - If something is staged, describe **only** the staged changes
     (`git diff --staged`) and ignore unstaged work.
   - If nothing is staged, assume everything goes in: `git diff HEAD` plus
     any untracked files from `git status --short`.
   - Check `git log --oneline -10` for house style.
2. Format — Conventional Commits:

   ```
   type(scope): subject
   ```

   - `type`: feat, fix, chore, docs, refactor, perf, test, style, ci, build
   - `scope`: optional; pick from the area touched (match repo history)
3. Subject:
   - English, imperative mood, all lowercase, no trailing period
   - ≤ 50 chars when possible, hard max 72
4. Body: only when the subject alone is not enough. Separate from the subject
   with a blank line, wrap at 72, explain **why** — not what. Keep it short;
   omit it entirely when the subject suffices.
5. If the changes mix unrelated concerns, propose one message per logical
   group and suggest the user split the commit.

## Examples

```
feat(agents): version skills in the ~/.agents/skills standard
```

```
fix(niri): include dms outputs

DMS overwrites output config on startup, so the managed outputs
must be part of the tracked config.
```
