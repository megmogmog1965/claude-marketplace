---
description: Initialize Next.js + SQLite project with Claude Code configuration files
---

# Init Command

**Execute the `init_files` skill to set up the project.**

Use the Skill tool to invoke the `init_files` skill:

```
Skill tool with command: init_files
```

The skill will:
- Check for existing files
- Create the `docs/` directory if needed
- Copy all template files using a bash script
- Verify all files were created successfully

Files that will be created:
- `CLAUDE.md` - Main configuration file
- `docs/software-development-lifecycle.md` - Development process
- `docs/coding-rule.md` - Coding standards
- `docs/architecture.md` - Technology stack
- `docs/test-rule.md` - Unit testing guidelines
- `docs/ui-design-rule.md` - Frontend design standards
