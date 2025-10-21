# Software Development Lifecycle

This document defines the development process and workflow for this Next.js + SQLite project.

## Overview

We follow a structured development lifecycle to ensure quality and maintainability:

1. Requirements Definition
2. Implementation Specification
3. Implementation
4. Testing
5. Review and Deployment

## 1. Requirements Definition

**Command**: `/req`

Create a requirements document that describes:
- Feature overview and purpose
- User stories and use cases
- Acceptance criteria
- Data model requirements
- UI/UX requirements

**Output**: `docs/requirements/REQ-{number}.md`

### Requirements Document Structure

```markdown
# REQ-{number}: {Feature Name}

## Overview
Brief description of the feature

## User Stories
- As a {user type}, I want to {action}, so that {benefit}

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Data Model
Tables and fields required

## UI/UX Requirements
Wireframes, user flow, design considerations

## Dependencies
Related requirements or external dependencies
```

## 2. Implementation Specification

**Command**: `/spec <req-id>`

Create a detailed implementation plan based on requirements:
- Database schema changes (Prisma models)
- API routes and endpoints
- React components structure
- State management approach
- File structure

**Output**: `docs/specifications/SPEC-{number}.md`

### Specification Document Structure

```markdown
# SPEC-{number}: Implementation for REQ-{number}

## Database Schema Changes
Prisma schema modifications

## API Routes
- Route paths
- Request/response formats
- Validation rules

## Components
- Component hierarchy
- Props and state
- Event handlers

## File Structure
New files to be created

## Implementation Steps
1. Step 1
2. Step 2
...
```

## 3. Implementation

**IMPORTANT: Complete all implementation BEFORE writing tests.**

Execute the implementation according to the specification:

1. **Database Changes**
   - Update `prisma/schema.prisma`
   - Run migrations: `npx prisma migrate dev`
   - Generate Prisma Client: `npx prisma generate`

2. **Backend Implementation**
   - Create/update API routes in `app/api/`
   - Implement data access logic
   - Add validation and error handling

3. **Frontend Implementation**
   - **FIRST: Search for similar existing screens** (see [UI Design Rules](ui-design-rule.md#ui-implementation-workflow))
     - Find pages with similar functionality: `find app -name "page.tsx"`
     - Review existing components: `ls components/ui/`
     - Identify established patterns: layout, spacing, component usage
   - **Follow existing patterns exactly** - Match layout, spacing, components, colors
   - Create/update React components (reuse existing when possible)
   - Implement UI according to design rules and existing patterns
   - Add client-side validation

4. **Integration**
   - Connect frontend to backend APIs
   - Test data flow
   - Handle loading and error states

**Note: Do NOT write tests yet. Complete the entire implementation first.**

## 4. Testing

**IMPORTANT: Write tests AFTER implementation is complete.**

**Order: Implementation → Testing (NOT the reverse)**

Why this order:
- Writing tests before implementation often leads to tests that match incorrect code
- Common problem: "Adjusted implementation to match tests, and correct code reverted to incorrect code"
- Implementation-first ensures tests validate the correct behavior

Write and run tests for all new code:

1. **Unit Tests**
   - Test individual functions and components
   - Follow test rules in [Test Rules](test-rule.md)
   - Run: `npm run test`

2. **Integration Tests**
   - Test API routes
   - Test database interactions
   - Verify end-to-end workflows

3. **Manual Testing**
   - Test in development server: `npm run dev`
   - Verify all acceptance criteria
   - Check edge cases and error handling

## 5. Review and Deployment

1. **Code Review**
   - Run linter: `npm run lint`
   - Check for type errors: `npm run build`
   - Verify all tests pass

2. **Documentation**
   - Update README if needed
   - Add JSDoc comments
   - Update API documentation

3. **Deployment**
   - Commit changes with descriptive message
   - Create pull request
   - Deploy to staging/production

## Agent Skills Integration

This plugin provides agent skills that automate parts of this workflow:

- **update-req**: Update requirements based on implementation changes
- **update-prisma-schema**: Modify database schema and run migrations
- **run_dev**: Start development server

## Hooks

- **lint**: Automatically runs linter after code modifications

## Workflow Example

```bash
# 1. Create requirement
/req
# Follow prompts to create REQ-001.md

# 2. Create specification
/spec REQ-001
# Creates SPEC-001.md with implementation plan

# 3. Implement (complete ALL implementation first)
# Claude will implement according to SPEC-001.md
# Hooks automatically run linter
# DO NOT write tests yet - finish implementation first

# 4. Write tests (AFTER implementation is complete)
# Write unit tests for all implemented code
npm run test
npm run build

# 5. Review
# Verify implementation meets requirements
```

## Best Practices

- Always create requirements before starting implementation
- Keep specifications detailed and up-to-date
- **Always reference existing screens before implementing new UI** - Search for similar patterns and follow them exactly
- **Write tests AFTER implementation is complete** (Implementation → Testing order)
- Never write tests before implementation - this leads to tests matching incorrect code
- Reuse existing components whenever possible - don't recreate what already exists
- Run linter and type checker frequently
- Update requirements if implementation reveals gaps
- Commit frequently with descriptive messages

## References

- [Coding Rules](coding-rule.md)
- [Architecture](architecture.md)
- [Test Rules](test-rule.md)
- [UI Design Rules](ui-design-rule.md)
