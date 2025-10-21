#!/bin/bash

# Exit on error
set -e

# Get the directory where this script is located (following official pattern)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Templates directory is relative to the script location
TEMPLATES_DIR="$SCRIPT_DIR/../templates"

# Verify templates directory exists
if [ ! -d "$TEMPLATES_DIR" ]; then
    echo "❌ Error: Templates directory not found at $TEMPLATES_DIR"
    exit 1
fi

echo "📁 Copying template files to current directory..."

# Copy CLAUDE.md
echo "  Copying CLAUDE.md..."
cp "$TEMPLATES_DIR/CLAUDE.md" ./CLAUDE.md

# Copy docs files
echo "  Copying docs/software-development-lifecycle.md..."
cp "$TEMPLATES_DIR/docs/software-development-lifecycle.md" ./docs/software-development-lifecycle.md

echo "  Copying docs/coding-rule.md..."
cp "$TEMPLATES_DIR/docs/coding-rule.md" ./docs/coding-rule.md

echo "  Copying docs/architecture.md..."
cp "$TEMPLATES_DIR/docs/architecture.md" ./docs/architecture.md

echo "  Copying docs/test-rule.md..."
cp "$TEMPLATES_DIR/docs/test-rule.md" ./docs/test-rule.md

echo "  Copying docs/ui-design-rule.md..."
cp "$TEMPLATES_DIR/docs/ui-design-rule.md" ./docs/ui-design-rule.md

echo "✅ All template files copied successfully!"
