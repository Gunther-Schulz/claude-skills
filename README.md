# claude-skills

Reusable quality checklists for Claude Code, delivered as slash commands with an optional smart classifier hook.

## Skills

| Command | When to use |
|---------|-------------|
| `/code-quality` | Before writing or modifying code — requirements review, consumer analysis, fallback tracing, pattern search |
| `/critical-thinking` | During investigation, debugging, or analysis — claim verification, backward traces, hypothesis testing |
| `/critical-evaluation` | When evaluating proposals — challenge assumptions before agreeing |

## Installation

```bash
git clone https://github.com/Gunther-Schulz/claude-skills.git
cd claude-skills
./install.sh
```

This symlinks the command files to `~/.claude/commands/`, making them available as slash commands in all Claude Code sessions.

### Classifier hook (optional)

The classifier hook automatically detects what kind of task a user prompt involves and reminds Claude to run the relevant skill before proceeding. It uses Haiku for fast, cheap classification on every prompt.

To see the hook config:

```bash
./install.sh --hook
```

Then add the output to the `hooks.UserPromptSubmit` array in `~/.claude/settings.json`.

## Updating

```bash
cd claude-skills
git pull
```

Since the installer uses symlinks, pulling new changes updates the skills immediately.

## Uninstalling

```bash
./uninstall.sh
```

Removes the symlinks. Does not modify `settings.json` — remove the classifier hook manually if added.

## Customization

Edit the files in `commands/` directly, or add new `.md` files. The installer will pick up any `.md` file in the `commands/` directory.

### Adding to CLAUDE.md (recommended)

Add condensed references to your global `~/.claude/CLAUDE.md` so Claude is aware of the skills even without the classifier hook:

```markdown
## Critical thinking
Verify claims, trace before fixing, investigate contradictions. Full rules: `/critical-thinking`

## Code quality
List requirements before coding, check consumers before modifying interfaces, trace fallbacks, search for patterns. Full rules: `/code-quality`

## Critical evaluation
Challenge proposals before agreeing — state concerns, alternatives, or unstated assumptions. Full rules: `/critical-evaluation`
```

## License

MIT
