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

## Development Commands

- `/req` - Create requirements document
- `/spec <req-id>` - Create implementation specification
- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run test` - Run unit tests
- `npm run lint` - Run linter

## Architecture Overview

This is a Next.js application with:
- Next.js 15+ with App Router
- TypeScript for type safety
- SQLite database with Prisma ORM
- **Shadcn UI** for components (Priority #1)
- Tailwind CSS for styling
- Vitest for unit testing
- ESLint for code quality

For detailed information, see [Architecture](docs/architecture.md).
