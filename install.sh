#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_SRC="$SCRIPT_DIR/commands"
COMMANDS_DST="$HOME/.claude/commands"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo "Installing claude-skills..."

# Create target directory
mkdir -p "$COMMANDS_DST"

# Symlink each command file
for file in "$COMMANDS_SRC"/*.md; do
    name="$(basename "$file")"
    target="$COMMANDS_DST/$name"

    if [ -L "$target" ]; then
        # Already a symlink — update it
        ln -sf "$file" "$target"
        echo -e "  ${GREEN}updated${NC} $name"
    elif [ -f "$target" ]; then
        echo -e "  ${YELLOW}skipped${NC} $name (file exists, not a symlink — back up or remove it first)"
    else
        ln -s "$file" "$target"
        echo -e "  ${GREEN}installed${NC} $name"
    fi
done

echo ""
echo "Skills installed. Available commands:"
for file in "$COMMANDS_SRC"/*.md; do
    name="$(basename "$file" .md)"
    echo "  /$name"
done

echo ""
echo "Optional: add the classifier hook to your settings."
echo "Run: $SCRIPT_DIR/install.sh --hook"
echo ""

if [ "${1:-}" = "--hook" ]; then
    echo "Classifier hook configuration (add to hooks.UserPromptSubmit in ~/.claude/settings.json):"
    echo ""
    cat <<'HOOK'
{
    "hooks": [
        {
            "type": "prompt",
            "prompt": "Classify this user message. Output ONLY the applicable lines, nothing else. If none apply, output nothing.\n\n- If the user is asking to write, modify, or fix code: output 'Run /code-quality before writing code.'\n- If the user is asking to investigate, debug, analyze data, or verify claims: output 'Run /critical-thinking before proceeding.'\n- If the user is proposing an idea, approach, or design for evaluation: output 'Run /critical-evaluation before responding.'\n\nUser message: $ARGUMENTS",
            "model": "claude-haiku-4-5-20251001",
            "timeout": 10
        }
    ]
}
HOOK
    echo ""
    echo "Add this as an entry in the UserPromptSubmit array in ~/.claude/settings.json"
fi
