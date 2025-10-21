# Coding Rules

This document defines the coding standards and conventions for TypeScript and React development in this Next.js + SQLite project.

## General Principles

- Write clean, readable, and maintainable code
- Follow TypeScript best practices for type safety
- Prioritize code clarity over cleverness
- Use meaningful variable and function names
- Keep functions small and focused on a single responsibility
- Avoid code duplication (DRY principle)

## TypeScript

### Type Safety

- **Always use explicit types** for function parameters and return values
- **Avoid `any` type** - use `unknown` if the type is truly unknown
- **Use strict mode** - ensure `strict: true` in tsconfig.json
- **Prefer interfaces over type aliases** for object shapes
- **Use const assertions** where appropriate

```typescript
// Good
interface User {
  id: number;
  name: string;
  email: string;
}

function getUser(id: number): Promise<User | null> {
  // implementation
}

// Avoid
function getUser(id: any): any {
  // implementation
}
```

### Naming Conventions

- **PascalCase** for types, interfaces, classes, and React components
- **camelCase** for variables, functions, and methods
- **UPPER_SNAKE_CASE** for constants
- **Prefix interfaces with `I`** only when necessary to avoid naming conflicts
- **Use descriptive names** that clearly indicate purpose

```typescript
// Types and Interfaces
interface UserProfile { }
type ApiResponse<T> = { }

// Constants
const MAX_RETRY_COUNT = 3;
const API_BASE_URL = process.env.API_URL;

// Variables and Functions
const userName = "John";
function fetchUserData() { }
```

### Import Organization

Order imports in the following sequence:

1. External dependencies (React, Next.js, etc.)
2. Internal modules (absolute imports with `@/`)
3. Relative imports
4. Type imports (use `import type`)

```typescript
// External dependencies
import { useState, useEffect } from 'react';
import { notFound } from 'next/navigation';

// Internal modules
import { Button } from '@/components/ui/button';
import { getUser } from '@/lib/users';

// Relative imports
import { UserCard } from './UserCard';

// Type imports
import type { User } from '@/types/user';
```

## React and Next.js

### Component Structure

- **Use functional components** with hooks
- **Prefer Server Components** by default in Next.js App Router
- **Explicitly mark Client Components** with `'use client'` directive
- **Keep components small** and focused on a single responsibility
- **Extract reusable logic** into custom hooks

```typescript
// Server Component (default)
interface UserListProps {
  limit?: number;
}

export async function UserList({ limit = 10 }: UserListProps) {
  const users = await getUsers(limit);

  return (
    <div>
      {users.map(user => (
        <UserCard key={user.id} user={user} />
      ))}
    </div>
  );
}

// Client Component
'use client';

import { useState } from 'react';

export function Counter() {
  const [count, setCount] = useState(0);

  return (
    <button onClick={() => setCount(count + 1)}>
      Count: {count}
    </button>
  );
}
```

### Props and State

- **Define prop types** with TypeScript interfaces
- **Use destructuring** for props
- **Provide default values** where appropriate
- **Keep state minimal** - derive values when possible
- **Lift state up** when shared by multiple components

```typescript
interface ButtonProps {
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
  onClick?: () => void;
  children: React.ReactNode;
}

export function Button({
  variant = 'primary',
  disabled = false,
  onClick,
  children
}: ButtonProps) {
  return (
    <button
      className={`btn btn-${variant}`}
      disabled={disabled}
      onClick={onClick}
    >
      {children}
    </button>
  );
}
```

### Hooks

- **Follow Rules of Hooks**
  - Only call hooks at the top level
  - Only call hooks from React functions
- **Use custom hooks** for reusable stateful logic
- **Name custom hooks** with `use` prefix

```typescript
// Custom hook
function useUser(userId: number) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    fetchUser(userId)
      .then(setUser)
      .catch(setError)
      .finally(() => setLoading(false));
  }, [userId]);

  return { user, loading, error };
}
```

### Async Components (Server Components)

- **Use async/await** for data fetching in Server Components
- **Handle errors** with error boundaries or try/catch
- **Show loading states** with loading.tsx or Suspense

```typescript
export async function UserProfile({ userId }: { userId: number }) {
  try {
    const user = await getUser(userId);

    if (!user) {
      notFound();
    }

    return (
      <div>
        <h1>{user.name}</h1>
        <p>{user.email}</p>
      </div>
    );
  } catch (error) {
    console.error('Failed to fetch user:', error);
    throw error; // Let error boundary handle it
  }
}
```

## File Organization

### Directory Structure

```
app/
├── (routes)/
│   ├── page.tsx           # Server Component
│   ├── layout.tsx         # Layout
│   ├── loading.tsx        # Loading UI
│   ├── error.tsx          # Error UI
│   └── not-found.tsx      # 404 page
├── api/
│   └── users/
│       └── route.ts       # API route
└── _components/           # Route-specific components (private)
    └── UserCard.tsx

components/
└── ui/
    ├── button.tsx         # Reusable UI components
    └── card.tsx

lib/
├── db.ts                  # Database utilities
├── users.ts               # Business logic
└── utils.ts               # Helper functions

types/
└── user.ts                # Type definitions

prisma/
└── schema.prisma          # Database schema
```

### File Naming

- **kebab-case** for directories and files
- **PascalCase** for component files (e.g., `UserCard.tsx`)
- **camelCase** for utility files (e.g., `utils.ts`)
- **Co-locate related files** - keep components, styles, and tests together

## API Routes

### Route Handlers

- **Use proper HTTP methods** (GET, POST, PUT, DELETE)
- **Validate input** using Zod or similar
- **Return proper status codes**
- **Handle errors gracefully**

```typescript
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { createUser } from '@/lib/users';

const createUserSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
});

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const data = createUserSchema.parse(body);

    const user = await createUser(data);

    return NextResponse.json(user, { status: 201 });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid input', details: error.errors },
        { status: 400 }
      );
    }

    console.error('Failed to create user:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
```

## Database (Prisma)

### Schema Design

- **Use descriptive model names** (PascalCase, singular)
- **Define relations explicitly**
- **Add indexes** for frequently queried fields
- **Use appropriate field types**

```prisma
model User {
  id        Int      @id @default(autoincrement())
  email     String   @unique
  name      String
  posts     Post[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  @@index([email])
}

model Post {
  id        Int      @id @default(autoincrement())
  title     String
  content   String
  published Boolean  @default(false)
  authorId  Int
  author    User     @relation(fields: [authorId], references: [id])
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  @@index([authorId])
}
```

### Query Patterns

- **Use Prisma Client methods** - avoid raw SQL when possible
- **Select only needed fields** to optimize performance
- **Use transactions** for operations that must be atomic
- **Handle errors** appropriately

```typescript
import { prisma } from '@/lib/db';

// Good - select only needed fields
async function getUserEmail(userId: number) {
  return await prisma.user.findUnique({
    where: { id: userId },
    select: { email: true },
  });
}

// Good - use transaction
async function createPostWithAuthor(postData: PostInput) {
  return await prisma.$transaction(async (tx) => {
    const user = await tx.user.create({ data: postData.author });
    const post = await tx.post.create({
      data: { ...postData.post, authorId: user.id },
    });
    return { user, post };
  });
}
```

## Error Handling

- **Always handle errors** - don't let them silently fail
- **Log errors** with sufficient context
- **Return user-friendly messages** in API responses
- **Use Error boundaries** in React for UI errors

```typescript
// API error handling
try {
  const result = await riskyOperation();
  return NextResponse.json(result);
} catch (error) {
  console.error('Operation failed:', error);
  return NextResponse.json(
    { error: 'Failed to process request' },
    { status: 500 }
  );
}

// Client error handling
try {
  const data = await fetchData();
  setData(data);
} catch (error) {
  console.error('Failed to fetch:', error);
  setError('Unable to load data. Please try again.');
}
```

## Comments and Documentation

- **Write self-documenting code** - prefer clear names over comments
- **Use JSDoc** for functions and complex types
- **Comment "why" not "what"** - explain the reasoning behind decisions
- **Update comments** when code changes

```typescript
/**
 * Fetches user data with caching.
 *
 * @param userId - The unique identifier of the user
 * @returns The user object or null if not found
 * @throws {Error} If the database query fails
 */
async function getUser(userId: number): Promise<User | null> {
  // Cache check omitted for brevity
  return await prisma.user.findUnique({ where: { id: userId } });
}
```

## Code Quality

### Linting and Formatting

- **Run ESLint** before committing: `npm run lint`
- **Fix automatically** where possible: `npm run lint -- --fix`
- **Follow ESLint rules** - don't disable without good reason

### Code Review Checklist

- [ ] Type safety - no `any` types
- [ ] Error handling - all paths covered
- [ ] Naming - clear and consistent
- [ ] Comments - explain complex logic
- [ ] Tests - critical paths covered
- [ ] Performance - no obvious bottlenecks
- [ ] Security - no vulnerabilities introduced

## References

- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [React Documentation](https://react.dev/)
- [Next.js Documentation](https://nextjs.org/docs)
- [Prisma Documentation](https://www.prisma.io/docs)
