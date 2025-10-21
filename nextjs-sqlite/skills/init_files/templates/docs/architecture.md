# Architecture

This document describes the technology stack, architecture patterns, and system design for this Next.js + SQLite application.

## Technology Stack

### Core Framework

- **Next.js 15+** - React framework with App Router
  - Server Components for default rendering
  - Client Components for interactivity
  - Server Actions for mutations
  - API Routes for REST endpoints

### Language and Runtime

- **TypeScript 5+** - Type-safe JavaScript
  - Strict mode enabled
  - Path aliases configured (`@/`)

- **Node.js 22+** - JavaScript runtime
  - LTS version recommended
  - Modern JavaScript features support

### Database

- **SQLite** - Lightweight relational database
  - File-based storage
  - ACID compliant
  - Zero configuration

- **Prisma ORM** - Database toolkit
  - Type-safe database client
  - Schema migrations
  - Query builder

### UI Components

- **Shadcn UI** - Primary component library (Priority #1)
  - Copy-paste components into your codebase
  - Built on Radix UI for accessibility
  - Tailwind CSS based
  - Full TypeScript support
  - See [UI Design Rules](ui-design-rule.md) for details

- **Tailwind CSS** - Utility-first CSS framework
  - Required for Shadcn UI
  - Responsive design utilities
  - Theme customization with CSS variables
  - Dark mode support

### Testing

- **Vitest** - Unit testing framework
  - Fast execution
  - TypeScript support
  - Compatible with Jest API

### Code Quality

- **ESLint** - Linting for JavaScript/TypeScript
  - Next.js recommended config
  - Custom rules as needed

- **TypeScript Compiler** - Type checking
  - Strict mode enabled
  - Import path validation

## Architecture Patterns

### Next.js App Router

This project uses the Next.js App Router architecture:

```
app/
├── layout.tsx              # Root layout
├── page.tsx                # Home page
├── (auth)/                 # Route group (doesn't affect URL)
│   ├── login/
│   │   └── page.tsx
│   └── register/
│       └── page.tsx
├── dashboard/
│   ├── layout.tsx          # Dashboard layout
│   ├── page.tsx            # Dashboard home
│   └── users/
│       ├── page.tsx        # User list
│       └── [id]/
│           └── page.tsx    # User detail (dynamic route)
└── api/
    └── users/
        ├── route.ts        # GET/POST /api/users
        └── [id]/
            └── route.ts    # GET/PUT/DELETE /api/users/:id
```

### Server vs Client Components

**Server Components** (default):
- Render on the server
- Can directly access database
- Cannot use hooks or browser APIs
- Reduce JavaScript bundle size

```typescript
// Server Component (default)
import { prisma } from '@/lib/db';

export default async function UserList() {
  const users = await prisma.user.findMany();

  return (
    <div>
      {users.map(user => (
        <div key={user.id}>{user.name}</div>
      ))}
    </div>
  );
}
```

**Client Components**:
- Render in browser
- Can use React hooks and state
- Handle user interactions
- Access browser APIs

```typescript
'use client';

import { useState } from 'react';

export default function Counter() {
  const [count, setCount] = useState(0);

  return (
    <button onClick={() => setCount(count + 1)}>
      Count: {count}
    </button>
  );
}
```

### Data Fetching Strategy

1. **Server Components for initial data**
   - Fetch data directly in async components
   - No client-side API calls needed
   - Automatic request deduplication

2. **Client Components for dynamic data**
   - Use React hooks (useEffect, custom hooks)
   - Fetch from API routes
   - Handle loading/error states

3. **Server Actions for mutations**
   - Form submissions
   - Data updates
   - Progressive enhancement

```typescript
// app/users/page.tsx
export default async function UsersPage() {
  const users = await getUsers(); // Direct DB access

  return <UserList users={users} />;
}

// app/_components/UserList.tsx
'use client';

export function UserList({ users }: { users: User[] }) {
  const [search, setSearch] = useState('');

  const filtered = users.filter(u =>
    u.name.includes(search)
  );

  return (
    <div>
      <input
        value={search}
        onChange={(e) => setSearch(e.target.value)}
        placeholder="Search..."
      />
      {filtered.map(user => (
        <UserCard key={user.id} user={user} />
      ))}
    </div>
  );
}
```

## Project Structure

### Directory Organization

```
project-root/
├── app/                          # Next.js App Router
│   ├── layout.tsx               # Root layout
│   ├── page.tsx                 # Home page
│   ├── globals.css              # Global styles
│   ├── (routes)/                # Feature routes
│   │   ├── dashboard/
│   │   ├── users/
│   │   └── settings/
│   ├── api/                     # API routes
│   │   ├── users/
│   │   └── posts/
│   └── _components/             # Private route-specific components
│       └── Header.tsx
│
├── components/                   # Shared components
│   ├── ui/                      # Reusable UI components
│   │   ├── button.tsx
│   │   ├── card.tsx
│   │   └── input.tsx
│   └── layout/                  # Layout components
│       ├── Sidebar.tsx
│       └── Footer.tsx
│
├── lib/                         # Business logic and utilities
│   ├── db.ts                    # Prisma client instance
│   ├── users.ts                 # User-related functions
│   ├── posts.ts                 # Post-related functions
│   └── utils.ts                 # Utility functions
│
├── types/                       # TypeScript type definitions
│   ├── user.ts
│   ├── post.ts
│   └── api.ts
│
├── prisma/                      # Database
│   ├── schema.prisma            # Database schema
│   ├── migrations/              # Migration history
│   └── seed.ts                  # Database seed script
│
├── public/                      # Static files
│   ├── images/
│   └── fonts/
│
├── docs/                        # Documentation
│   ├── requirements/            # Requirement documents
│   ├── specifications/          # Implementation specs
│   ├── software-development-lifecycle.md
│   ├── coding-rule.md
│   ├── architecture.md
│   ├── test-rule.md
│   └── ui-design-rule.md
│
├── .env                         # Environment variables (gitignored)
├── .env.example                 # Environment template
├── next.config.js               # Next.js configuration
├── tsconfig.json                # TypeScript configuration
├── package.json                 # Dependencies and scripts
├── vitest.config.ts             # Vitest configuration
├── vitest.setup.ts              # Global test setup
├── .eslintrc.json               # ESLint configuration
└── CLAUDE.md                    # Claude Code configuration

Note: Test files (*.test.ts, *.test.tsx) are co-located with source files.
For example:
- lib/users.test.ts (next to lib/users.ts)
- components/ui/button.test.tsx (next to components/ui/button.tsx)
```

## Database Architecture

### Prisma Schema

The database schema is defined in `prisma/schema.prisma`:

```prisma
datasource db {
  provider = "sqlite"
  url      = env("DATABASE_URL")
}

generator client {
  provider = "prisma-client-js"
}

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
  author    User     @relation(fields: [authorId], references: [id], onDelete: Cascade)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  @@index([authorId])
  @@index([published])
}
```

### Database Client

Prisma Client is instantiated as a singleton:

```typescript
// lib/db.ts
import { PrismaClient } from '@prisma/client';

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined;
};

export const prisma = globalForPrisma.prisma ?? new PrismaClient();

if (process.env.NODE_ENV !== 'production') {
  globalForPrisma.prisma = prisma;
}
```

### Migrations

```bash
# Create migration
npx prisma migrate dev --name add_user_table

# Apply migrations
npx prisma migrate deploy

# Reset database (dev only)
npx prisma migrate reset

# Generate Prisma Client
npx prisma generate
```

## API Design

### REST Endpoints

API routes follow RESTful conventions:

```
GET    /api/users              # List users
POST   /api/users              # Create user
GET    /api/users/:id          # Get user by ID
PUT    /api/users/:id          # Update user
DELETE /api/users/:id          # Delete user
```

### Request/Response Format

**Request:**
```json
POST /api/users
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com"
}
```

**Response (Success):**
```json
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "createdAt": "2024-01-15T10:30:00.000Z",
  "updatedAt": "2024-01-15T10:30:00.000Z"
}
```

**Response (Error):**
```json
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "error": "Invalid input",
  "details": [
    {
      "field": "email",
      "message": "Invalid email format"
    }
  ]
}
```

## State Management

### Server State

- Data fetched in Server Components
- Passed to Client Components as props
- Re-validated on navigation

### Client State

- React `useState` for local component state
- Custom hooks for shared logic
- Context API for global client state (if needed)

```typescript
// Local state
const [isOpen, setIsOpen] = useState(false);

// Custom hook for shared logic
function useUser(userId: number) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchUser(userId).then(setUser).finally(() => setLoading(false));
  }, [userId]);

  return { user, loading };
}
```

## Environment Configuration

### Environment Variables

```bash
# .env
DATABASE_URL="file:./dev.db"
NODE_ENV="development"
```

```bash
# .env.example (checked into git)
DATABASE_URL="file:./dev.db"
NODE_ENV="development"
```

### Configuration Files

- `next.config.js` - Next.js configuration
- `tsconfig.json` - TypeScript compiler options
- `vitest.config.ts` - Test configuration
- `.eslintrc.json` - Linting rules

## Performance Considerations

### Optimization Strategies

1. **Server Components** - Reduce client JavaScript
2. **Lazy Loading** - Dynamic imports for large components
3. **Image Optimization** - Use Next.js Image component
4. **Database Indexing** - Index frequently queried fields
5. **Caching** - Leverage Next.js caching mechanisms

### Monitoring

- Build time warnings/errors
- TypeScript compilation time
- Test execution time
- Bundle size analysis

## Security

### Best Practices

- **Environment Variables** - Keep secrets out of code
- **Input Validation** - Validate all user input
- **SQL Injection** - Use Prisma's query builder (parameterized)
- **XSS Protection** - React escapes by default
- **CSRF Protection** - Server Actions include CSRF tokens

## Deployment

### Production Build

```bash
# Build for production
npm run build

# Start production server
npm start
```

### Database Migrations

```bash
# Apply migrations in production
npx prisma migrate deploy
```

## References

- [Next.js Documentation](https://nextjs.org/docs)
- [Prisma Documentation](https://www.prisma.io/docs)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Vitest Documentation](https://vitest.dev/)
