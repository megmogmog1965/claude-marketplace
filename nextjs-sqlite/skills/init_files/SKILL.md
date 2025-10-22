---
name: init_files
description: "Create CLAUDE.md and related files when CLAUDE.md does not exist"
---

# Init Files Skill

**⚠️ CRITICAL: This skill copies files using a bash script. Do NOT use Read/Write tools directly. ⚠️**

## Skill Directory Structure

This skill is located in the plugin with the following structure:

```
skills/init_files/
├── SKILL.md (this file)
├── scripts/
│   └── copy_files.sh     ← The copy script (in the plugin directory)
└── templates/
    ├── CLAUDE.md
    └── docs/
        ├── software-development-lifecycle.md
        ├── coding-rule.md
        ├── architecture.md
        ├── test-rule.md
        └── ui-design-rule.md
```

**IMPORTANT**: The `scripts/copy_files.sh` file is located in the **plugin directory**, NOT in the user's working directory.

## Overview

This skill sets up a Next.js + SQLite project by copying configuration template files. It uses a bash script (following the official Anthropic `artifacts-builder` pattern).

## Steps to Execute

### Step 1: Check for Existing Files

Check if `CLAUDE.md` exists:

```bash
test -f CLAUDE.md && echo "EXISTS" || echo "NOT_FOUND"
```

If it exists, ask the user if they want to overwrite it.

### Step 2: Create docs/ Directory

Ensure the `docs/` directory exists:

```bash
mkdir -p docs
```

### Step 3: Execute Copy Script

**THIS IS THE MOST IMPORTANT STEP - DO NOT SKIP THIS**

**Locate the script in the plugin directory:**

The script is at: `skills/init_files/scripts/copy_files.sh` (relative to plugin root)

You need to find it using an absolute path. Use one of these methods:

**Method 1 (Recommended): Use find command**
```bash
SCRIPT=$(find ~/.config/claude -type f -path "*/nextjs-sqlite/skills/init_files/scripts/copy_files.sh" 2>/dev/null | head -1)
bash "$SCRIPT"
```

**Method 2: Direct absolute path (if you know the plugin location)**
```bash
bash /Users/.../nextjs-sqlite/skills/init_files/scripts/copy_files.sh
```

**CRITICAL RULES FOR THIS STEP:**
- ❌ Do NOT use `bash scripts/copy_files.sh` (relative path - will fail!)
- ❌ Do NOT use the Read tool to read template files
- ❌ Do NOT use the Write tool to create files manually
- ❌ Do NOT try to copy files yourself
- ✅ ONLY execute the script using an absolute path (Method 1 or Method 2)

The script will copy these files:
- `CLAUDE.md`
- `docs/software-development-lifecycle.md`
- `docs/coding-rule.md`
- `docs/architecture.md`
- `docs/test-rule.md`
- `docs/ui-design-rule.md`

### Step 4: Verify Success

Verify all files were created:

```bash
ls -lh CLAUDE.md
ls -lh docs/*.md
```

### Step 5: Report Completion

Report to the user:

```
✅ Successfully initialized Next.js + SQLite project with Claude Code configuration!

Created files:
  ✓ CLAUDE.md
  ✓ docs/software-development-lifecycle.md
  ✓ docs/coding-rule.md
  ✓ docs/architecture.md
  ✓ docs/test-rule.md
  ✓ docs/ui-design-rule.md

Next steps:
  1. Review CLAUDE.md to understand the project structure
  2. Run `/req` to create your first requirement document
  3. Start development with `npm run dev`
```

## Error Handling

If the script execution fails:
- Report the error message
- Check that the plugin is properly installed
- Suggest manual installation as fallback

## Notes

- The script uses `${BASH_SOURCE[0]}` to locate the plugin directory
- Files are copied byte-for-byte with no modifications
- This follows the official Anthropic pattern used in `artifacts-builder`
