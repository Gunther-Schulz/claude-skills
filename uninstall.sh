#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_SRC="$SCRIPT_DIR/commands"
COMMANDS_DST="$HOME/.claude/commands"

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo "Uninstalling claude-skills..."

for file in "$COMMANDS_SRC"/*.md; do
    name="$(basename "$file")"
    target="$COMMANDS_DST/$name"

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$file" ]; then
        rm "$target"
        echo -e "  ${GREEN}removed${NC} $name"
    elif [ -L "$target" ]; then
        echo -e "  ${YELLOW}skipped${NC} $name (symlink points elsewhere)"
    elif [ -f "$target" ]; then
        echo -e "  ${YELLOW}skipped${NC} $name (regular file, not our symlink)"
    else
        echo -e "  ${YELLOW}skipped${NC} $name (not installed)"
    fi
done

echo ""
echo "Note: the classifier hook in settings.json must be removed manually if added."
