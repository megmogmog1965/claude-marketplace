# Claude Code Configuration

This project uses Claude Code for AI-assisted development with Next.js + SQLite architecture.

## Project Documentation

This directory contains comprehensive documentation for development with Claude Code:

- [Software Development Lifecycle](docs/software-development-lifecycle.md) - Development process and workflow
- [Coding Rules](docs/coding-rule.md) - TypeScript and React coding standards
- [Architecture](docs/architecture.md) - Technology stack and system architecture
- [Test Rules](docs/test-rule.md) - Unit testing guidelines and conventions
- [UI Design Rules](docs/ui-design-rule.md) - Frontend and UI design standards

## Quick Start

1. Read the [Software Development Lifecycle](docs/software-development-lifecycle.md) to understand the development workflow
2. Review [Architecture](docs/architecture.md) to understand the technology stack
3. Follow [Coding Rules](docs/coding-rule.md) when implementing features
4. Write tests according to [Test Rules](docs/test-rule.md)
5. Design UI components following [UI Design Rules](docs/ui-design-rule.md)
   - **FIRST: Search for similar existing screens** - `find app -name "page.tsx"`
   - **Follow existing patterns exactly** - Match layout, spacing, component usage
   - Always use Shadcn UI components first
   - Use design tokens for all styling (never hardcode colors, spacing, etc.)
   - Reference semantic tokens: `bg-primary`, `text-sm`, `p-4`, `rounded-lg`

## Available Slash Commands

- `/req` - Create requirements document
- `/spec <req-id>` - Create implementation specification

## Claude Code Integration

This project uses Claude Code's subagents and skills for automated development tasks:
- **lint subagent** - Automatically runs after code changes via hooks
- **build subagent** - Verifies TypeScript compilation
- **test subagent** - Runs unit tests and fixes failures
- **update-prisma-schema skill** - Manages database schema changes
- **run_dev skill** - Starts development server for verification

For detailed workflow, see [Software Development Lifecycle](docs/software-development-lifecycle.md).
