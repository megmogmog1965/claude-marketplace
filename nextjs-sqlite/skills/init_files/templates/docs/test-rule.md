# Test Rules

This document defines the unit testing guidelines, conventions, and best practices for this Next.js + SQLite project using Vitest.

## Testing Philosophy

- **Implementation first, then tests** - ALWAYS write implementation before writing tests
  - Order: Implementation → Testing (NOT the reverse)
  - Reason: Writing tests first often leads to tests matching incorrect code
  - Common problem: "Adjusted implementation to match tests, and correct code reverted to incorrect code"
- **Write tests for critical paths** - Focus on business logic and user flows
- **Test behavior, not implementation** - Tests should survive refactoring
- **Keep tests simple and readable** - Tests are documentation
- **Fast feedback** - Tests should run quickly
- **Isolated tests** - Each test should be independent
- **No external dependencies** - Mock all external access (database, APIs, file system)
  - External access slows down test execution significantly
  - Requires test data setup and maintenance, increasing implementation cost
  - Use mocks and stubs instead

## Testing Framework

### Vitest

We use Vitest as our testing framework:

- Compatible with Jest API
- Fast execution with ESBuild
- Native TypeScript support
- Watch mode for development

### Configuration

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./vitest.setup.ts'],
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './'),
    },
  },
});
```

## Test Organization

### File Structure

**Co-locate tests with source files** using `.test.ts` or `.test.tsx` suffix.

This approach:
- Keeps tests close to the code they're testing
- Makes it easy to find related tests
- Simplifies imports and maintenance

```
lib/
├── users.ts
└── users.test.ts

components/
├── Button.tsx
└── Button.test.tsx

app/
├── api/
│   └── users/
│       ├── route.ts
│       └── route.test.ts
└── dashboard/
    └── _components/
        ├── UserCard.tsx
        └── UserCard.test.tsx

vitest.setup.ts              # Global test setup
```

### File Naming

- `*.test.ts` - Unit tests for utilities and functions
- `*.test.tsx` - Component tests
- `vitest.setup.ts` - Global test setup file (in project root)

## Writing Tests

### Test Structure

Use the AAA pattern (Arrange, Act, Assert):

```typescript
import { describe, it, expect } from 'vitest';
import { calculateTotal } from './utils';

describe('calculateTotal', () => {
  it('should sum all item prices', () => {
    // Arrange
    const items = [
      { name: 'Item 1', price: 10 },
      { name: 'Item 2', price: 20 },
    ];

    // Act
    const total = calculateTotal(items);

    // Assert
    expect(total).toBe(30);
  });
});
```

### Test Naming

- **Describe blocks** - Name after the function/component being tested
- **Test cases** - Use "should" statements describing expected behavior

```typescript
describe('UserList', () => {
  it('should render all users', () => { });
  it('should filter users by search term', () => { });
  it('should show empty state when no users exist', () => { });
});
```

## Unit Tests

### Testing Utility Functions

```typescript
// lib/utils.ts
export function formatCurrency(amount: number): string {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
  }).format(amount);
}

// lib/utils.test.ts
import { describe, it, expect } from 'vitest';
import { formatCurrency } from './utils';

describe('formatCurrency', () => {
  it('should format positive numbers correctly', () => {
    expect(formatCurrency(1234.56)).toBe('$1,234.56');
  });

  it('should format zero correctly', () => {
    expect(formatCurrency(0)).toBe('$0.00');
  });

  it('should format negative numbers correctly', () => {
    expect(formatCurrency(-100)).toBe('-$100.00');
  });
});
```

### Testing Business Logic

```typescript
// lib/users.ts
export function isUserActive(user: User): boolean {
  return user.status === 'active' && user.lastLoginAt > Date.now() - 30 * 24 * 60 * 60 * 1000;
}

// lib/users.test.ts
import { describe, it, expect } from 'vitest';
import { isUserActive } from './users';

describe('isUserActive', () => {
  const now = Date.now();
  const twentyDaysAgo = now - 20 * 24 * 60 * 60 * 1000;
  const fortyDaysAgo = now - 40 * 24 * 60 * 60 * 1000;

  it('should return true for active user with recent login', () => {
    const user = { status: 'active', lastLoginAt: twentyDaysAgo };
    expect(isUserActive(user)).toBe(true);
  });

  it('should return false for inactive user', () => {
    const user = { status: 'inactive', lastLoginAt: twentyDaysAgo };
    expect(isUserActive(user)).toBe(false);
  });

  it('should return false for user with old login', () => {
    const user = { status: 'active', lastLoginAt: fortyDaysAgo };
    expect(isUserActive(user)).toBe(false);
  });
});
```

## Component Tests

### Testing React Components

```typescript
// components/Button.tsx
interface ButtonProps {
  onClick?: () => void;
  disabled?: boolean;
  children: React.ReactNode;
}

export function Button({ onClick, disabled, children }: ButtonProps) {
  return (
    <button onClick={onClick} disabled={disabled}>
      {children}
    </button>
  );
}

// components/Button.test.tsx
import { describe, it, expect, vi } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import { Button } from './Button';

describe('Button', () => {
  it('should render children', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });

  it('should call onClick when clicked', () => {
    const handleClick = vi.fn();
    render(<Button onClick={handleClick}>Click me</Button>);

    fireEvent.click(screen.getByText('Click me'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('should not call onClick when disabled', () => {
    const handleClick = vi.fn();
    render(<Button onClick={handleClick} disabled>Click me</Button>);

    fireEvent.click(screen.getByText('Click me'));
    expect(handleClick).not.toHaveBeenCalled();
  });

  it('should be disabled when disabled prop is true', () => {
    render(<Button disabled>Click me</Button>);
    expect(screen.getByText('Click me')).toBeDisabled();
  });
});
```

### Testing Components with State

```typescript
// components/Counter.tsx
'use client';

import { useState } from 'react';

export function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
      <button onClick={() => setCount(0)}>Reset</button>
    </div>
  );
}

// components/Counter.test.tsx
import { describe, it, expect } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import { Counter } from './Counter';

describe('Counter', () => {
  it('should start at 0', () => {
    render(<Counter />);
    expect(screen.getByText('Count: 0')).toBeInTheDocument();
  });

  it('should increment count when increment button is clicked', () => {
    render(<Counter />);

    fireEvent.click(screen.getByText('Increment'));
    expect(screen.getByText('Count: 1')).toBeInTheDocument();

    fireEvent.click(screen.getByText('Increment'));
    expect(screen.getByText('Count: 2')).toBeInTheDocument();
  });

  it('should reset count when reset button is clicked', () => {
    render(<Counter />);

    fireEvent.click(screen.getByText('Increment'));
    fireEvent.click(screen.getByText('Increment'));
    fireEvent.click(screen.getByText('Reset'));

    expect(screen.getByText('Count: 0')).toBeInTheDocument();
  });
});
```

## Mocking

**IMPORTANT: All external dependencies MUST be mocked in tests.**

This includes:
- **Database access** (Prisma, SQLite)
- **HTTP requests** (fetch, axios)
- **File system operations**
- **External APIs**

Reasons:
- External access significantly slows down test execution
- Requires test data setup and maintenance (high implementation cost)
- Tests become unreliable due to external state

### Mocking Database (Prisma)

**ALWAYS mock Prisma Client - never access real database in tests.**

```typescript
import { describe, it, expect, vi, beforeEach } from 'vitest';

// Mock the entire database module
vi.mock('@/lib/db', () => ({
  prisma: {
    user: {
      findMany: vi.fn(),
      findUnique: vi.fn(),
      create: vi.fn(),
      update: vi.fn(),
      delete: vi.fn(),
    },
  },
}));

import { prisma } from '@/lib/db';
import { getUsers, getUser, createUser } from './users';

describe('User functions', () => {
  beforeEach(() => {
    // Reset mocks before each test
    vi.clearAllMocks();
  });

  it('should get all users', async () => {
    // Arrange - set up mock data
    const mockUsers = [
      { id: 1, name: 'John', email: 'john@example.com' },
      { id: 2, name: 'Jane', email: 'jane@example.com' },
    ];
    vi.mocked(prisma.user.findMany).mockResolvedValue(mockUsers);

    // Act
    const users = await getUsers();

    // Assert
    expect(users).toEqual(mockUsers);
    expect(prisma.user.findMany).toHaveBeenCalledTimes(1);
  });

  it('should get user by id', async () => {
    const mockUser = { id: 1, name: 'John', email: 'john@example.com' };
    vi.mocked(prisma.user.findUnique).mockResolvedValue(mockUser);

    const user = await getUser(1);

    expect(user).toEqual(mockUser);
    expect(prisma.user.findUnique).toHaveBeenCalledWith({
      where: { id: 1 },
    });
  });

  it('should return null for non-existent user', async () => {
    vi.mocked(prisma.user.findUnique).mockResolvedValue(null);

    const user = await getUser(999);

    expect(user).toBeNull();
  });
});
```

### Mocking HTTP Requests

```typescript
import { describe, it, expect, vi } from 'vitest';

describe('API calls', () => {
  it('should handle successful response', async () => {
    // Mock global fetch
    const mockFetch = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ id: 1, name: 'John' }),
    });

    global.fetch = mockFetch;

    const response = await fetchUser(1);

    expect(mockFetch).toHaveBeenCalledWith('/api/users/1');
    expect(response).toEqual({ id: 1, name: 'John' });
  });

  it('should handle error response', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      ok: false,
      status: 404,
    });

    await expect(fetchUser(999)).rejects.toThrow('User not found');
  });
});
```

## API Route Tests

### Testing Route Handlers

```typescript
// app/api/users/route.test.ts
import { describe, it, expect, vi } from 'vitest';
import { GET, POST } from './route';

vi.mock('@/lib/db', () => ({
  prisma: {
    user: {
      findMany: vi.fn().mockResolvedValue([
        { id: 1, name: 'John', email: 'john@example.com' },
      ]),
      create: vi.fn().mockResolvedValue({
        id: 2,
        name: 'Jane',
        email: 'jane@example.com',
      }),
    },
  },
}));

describe('GET /api/users', () => {
  it('should return list of users', async () => {
    const response = await GET();
    const data = await response.json();

    expect(response.status).toBe(200);
    expect(data).toHaveLength(1);
    expect(data[0].name).toBe('John');
  });
});

describe('POST /api/users', () => {
  it('should create new user', async () => {
    const request = new Request('http://localhost/api/users', {
      method: 'POST',
      body: JSON.stringify({
        name: 'Jane',
        email: 'jane@example.com',
      }),
    });

    const response = await POST(request);
    const data = await response.json();

    expect(response.status).toBe(201);
    expect(data.name).toBe('Jane');
  });

  it('should return 400 for invalid input', async () => {
    const request = new Request('http://localhost/api/users', {
      method: 'POST',
      body: JSON.stringify({
        name: '', // Invalid
        email: 'not-an-email', // Invalid
      }),
    });

    const response = await POST(request);

    expect(response.status).toBe(400);
  });
});
```

## Test Coverage

### Coverage Goals

- **Critical paths**: 100% coverage
- **Business logic**: 90%+ coverage
- **UI components**: 80%+ coverage
- **Overall**: 80%+ coverage

### Running Coverage

```bash
# Run tests with coverage
npm run test -- --coverage

# View coverage report
open coverage/index.html
```

## Best Practices

### DO

- **Write implementation BEFORE writing tests** - complete implementation first
- Write tests for all business logic
- Test edge cases and error conditions
- Keep tests simple and focused
- Use descriptive test names
- **Mock ALL external dependencies** (database, APIs, file system)
- Use `beforeEach` to reset mocks between tests
- Run tests before committing
- Verify mock calls with `expect().toHaveBeenCalledWith()`
- Keep tests fast (milliseconds, not seconds)

### DON'T

- **Write tests before implementation** - this leads to tests matching incorrect code
- **Modify implementation to match failing tests** - fix the tests instead
- **Access real database in tests** - ALWAYS mock Prisma
- **Make HTTP requests to external APIs** - mock fetch/axios
- **Access file system** - mock fs operations
- **Use test databases or test data** - use mocks instead
- Test implementation details
- Write flaky tests that sometimes fail
- Skip tests (unless temporarily with `it.skip`)
- Test third-party libraries
- Make tests dependent on each other
- Ignore failing tests
- Share state between tests

## Running Tests

### Commands

```bash
# Run all tests
npm run test

# Run tests in watch mode
npm run test -- --watch

# Run specific test file
npm run test -- users.test.ts

# Run tests with coverage
npm run test -- --coverage

# Run tests matching pattern
npm run test -- --grep="user"
```

### CI/CD Integration

Tests should run automatically:
- Before committing (pre-commit hook)
- On pull requests
- Before deployment

## Debugging Tests

### VS Code Configuration

```json
{
  "type": "node",
  "request": "launch",
  "name": "Debug Tests",
  "program": "${workspaceFolder}/node_modules/vitest/vitest.mjs",
  "args": ["--run"],
  "console": "integratedTerminal"
}
```

### Console Logging

```typescript
it('should debug value', () => {
  const result = complexFunction();
  console.log('Result:', result); // Visible in test output
  expect(result).toBe(expected);
});
```

## Test Setup

### Global Setup

```typescript
// vitest.setup.ts (in project root)
import '@testing-library/jest-dom';
import { cleanup } from '@testing-library/react';
import { afterEach, vi } from 'vitest';

// Cleanup after each test
afterEach(() => {
  cleanup();
  vi.clearAllMocks();
});

// Note: Do NOT set DATABASE_URL or create test databases
// All database access should be mocked in individual test files
```

## Common Testing Patterns

### Testing Async Functions

```typescript
it('should fetch user data', async () => {
  const user = await getUser(1);
  expect(user).toBeDefined();
  expect(user?.name).toBe('John');
});
```

### Testing Error Handling

```typescript
it('should throw error for invalid ID', async () => {
  await expect(getUser(-1)).rejects.toThrow('Invalid user ID');
});
```

### Testing with Timers

```typescript
import { vi } from 'vitest';

it('should delay execution', () => {
  vi.useFakeTimers();

  const callback = vi.fn();
  setTimeout(callback, 1000);

  vi.advanceTimersByTime(1000);

  expect(callback).toHaveBeenCalled();

  vi.useRealTimers();
});
```

## External Access Policy

### Prohibited in Tests

**The following external accesses are strictly prohibited in unit tests:**

1. **Database Access**
   - No SQLite file access
   - No Prisma queries to real database
   - No database connections

2. **HTTP Requests**
   - No fetch/axios calls to external APIs
   - No network requests

3. **File System**
   - No reading/writing files
   - No file system operations

4. **Other External Resources**
   - No environment-dependent operations
   - No system calls

### Why This Policy Exists

1. **Performance**
   - External access makes tests 10-100x slower
   - Fast tests enable rapid development and CI/CD
   - Target: All tests should complete in < 1 second

2. **Reliability**
   - External state makes tests flaky and unpredictable
   - Network issues cause random test failures
   - Database state can leak between tests

3. **Maintenance Cost**
   - Test databases require setup, migrations, and cleanup
   - Test data must be maintained alongside schema changes
   - Debugging external issues wastes development time

### How to Comply

**Use mocks and stubs for all external dependencies:**

```typescript
// ❌ BAD - Real database access
it('should get users', async () => {
  const users = await prisma.user.findMany();
  expect(users.length).toBeGreaterThan(0);
});

// ✅ GOOD - Mocked database
vi.mock('@/lib/db', () => ({
  prisma: {
    user: {
      findMany: vi.fn().mockResolvedValue([
        { id: 1, name: 'John' },
      ]),
    },
  },
}));

it('should get users', async () => {
  const users = await getUsers();
  expect(users).toHaveLength(1);
  expect(users[0].name).toBe('John');
});
```

## References

- [Vitest Documentation](https://vitest.dev/)
- [Testing Library](https://testing-library.com/)
- [Jest API](https://jestjs.io/docs/api)
