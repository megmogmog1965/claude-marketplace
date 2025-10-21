# UI Design Rules

This document defines the frontend development and UI design guidelines for this Next.js + SQLite project.

## Design Philosophy

- **User-centric design** - Prioritize user experience and accessibility
- **Design tokens everywhere** - Use design tokens for all styling (colors, spacing, typography) to ensure consistency
- **Consistency above all** - Always reference existing screens when implementing new UI; maintain uniform patterns across the application
- **Simplicity** - Keep interfaces clean and intuitive
- **Responsive** - Work seamlessly across all device sizes
- **Performance** - Fast loading and smooth interactions
- **No hardcoded values** - Never use inline styles or arbitrary values; always reference design tokens

## UI Implementation Workflow

**CRITICAL: Always reference existing screens before implementing new UI.**

### Before Implementing Any UI

**Step 1: Search for Similar Screens**

Find existing screens with similar functionality to understand established patterns:

```bash
# Search for similar page components
find app -name "page.tsx" -type f

# Search for similar features (e.g., user list)
grep -r "UserList\|user.*list" app --include="*.tsx"

# Search for form patterns
grep -r "Form\|form" components --include="*.tsx"

# Search for table usage
grep -r "Table\|table" app components --include="*.tsx"
```

**Step 2: Review Existing Components**

Before creating new components, check what already exists:

```bash
# List all existing UI components
ls components/ui/

# Check for similar custom components
ls components/

# Search for specific component patterns
grep -r "export function.*Card" components --include="*.tsx"
```

**Step 3: Analyze Existing Patterns**

Review how existing screens implement similar features:

```typescript
// ✅ GOOD - Follow existing patterns
// Found existing user list pattern in app/users/page.tsx:
<div className="container mx-auto p-6">
  <div className="mb-6">
    <h1 className="text-3xl font-bold">Users</h1>
    <p className="text-muted-foreground">Manage your users</p>
  </div>
  <Card>
    <CardContent className="p-6">
      <Table>...</Table>
    </CardContent>
  </Card>
</div>

// Use the SAME pattern for new posts list:
<div className="container mx-auto p-6">
  <div className="mb-6">
    <h1 className="text-3xl font-bold">Posts</h1>
    <p className="text-muted-foreground">Manage your posts</p>
  </div>
  <Card>
    <CardContent className="p-6">
      <Table>...</Table>
    </CardContent>
  </Card>
</div>

// ❌ BAD - Creating inconsistent layout
<div className="p-8 max-w-7xl">
  <h1 className="text-4xl mb-4">Posts</h1>
  <div className="bg-white rounded p-4">
    <table>...</table>
  </div>
</div>
```

### Implementation Checklist

Before implementing any UI screen or component:

- [ ] **Search for similar existing screens** - Find pages with similar functionality
- [ ] **Identify existing patterns** - Note layout structure, spacing, component usage
- [ ] **Review existing components** - Check if components you need already exist
- [ ] **Match the design** - Use the same:
  - Container classes (`container mx-auto p-6`)
  - Heading hierarchy and styles (`text-3xl font-bold`)
  - Spacing patterns (`mb-6`, `p-6`)
  - Card layouts and structure
  - Color schemes (design tokens)
  - Button variants and sizes
- [ ] **Reuse existing components** - Don't create new ones if similar exists
- [ ] **Document why if you deviate** - If you must differ, explain why in comments

### Common Patterns to Follow

**Page Layout Pattern**:

```typescript
// Standard page layout (found in most existing screens)
export default function YourPage() {
  return (
    <div className="container mx-auto p-6">
      {/* Page header */}
      <div className="mb-6">
        <h1 className="text-3xl font-bold">Page Title</h1>
        <p className="text-muted-foreground">Page description</p>
      </div>

      {/* Main content */}
      <Card>
        <CardContent className="p-6">
          {/* Content here */}
        </CardContent>
      </Card>
    </div>
  );
}
```

**Form Layout Pattern**:

```typescript
// Standard form layout
<Card className="max-w-md mx-auto">
  <CardHeader>
    <CardTitle>Form Title</CardTitle>
    <CardDescription>Form description</CardDescription>
  </CardHeader>
  <CardContent>
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        {/* Form fields */}
      </form>
    </Form>
  </CardContent>
</Card>
```

**List/Table Pattern**:

```typescript
// Standard list/table layout
<Card>
  <CardHeader>
    <div className="flex items-center justify-between">
      <div>
        <CardTitle>Items</CardTitle>
        <CardDescription>Total: {items.length}</CardDescription>
      </div>
      <Button>Add New</Button>
    </div>
  </CardHeader>
  <CardContent>
    <Table>
      {/* Table content */}
    </Table>
  </CardContent>
</Card>
```

### Finding Patterns Example

When implementing a new "Products" page:

```bash
# 1. Find similar list pages
find app -name "page.tsx" -exec grep -l "Table\|List" {} \;
# Result: app/users/page.tsx, app/orders/page.tsx

# 2. Read the existing pattern
cat app/users/page.tsx
# Note: Uses container, Card, Table, specific spacing

# 3. Follow the EXACT same pattern
# Copy the structure, adjust content
```

### Why This Matters

**Consistency benefits**:
- Users get familiar with the interface faster
- Reduces cognitive load
- Professional, polished appearance
- Easier maintenance
- Predictable behavior

**Problems from inconsistency**:
- Users get confused by different layouts for similar tasks
- Unprofessional appearance
- Harder to maintain
- Duplicated effort

## UI Component Library

**Priority #1: Use Shadcn UI**

[Shadcn UI](https://ui.shadcn.com/) is the primary component library for this project.

### Why Shadcn UI?

- **Copy-paste components** - Components are added to your codebase, not installed as dependencies
- **Full customization** - Complete control over component code and styling
- **Tailwind CSS based** - Leverages Tailwind's utility-first approach
- **Accessibility built-in** - Built with Radix UI primitives for excellent a11y
- **TypeScript native** - Full type safety out of the box
- **Modern and beautiful** - Professional, polished design system

### Installation

```bash
# Initialize Shadcn UI
npx shadcn@latest init

# Add components as needed
npx shadcn@latest add button
npx shadcn@latest add card
npx shadcn@latest add input
npx shadcn@latest add dialog
npx shadcn@latest add table
```

### Usage

```typescript
// After adding components, use them directly
import { Button } from '@/components/ui/button';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';

export function Dashboard() {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Welcome</CardTitle>
      </CardHeader>
      <CardContent>
        <Button>Get Started</Button>
      </CardContent>
    </Card>
  );
}
```

### Component Priority

When building UI:

1. **First choice: Shadcn UI components** - Check https://ui.shadcn.com/docs/components for available components
2. **Second choice: Customize Shadcn components** - Extend or modify existing Shadcn components
3. **Last resort: Build custom components** - Only when Shadcn doesn't provide a suitable base

### Available Shadcn Components

Common components to add:
- **Form elements**: Button, Input, Textarea, Select, Checkbox, Radio, Switch
- **Layout**: Card, Separator, Tabs, Sheet, Dialog
- **Data display**: Table, Badge, Avatar, Tooltip
- **Feedback**: Alert, Toast, Progress, Skeleton
- **Navigation**: DropdownMenu, NavigationMenu, Command

## Component Architecture

### Component Types

**Presentation Components**
- Display UI based on props
- No business logic
- Reusable across features
- Located in `components/ui/`

```typescript
// components/ui/card.tsx
interface CardProps {
  title: string;
  description?: string;
  children?: React.ReactNode;
}

export function Card({ title, description, children }: CardProps) {
  return (
    <div className="card">
      <h3>{title}</h3>
      {description && <p>{description}</p>}
      {children}
    </div>
  );
}
```

**Container Components**
- Handle business logic and state
- Fetch data and manage interactions
- Compose presentation components
- Located in feature directories

```typescript
// app/dashboard/_components/UserDashboard.tsx
'use client';

import { useState } from 'react';
import { Card } from '@/components/ui/card';
import { Button } from '@/components/ui/button';

export function UserDashboard({ initialUsers }: { initialUsers: User[] }) {
  const [users, setUsers] = useState(initialUsers);

  const handleRefresh = async () => {
    const updated = await fetchUsers();
    setUsers(updated);
  };

  return (
    <div>
      <Card title="Users">
        <UserList users={users} />
        <Button onClick={handleRefresh}>Refresh</Button>
      </Card>
    </div>
  );
}
```

### Component Organization

```
components/
├── ui/                      # Reusable UI components
│   ├── button.tsx
│   ├── card.tsx
│   ├── input.tsx
│   ├── dialog.tsx
│   └── table.tsx
├── layout/                  # Layout components
│   ├── Header.tsx
│   ├── Sidebar.tsx
│   └── Footer.tsx
└── forms/                   # Form components
    ├── LoginForm.tsx
    └── UserForm.tsx

app/
└── dashboard/
    └── _components/         # Route-specific components
        ├── UserDashboard.tsx
        └── StatsCard.tsx
```

## Styling Approach

**Primary: Tailwind CSS (Required for Shadcn UI)**

Shadcn UI is built on Tailwind CSS, so Tailwind is the primary styling approach.

### Installation

```bash
# Tailwind CSS is automatically configured when initializing Shadcn UI
npx shadcn@latest init

# This sets up:
# - tailwind.config.ts
# - globals.css with Tailwind directives
# - Design tokens and CSS variables
```

### Using Tailwind with Shadcn Components

Shadcn components come pre-styled with Tailwind classes. You can extend or customize them:

```typescript
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';

export function Dashboard() {
  return (
    <Card className="max-w-md mx-auto">
      <CardContent className="pt-6">
        <Button className="w-full">
          Get Started
        </Button>
      </CardContent>
    </Card>
  );
}
```

### Custom Component Styling

For custom components, use Tailwind's utility classes:

```typescript
export function CustomCard({ children }: { children: React.ReactNode }) {
  return (
    <div className="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
      {children}
    </div>
  );
}
```

### Using `cn()` Utility for Class Merging

Shadcn provides a `cn()` utility (using `clsx` and `tailwind-merge`) for clean class management:

```typescript
import { cn } from '@/lib/utils';

interface ButtonProps {
  variant?: 'default' | 'destructive' | 'outline';
  className?: string;
  children: React.ReactNode;
}

export function CustomButton({ variant = 'default', className, children }: ButtonProps) {
  return (
    <button
      className={cn(
        'px-4 py-2 rounded-md font-medium transition',
        {
          'bg-primary text-primary-foreground hover:bg-primary/90': variant === 'default',
          'bg-destructive text-destructive-foreground hover:bg-destructive/90': variant === 'destructive',
          'border border-input bg-background hover:bg-accent': variant === 'outline',
        },
        className
      )}
    >
      {children}
    </button>
  );
}
```

### Global Styles and Theme

Shadcn UI uses CSS variables for theming. These are automatically set up in `app/globals.css`:

```css
/* app/globals.css */
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 222.2 84% 4.9%;
    --primary: 221.2 83.2% 53.3%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96.1%;
    --secondary-foreground: 222.2 47.4% 11.2%;
    --muted: 210 40% 96.1%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --accent: 210 40% 96.1%;
    --accent-foreground: 222.2 47.4% 11.2%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 221.2 83.2% 53.3%;
    --radius: 0.5rem;
  }

  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    /* ... other dark mode variables */
  }
}
```

### Customizing Theme

To customize colors, modify the CSS variables in `globals.css` or `tailwind.config.ts`:

```typescript
// tailwind.config.ts
import type { Config } from 'tailwindcss';

const config: Config = {
  theme: {
    extend: {
      colors: {
        border: 'hsl(var(--border))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
        },
        // ... other color mappings
      },
    },
  },
};
```

## Design Tokens

**IMPORTANT: Always use design tokens instead of hardcoded values.**

Design tokens are the single source of truth for all design decisions. Use them consistently across all UI components.

### Color Tokens

Colors are defined as CSS variables in `app/globals.css` and mapped to Tailwind classes.

**Semantic Colors** (use these in components):

```typescript
// ✅ GOOD - Use semantic color tokens
<div className="bg-primary text-primary-foreground">Primary Button</div>
<div className="bg-secondary text-secondary-foreground">Secondary</div>
<div className="bg-destructive text-destructive-foreground">Delete</div>
<div className="bg-muted text-muted-foreground">Muted Text</div>
<div className="border border-border">Card with border</div>

// ❌ BAD - Don't hardcode colors
<div className="bg-blue-500 text-white">Button</div>
<div className="bg-gray-100 text-gray-900">Card</div>
```

**Available Color Tokens**:

| Token | Usage | Tailwind Class |
|-------|-------|----------------|
| `background` | Page background | `bg-background` |
| `foreground` | Default text color | `text-foreground` |
| `card` | Card background | `bg-card` |
| `card-foreground` | Card text | `text-card-foreground` |
| `primary` | Primary actions | `bg-primary` |
| `primary-foreground` | Primary text | `text-primary-foreground` |
| `secondary` | Secondary actions | `bg-secondary` |
| `secondary-foreground` | Secondary text | `text-secondary-foreground` |
| `muted` | Muted backgrounds | `bg-muted` |
| `muted-foreground` | Muted text | `text-muted-foreground` |
| `accent` | Accent highlights | `bg-accent` |
| `accent-foreground` | Accent text | `text-accent-foreground` |
| `destructive` | Destructive actions | `bg-destructive` |
| `destructive-foreground` | Destructive text | `text-destructive-foreground` |
| `border` | Border color | `border-border` |
| `input` | Input border | `border-input` |
| `ring` | Focus ring | `ring-ring` |

### Typography Tokens

**Font Families**:

```typescript
// Use Tailwind's font utilities (configured in tailwind.config.ts)
<div className="font-sans">Default sans-serif font</div>
<div className="font-mono">Monospace font</div>
```

**Font Sizes**:

```typescript
// ✅ GOOD - Use typography scale tokens
<h1 className="text-4xl">Page Title</h1>
<h2 className="text-3xl">Section Title</h2>
<h3 className="text-2xl">Subsection</h3>
<p className="text-base">Body text</p>
<span className="text-sm">Small text</span>
<span className="text-xs">Extra small</span>

// ❌ BAD - Don't use arbitrary values
<h1 className="text-[32px]">Title</h1>
```

**Font Weight Tokens**:

| Token | Tailwind Class | Usage |
|-------|----------------|-------|
| Normal | `font-normal` | Body text |
| Medium | `font-medium` | Subtle emphasis |
| Semibold | `font-semibold` | Headings, labels |
| Bold | `font-bold` | Strong emphasis |

**Line Height**:

```typescript
<p className="leading-none">Tight line height</p>
<p className="leading-tight">Tight</p>
<p className="leading-normal">Normal (default)</p>
<p className="leading-relaxed">Relaxed</p>
```

### Spacing Tokens

**IMPORTANT: Use Tailwind's spacing scale. Never use arbitrary values.**

```typescript
// ✅ GOOD - Use spacing scale tokens
<div className="p-4">Padding 16px</div>
<div className="mb-6">Margin bottom 24px</div>
<div className="space-y-4">Vertical spacing 16px</div>
<div className="gap-2">Gap 8px</div>

// ❌ BAD - Don't use arbitrary values
<div className="p-[15px]">Padding</div>
<div className="mb-[25px]">Margin</div>
```

**Spacing Scale**:

| Token | Size | Tailwind Class | Common Usage |
|-------|------|----------------|--------------|
| 0 | 0px | `p-0`, `m-0` | Reset |
| 1 | 4px | `p-1`, `m-1`, `gap-1` | Tiny spacing |
| 2 | 8px | `p-2`, `m-2`, `gap-2` | Small spacing |
| 3 | 12px | `p-3`, `m-3`, `gap-3` | Medium-small |
| 4 | 16px | `p-4`, `m-4`, `gap-4` | Default spacing |
| 6 | 24px | `p-6`, `m-6`, `gap-6` | Large spacing |
| 8 | 32px | `p-8`, `m-8`, `gap-8` | Extra large |
| 12 | 48px | `p-12`, `m-12` | Section spacing |
| 16 | 64px | `p-16`, `m-16` | Major sections |

### Border Radius Tokens

```typescript
// ✅ GOOD - Use border radius tokens
<div className="rounded-sm">Small radius</div>
<div className="rounded">Default radius (0.25rem)</div>
<div className="rounded-md">Medium radius (0.375rem)</div>
<div className="rounded-lg">Large radius (0.5rem)</div>
<div className="rounded-xl">Extra large</div>
<div className="rounded-full">Circle/pill</div>

// ❌ BAD - Don't use arbitrary values
<div className="rounded-[10px]">Custom radius</div>
```

**Global Radius Token**:

The `--radius` CSS variable (default: 0.5rem) is used by Shadcn components. Modify it in `app/globals.css` to change all component border radii globally.

### Shadow Tokens

```typescript
// Use Tailwind's shadow scale
<div className="shadow-sm">Subtle shadow</div>
<div className="shadow">Default shadow</div>
<div className="shadow-md">Medium shadow</div>
<div className="shadow-lg">Large shadow</div>
<div className="shadow-xl">Extra large</div>
<div className="shadow-none">No shadow</div>
```

### Breakpoint Tokens

**Mobile-first responsive design**:

```typescript
// ✅ GOOD - Use breakpoint tokens
<div className="w-full md:w-1/2 lg:w-1/3">
  Responsive width
</div>

<div className="text-sm md:text-base lg:text-lg">
  Responsive typography
</div>

<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
  Responsive grid
</div>

// ❌ BAD - Don't use arbitrary breakpoints
<div className="@media(min-width:900px):w-1/2">Content</div>
```

**Breakpoint Scale**:

| Token | Size | Usage |
|-------|------|-------|
| `sm` | 640px | Small tablets |
| `md` | 768px | Tablets |
| `lg` | 1024px | Desktops |
| `xl` | 1280px | Large desktops |
| `2xl` | 1536px | Extra large screens |

### Z-Index Tokens

Define z-index values in `tailwind.config.ts`:

```typescript
// Use semantic z-index values
<div className="z-0">Base layer</div>
<div className="z-10">Elevated content</div>
<div className="z-20">Dropdown menus</div>
<div className="z-30">Fixed headers</div>
<div className="z-40">Modal overlays</div>
<div className="z-50">Toasts/notifications</div>
```

### Transition Tokens

```typescript
// Use consistent transition durations
<button className="transition-colors duration-200">Hover me</button>
<div className="transition-all duration-300">Animate</div>

// Available durations
duration-75   // 75ms
duration-100  // 100ms
duration-150  // 150ms
duration-200  // 200ms (recommended default)
duration-300  // 300ms
duration-500  // 500ms
duration-700  // 700ms
```

### Using Design Tokens in Custom Components

```typescript
import { cn } from '@/lib/utils';

interface CustomCardProps {
  variant?: 'default' | 'outline';
  children: React.ReactNode;
  className?: string;
}

export function CustomCard({ variant = 'default', children, className }: CustomCardProps) {
  return (
    <div
      className={cn(
        // Use token-based classes
        'rounded-lg p-6',  // Border radius and spacing tokens
        'transition-colors duration-200',  // Transition tokens
        {
          'bg-card text-card-foreground border border-border shadow-sm': variant === 'default',  // Color tokens
          'border-2 border-primary': variant === 'outline',
        },
        className
      )}
    >
      {children}
    </div>
  );
}
```

## Design System Best Practices

### Always Use Tokens

```typescript
// ✅ GOOD - Tokens everywhere
<div className="bg-primary text-primary-foreground p-4 rounded-lg shadow-md">
  <h2 className="text-2xl font-semibold mb-2">Title</h2>
  <p className="text-sm text-muted-foreground">Description</p>
</div>

// ❌ BAD - Hardcoded values
<div style={{
  backgroundColor: '#3b82f6',
  color: 'white',
  padding: '16px',
  borderRadius: '8px',
  boxShadow: '0 4px 6px rgba(0,0,0,0.1)'
}}>
  <h2 style={{ fontSize: '24px', fontWeight: 600, marginBottom: '8px' }}>Title</h2>
  <p style={{ fontSize: '14px', color: '#666' }}>Description</p>
</div>
```

### Token Hierarchy

1. **Semantic tokens first** - Use `primary`, `secondary`, `muted` etc.
2. **Tailwind scale tokens** - Use `text-sm`, `p-4`, `rounded-lg` etc.
3. **Never use arbitrary values** - No `text-[14px]`, `bg-[#ff0000]` etc.
4. **Never use inline styles** - Always use className with tokens

## UI Patterns

### Forms (with Shadcn UI)

Use Shadcn's Form components with react-hook-form and zod:

```bash
# Install form dependencies
npx shadcn@latest add form
npm install react-hook-form zod @hookform/resolvers
```

```typescript
// components/forms/UserForm.tsx
'use client';

import { zodResolver } from '@hookform/resolvers/zod';
import { useForm } from 'react-hook-form';
import * as z from 'zod';
import { Button } from '@/components/ui/button';
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form';
import { Input } from '@/components/ui/input';

const formSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters'),
  email: z.string().email('Invalid email address'),
});

type FormValues = z.infer<typeof formSchema>;

export function UserForm({ onSubmit }: { onSubmit: (data: FormValues) => Promise<void> }) {
  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      name: '',
      email: '',
    },
  });

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <FormField
          control={form.control}
          name="name"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Name</FormLabel>
              <FormControl>
                <Input placeholder="John Doe" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name="email"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Email</FormLabel>
              <FormControl>
                <Input type="email" placeholder="john@example.com" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <Button type="submit" disabled={form.formState.isSubmitting}>
          {form.formState.isSubmitting ? 'Submitting...' : 'Submit'}
        </Button>
      </form>
    </Form>
  );
}
```

### Loading States (with Shadcn UI)

```bash
npx shadcn@latest add skeleton
```

```typescript
import { Skeleton } from '@/components/ui/skeleton';
import { Card, CardContent, CardHeader } from '@/components/ui/card';

export function UserCardSkeleton() {
  return (
    <Card>
      <CardHeader>
        <Skeleton className="h-6 w-32" />
      </CardHeader>
      <CardContent>
        <Skeleton className="h-4 w-48 mb-2" />
        <Skeleton className="h-4 w-36" />
      </CardContent>
    </Card>
  );
}

// In Server Component
import { Suspense } from 'react';

export default function UsersPage() {
  return (
    <Suspense fallback={<UserCardSkeleton />}>
      <UserList />
    </Suspense>
  );
}
```

### Error States (with Shadcn UI)

```bash
npx shadcn@latest add alert
```

```typescript
// app/error.tsx
'use client';

import { Alert, AlertDescription, AlertTitle } from '@/components/ui/alert';
import { Button } from '@/components/ui/button';
import { AlertCircle } from 'lucide-react';

export default function Error({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return (
    <div className="container mx-auto p-6">
      <Alert variant="destructive">
        <AlertCircle className="h-4 w-4" />
        <AlertTitle>Error</AlertTitle>
        <AlertDescription>{error.message}</AlertDescription>
      </Alert>
      <Button onClick={reset} className="mt-4">
        Try again
      </Button>
    </div>
  );
}
```

### Empty States (with Shadcn UI)

```typescript
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';

export function EmptyState({
  title,
  description,
  action,
}: {
  title: string;
  description: string;
  action?: React.ReactNode;
}) {
  return (
    <Card className="w-full max-w-md mx-auto">
      <CardHeader>
        <CardTitle className="text-center text-muted-foreground">
          {title}
        </CardTitle>
      </CardHeader>
      <CardContent className="text-center space-y-4">
        <p className="text-sm text-muted-foreground">{description}</p>
        {action}
      </CardContent>
    </Card>
  );
}

// Usage
<EmptyState
  title="No users found"
  description="Get started by creating your first user."
  action={<Button>Create User</Button>}
/>
```

## Responsive Design

### Breakpoints

```css
/* Mobile first approach */
@media (min-width: 640px) { /* sm */ }
@media (min-width: 768px) { /* md */ }
@media (min-width: 1024px) { /* lg */ }
@media (min-width: 1280px) { /* xl */ }
```

### Responsive Components

```typescript
export function ResponsiveGrid({ children }: { children: React.ReactNode }) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      {children}
    </div>
  );
}
```

## Accessibility

**Shadcn UI has built-in accessibility.**

Shadcn components are built on [Radix UI](https://www.radix-ui.com/), which provides excellent accessibility out of the box:

- **ARIA attributes** - Automatically added to all components
- **Keyboard navigation** - Full keyboard support (Tab, Enter, Escape, Arrow keys)
- **Focus management** - Proper focus trapping and restoration
- **Screen reader support** - Semantic HTML and ARIA labels

### Using Accessible Shadcn Components

```typescript
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';

export function UserDialog() {
  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button>Open Dialog</Button>
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>User Details</DialogTitle>
        </DialogHeader>
        <p>Dialog content here...</p>
      </DialogContent>
    </Dialog>
  );
}

// Accessibility features automatically included:
// - Escape key to close
// - Focus trapping within dialog
// - Focus restoration when closed
// - ARIA attributes (role="dialog", aria-modal="true", etc.)
```

### Custom Accessible Components

For custom components, follow these guidelines:

```typescript
// Icon buttons need aria-label
export function IconButton({ icon, label, onClick }: IconButtonProps) {
  return (
    <button
      onClick={onClick}
      aria-label={label}
      className="p-2 rounded hover:bg-accent"
    >
      {icon}
    </button>
  );
}

// Form fields should have labels
import { Label } from '@/components/ui/label';
import { Input } from '@/components/ui/input';

<div className="space-y-2">
  <Label htmlFor="email">Email</Label>
  <Input id="email" type="email" />
</div>
```

## Performance

### Image Optimization

```typescript
import Image from 'next/image';

export function UserAvatar({ src, alt }: { src: string; alt: string }) {
  return (
    <Image
      src={src}
      alt={alt}
      width={48}
      height={48}
      className="rounded-full"
    />
  );
}
```

### Code Splitting

```typescript
import dynamic from 'next/dynamic';

// Lazy load heavy components
const Chart = dynamic(() => import('./Chart'), {
  loading: () => <ChartSkeleton />,
  ssr: false,
});

export function Dashboard() {
  return (
    <div>
      <Chart data={data} />
    </div>
  );
}
```

### Memoization

```typescript
'use client';

import { useMemo } from 'react';

export function UserList({ users, searchTerm }: UserListProps) {
  const filteredUsers = useMemo(() => {
    return users.filter(user =>
      user.name.toLowerCase().includes(searchTerm.toLowerCase())
    );
  }, [users, searchTerm]);

  return (
    <div>
      {filteredUsers.map(user => (
        <UserCard key={user.id} user={user} />
      ))}
    </div>
  );
}
```

## Animation

### Transitions

```css
.button {
  transition: all 0.2s ease-in-out;
}

.button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
```

### Loading Animations

```css
@keyframes spin {
  to { transform: rotate(360deg); }
}

.spinner {
  animation: spin 1s linear infinite;
}
```

## Best Practices

### Component Checklist

Before implementing any UI component or screen:

- [ ] **Search for similar existing screens** - Find and review similar pages first
- [ ] **Identify existing patterns** - Note layout, spacing, component structure
- [ ] **Use Shadcn UI components first** - Check https://ui.shadcn.com/docs/components
- [ ] **Follow existing patterns exactly** - Match container, spacing, component usage
- [ ] **Use design tokens for all styling** - Colors, spacing, typography, etc.
- [ ] **Reuse existing components** - Don't recreate what exists
- [ ] TypeScript props interface defined
- [ ] Default props provided where appropriate
- [ ] Accessible (Shadcn provides this automatically)
- [ ] Responsive design with Tailwind breakpoints
- [ ] Loading states handled (use Skeleton)
- [ ] Error states handled (use Alert)
- [ ] Empty states handled (use Card)
- [ ] Optimized for performance
- [ ] No hardcoded values (colors, sizes, spacing)
- [ ] No inline styles

### DO

- **ALWAYS search for similar screens first** - `find app -name "page.tsx"` before implementing
- **Follow existing patterns exactly** - Copy structure, spacing, component usage
- **Reuse existing components** - Check `components/` before creating new ones
- **Prioritize Shadcn UI components** - Use them for all common UI patterns
- **Always use design tokens** - `bg-primary`, `text-sm`, `p-4`, `rounded-lg` etc.
- **Use semantic color tokens** - `primary`, `secondary`, `muted`, not `blue-500`, `gray-100`
- **Use Tailwind's spacing scale** - `p-4`, `mb-6`, not arbitrary values
- **Use Tailwind CSS** for styling - Required for Shadcn
- **Leverage `cn()` utility** - For clean className merging
- Use semantic HTML elements
- Provide alt text for images
- Use proper heading hierarchy (h1, h2, h3)
- Keep components small and focused
- Extract reusable patterns
- Test on different screen sizes
- Use Server Components by default

### DON'T

- **Create new UI without checking existing screens first** - This causes inconsistency
- **Deviate from existing patterns** - Users expect consistency
- **Build custom components without checking Shadcn first**
- **Use hardcoded colors** - No `#3b82f6`, `rgb()`, or Tailwind color scales like `blue-500`
- **Use arbitrary values** - No `text-[14px]`, `p-[15px]`, `bg-[#fff]`
- **Use inline styles** - No `style={{...}}`
- **Use CSS Modules or other styling approaches** - Stick to Tailwind
- Use div for everything
- Create large monolithic components
- Skip loading/error states
- Ignore accessibility (Shadcn handles this)
- Make unnecessary Client Components

### Common Mistakes to Avoid

```typescript
// ❌ BAD - Not checking existing screens first
// Creating a new layout pattern without searching for existing ones
export default function ProductsPage() {
  return (
    <div className="p-8 max-w-7xl">  // Different from existing pattern!
      <h1 className="text-4xl mb-4">Products</h1>
      <div className="bg-white rounded p-4">
        <table>...</table>
      </div>
    </div>
  );
}

// ✅ GOOD - Found existing pattern and followed it exactly
// After searching: find app -name "page.tsx" -exec grep -l "container mx-auto" {} \;
// Found app/users/page.tsx uses this pattern, so use the SAME pattern:
export default function ProductsPage() {
  return (
    <div className="container mx-auto p-6">  // Same as existing!
      <div className="mb-6">
        <h1 className="text-3xl font-bold">Products</h1>
        <p className="text-muted-foreground">Manage your products</p>
      </div>
      <Card>
        <CardContent className="p-6">
          <Table>...</Table>
        </CardContent>
      </Card>
    </div>
  );
}

// ❌ BAD - Hardcoded color
<div className="bg-blue-500 text-white">Button</div>

// ✅ GOOD - Semantic color token
<div className="bg-primary text-primary-foreground">Button</div>

// ❌ BAD - Arbitrary spacing
<div className="p-[15px] mb-[20px]">Content</div>

// ✅ GOOD - Spacing scale tokens
<div className="p-4 mb-6">Content</div>

// ❌ BAD - Inline styles
<div style={{ fontSize: '14px', color: '#666' }}>Text</div>

// ✅ GOOD - Design tokens
<div className="text-sm text-muted-foreground">Text</div>

// ❌ BAD - Hardcoded font size
<h1 className="text-[32px]">Title</h1>

// ✅ GOOD - Typography token
<h1 className="text-3xl">Title</h1>
```

## Shadcn UI Component Checklist

When building UI, add these Shadcn components as needed:

**Common Components** (add first):
```bash
npx shadcn@latest add button
npx shadcn@latest add card
npx shadcn@latest add input
npx shadcn@latest add label
npx shadcn@latest add form
npx shadcn@latest add alert
npx shadcn@latest add skeleton
```

**Form Elements**:
```bash
npx shadcn@latest add select
npx shadcn@latest add checkbox
npx shadcn@latest add radio-group
npx shadcn@latest add switch
npx shadcn@latest add textarea
```

**Layout & Navigation**:
```bash
npx shadcn@latest add separator
npx shadcn@latest add tabs
npx shadcn@latest add dialog
npx shadcn@latest add sheet
npx shadcn@latest add dropdown-menu
npx shadcn@latest add navigation-menu
```

**Data Display**:
```bash
npx shadcn@latest add table
npx shadcn@latest add badge
npx shadcn@latest add avatar
npx shadcn@latest add tooltip
```

**Feedback**:
```bash
npx shadcn@latest add toast
npx shadcn@latest add progress
```

**Only build custom components when:**
- Shadcn doesn't provide a suitable component
- You need very specific, domain-specific functionality
- You've exhausted customization options for existing Shadcn components

## References

- **[Shadcn UI Documentation](https://ui.shadcn.com/docs)** - Primary component library
- **[Shadcn UI Components](https://ui.shadcn.com/docs/components)** - All available components
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Radix UI Documentation](https://www.radix-ui.com/) - Shadcn's accessibility foundation
- [Next.js Documentation](https://nextjs.org/docs)
- [React Hook Form](https://react-hook-form.com/) - Form handling
- [Zod](https://zod.dev/) - Schema validation
- [React Accessibility](https://react.dev/learn/accessibility)
- [Web Content Accessibility Guidelines (WCAG)](https://www.w3.org/WAI/WCAG21/quickref/)
