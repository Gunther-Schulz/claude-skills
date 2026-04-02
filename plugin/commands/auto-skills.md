---
name: auto-skills
description: Manage the auto-skills classifier — toggle on/off, check status, or set sensitivity level.
allowed-tools: AskUserQuestion, Read, Edit, Write, Bash
disable-model-invocation: true
argument-hint: [status|toggle|low|normal|high]
---

Manage the auto-skills classifier.

Config: `.claude/auto-skills.local.md` (project) or `~/.claude/auto-skills.local.md` (global)
Log: `~/.local/state/claude-auto-skills/classifier.log`

Set the action to: $ARGUMENTS

If $ARGUMENTS is `status`, `toggle`, `low`, `normal`, or `high` — handle it directly without prompting.

Otherwise use AskUserQuestion:

Question: "What would you like to do?"
Header: "auto-skills"
Options:
  - Status (Show current config and recent classifier activity)
  - Toggle (Turn classifier on or off)
  - Set level (Change sensitivity: low, normal, or high)

---

## Config file location

Check for config in order:
1. `.claude/auto-skills.local.md` (project-level)
2. `~/.claude/auto-skills.local.md` (global)

If neither exists, create `~/.claude/auto-skills.local.md` with defaults before making changes.

The config uses YAML frontmatter. Key fields: `enabled`, `sensitivity`, `model`, `effort`, `debug_logger`.

---

## Status

Read the config file's YAML frontmatter and display:
- enabled (on/off)
- sensitivity (low/normal/high)
- model
- effort
- debug_logger (on/off)

Show the last 5 non-DEBUG lines from the log file (skip lines containing ` DEBUG |`).

---

## Toggle

Read `enabled` from the config frontmatter.
- If `true` or absent → set to `false`
- If `false` → set to `true`

Use sed to update the `enabled:` line in the YAML frontmatter. If missing, add it after the opening `---`.
Report the new state.

---

## Set level

If level is not already known from $ARGUMENTS, use AskUserQuestion:

Question: "Which sensitivity level?"
Header: "Level"
Options:
  - low (Only trigger on explicit action keywords: evaluate, investigate, implement, fix, etc.)
  - normal (Balanced — skips confirmations, discussions, git ops)
  - high (Trigger on anything plausible, only skip pure confirmations)

Update the `sensitivity:` line in the YAML frontmatter using sed. If missing, add it after `enabled:`.
Report the new level.
