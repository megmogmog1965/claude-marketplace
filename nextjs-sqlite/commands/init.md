---
description: Initialize Next.js + SQLite project with Claude Code configuration files
---

# Init Command

Initialize this Next.js + SQLite project with the necessary Claude Code configuration files.

## Task

Create the following files in the user's working directory:

1. `CLAUDE.md` - Main configuration file with links to documentation
2. `docs/software-development-lifecycle.md` - Development process and procedures
3. `docs/coding-rule.md` - Coding standards and conventions
4. `docs/architecture.md` - Technology stack and architecture specifications
5. `docs/test-rule.md` - Unit test code generation rules
6. `docs/ui-design-rule.md` - Frontend code and UI design guidelines

## Instructions

1. **Locate the plugin directory** that contains the template files
   - Templates are in `<plugin-dir>/templates/`

2. **Check existing files** in the user's working directory
   - Check if `CLAUDE.md` exists
   - Check if `docs/` directory exists
   - Check if any of the docs/*.md files already exist

3. **Ask user for confirmation if files exist**
   - If any files already exist, ask the user whether to overwrite them
   - List which files would be overwritten

4. **Create necessary directories**
   - Create `docs/` directory in the user's working directory if it doesn't exist
   - Use the appropriate method (e.g., `mkdir -p docs` or equivalent) to ensure the directory is created

5. **Copy template files** to the user's working directory
   - Read each template file from `<plugin-dir>/templates/`
   - Write each file to the user's working directory with the same relative path

   Template files to copy:
   - `templates/CLAUDE.md` → `CLAUDE.md`
   - `templates/docs/software-development-lifecycle.md` → `docs/software-development-lifecycle.md`
   - `templates/docs/coding-rule.md` → `docs/coding-rule.md`
   - `templates/docs/architecture.md` → `docs/architecture.md`
   - `templates/docs/test-rule.md` → `docs/test-rule.md`
   - `templates/docs/ui-design-rule.md` → `docs/ui-design-rule.md`

6. **Verify all files were created successfully**

7. **Report completion to the user**
   - List all files that were created
   - List all directories that were created (if any)
   - Provide next steps (e.g., "Run `/req` to create your first requirement")

## Finding the Plugin Directory

The plugin directory path can be determined by:
- Using the `CLAUDE_PLUGIN_PATH` environment variable if available
- Or looking for the plugin in the Claude Code plugins directory (typically `~/.config/claude/plugins/nextjs-sqlite/`)
- Or using the current file's location to determine the plugin root

After creating all files, confirm completion to the user with a summary of what was created.
