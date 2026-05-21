# Best Practices & Performance Optimization

## Code Organization

### Component Structure

```
components/
├── ui/                    # Reusable UI components
│   ├── Button.tsx        # Export as named export
│   ├── Input.tsx         # Always forwardRef
│   └── Card.tsx          # Document prop types
├── chat/                 # Feature-specific components
│   └── ChatMessage.tsx   # Keep components small
└── auth/                 # Auth-related components
```

### Naming Conventions

```typescript
// Components: PascalCase
export function UserProfile() {}

// Utilities: camelCase
export function formatDate(date: Date) {}

// Constants: UPPER_SNAKE_CASE
export const API_BASE_URL = 'http://localhost:3000'

// Types: PascalCase
interface UserProps {
  name: string
}
```

## Performance Optimization

### 1. Image Optimization

```typescript
import Image from 'next/image'

// ✅ Good
<Image
  src="/logo.png"
  alt="Logo"
  width={100}
  height={100}
  priority
/>

// ❌ Avoid
<img src="/logo.png" alt="Logo" />
```

### 2. Code Splitting

```typescript
// ✅ Good - Dynamic import for heavy components
const HeavyComponent = dynamic(() => import('./Heavy'), {
  loading: () => <Skeleton />
})

// ✅ Good - Separate routes
export default function DashboardLayout({ children }) {
  // Only loads when route is accessed
}
```

### 3. Database Query Optimization

```typescript
// ❌ Bad - N+1 query problem
const users = await prisma.user.findMany()
for (const user of users) {
  const posts = await prisma.post.findMany({
    where: { userId: user.id }
  })
}

// ✅ Good - Use include
const users = await prisma.user.findMany({
  include: { posts: true }
})

// ✅ Good - Limit fields
const users = await prisma.user.findMany({
  select: { id: true, email: true, name: true }
})
```

### 4. Memoization

```typescript
import { useMemo, useCallback } from 'react'

// ✅ Memoize expensive computations
const expensiveValue = useMemo(() => {
  return calculateSomethingExpensive()
}, [dependency])

// ✅ Memoize callbacks
const handleClick = useCallback(() => {
  doSomething()
}, [dependency])
```

### 5. API Response Caching

```typescript
// ✅ Cache GET requests
export async function GET(request: NextRequest) {
  return NextResponse.json(data, {
    headers: {
      'Cache-Control': 'public, max-age=60', // 1 minute
    }
  })
}
```

## Security Best Practices

### 1. Environment Variables

```typescript
// ✅ Good
const apiKey = process.env.OPENAI_API_KEY
if (!apiKey) {
  throw new Error('OPENAI_API_KEY is not set')
}

// ❌ Bad - No validation
const apiKey = process.env.OPENAI_API_KEY
```

### 2. Input Validation

```typescript
import { z } from 'zod'

// ✅ Good - Validate with Zod
const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8)
})

const validated = schema.safeParse(input)
if (!validated.success) {
  return NextResponse.json({ error: 'Invalid input' }, { status: 400 })
}
```

### 3. SQL Injection Prevention

```typescript
// ✅ Good - Prisma prevents SQL injection
const user = await prisma.user.findUnique({
  where: { email: userInput }
})

// ❌ Bad - Raw SQL (if using it)
// Avoid: `SELECT * FROM users WHERE email = '${email}'`
```

### 4. Authentication

```typescript
// ✅ Good - Check session
const session = await getServerSession(authOptions)
if (!session?.user) {
  return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
}

// ✅ Good - Protect routes with middleware
export async function middleware(request) {
  const session = await getSession({ req: request })
  if (!session) {
    return NextResponse.redirect('/auth/login')
  }
}
```

### 5. Secrets Management

```typescript
// ✅ Good - Use environment variables
const secret = process.env.NEXTAUTH_SECRET

// ✅ Good - Minimal 32 characters
// NEXTAUTH_SECRET = "at_least_32_characters_here_..."

// ❌ Bad - Hardcoded secrets
const secret = 'my-secret-key'
```

## Error Handling

### API Error Handling

```typescript
// ✅ Good
export async function GET(request: NextRequest) {
  try {
    const data = await prisma.conversation.findMany()
    return NextResponse.json(data)
  } catch (error) {
    console.error('Error fetching conversations:', error)
    return NextResponse.json(
      { error: 'Failed to fetch conversations' },
      { status: 500 }
    )
  }
}

// ✅ Good - Specific error handling
try {
  const response = await openai.chat.completions.create(...)
} catch (error) {
  if (error instanceof OpenAI.RateLimitError) {
    return NextResponse.json(
      { error: 'Rate limit exceeded' },
      { status: 429 }
    )
  }
}
```

### Client Error Handling

```typescript
// ✅ Good
try {
  const response = await fetch('/api/conversations')
  if (!response.ok) {
    notification.error('Failed to load conversations')
    return
  }
  const data = await response.json()
  setConversations(data)
} catch (error) {
  notification.error('An error occurred')
  console.error(error)
}
```

## Testing Best Practices

### Unit Testing

```typescript
// Example test structure
import { render, screen } from '@testing-library/react'
import { Button } from '@/components/ui/Button'

describe('Button Component', () => {
  it('renders correctly', () => {
    render(<Button>Click me</Button>)
    expect(screen.getByText('Click me')).toBeInTheDocument()
  })

  it('handles click events', () => {
    const handleClick = jest.fn()
    render(<Button onClick={handleClick}>Click</Button>)
    screen.getByText('Click').click()
    expect(handleClick).toHaveBeenCalled()
  })
})
```

### E2E Testing

```typescript
// Example with Playwright
test('user can login and chat', async ({ page }) => {
  await page.goto('http://localhost:3000')
  await page.click('text=Sign In')
  await page.fill('input[name=email]', 'test@example.com')
  await page.fill('input[name=password]', 'password123')
  await page.click('button:has-text("Sign In")')
  await page.waitForURL('/dashboard')
})
```

## Database Best Practices

### 1. Indexing

```prisma
model User {
  id    String  @id @default(cuid())
  email String  @unique  // Automatically indexed
  
  @@index([createdAt])  // Add index for sorting
}
```

### 2. Relationships

```prisma
// ✅ Good - Define relationships clearly
model Conversation {
  id     String   @id
  userId String
  user   User     @relation(fields: [userId], references: [id], onDelete: Cascade)
}

// ✅ Good - Use cascade delete
model Message {
  id             String        @id
  conversationId String
  conversation   Conversation  @relation(fields: [conversationId], references: [id], onDelete: Cascade)
}
```

### 3. Timestamps

```prisma
model Conversation {
  // ... other fields
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt  // Automatically updated
}
```

## State Management Best Practices

### 1. Use Context for Global State

```typescript
// ✅ Good - For simple global state
const ThemeContext = createContext<ThemeContextType | undefined>(undefined)

export function ThemeProvider({ children }) {
  const [isDark, setIsDark] = useState(false)
  
  return (
    <ThemeContext.Provider value={{ isDark, setIsDark }}>
      {children}
    </ThemeContext.Provider>
  )
}

export const useTheme = () => {
  const context = useContext(ThemeContext)
  if (!context) throw new Error('useTheme must be used within ThemeProvider')
  return context
}
```

### 2. Use Server Components

```typescript
// ✅ Good - Fetch data on server
export default async function Page() {
  const conversations = await prisma.conversation.findMany()
  return <ConversationList data={conversations} />
}

// ✅ Good - Use 'use client' only when needed
'use client'
export default function InteractiveComponent() {
  // Interactive logic here
}
```

## Documentation Best Practices

### 1. JSDoc Comments

```typescript
/**
 * Format date to readable format
 * @param date - The date to format
 * @returns Formatted date string
 * @example
 * formatDate(new Date()) // "Jan 1, 2024"
 */
export function formatDate(date: Date): string {
  // ...
}
```

### 2. Inline Comments

```typescript
// ✅ Good - Explain why, not what
// Fetch conversations in reverse chronological order
// to show recent chats first
const conversations = await prisma.conversation.findMany({
  orderBy: { updatedAt: 'desc' }
})

// ❌ Bad - Explains obvious code
// Get conversations
const conversations = await prisma.conversation.findMany()
```

## Git Workflow

### Commit Messages

```
// Format: <type>(<scope>): <subject>

// Good commits
feat(auth): add Google OAuth integration
fix(chat): fix message streaming timeout
docs(readme): update installation instructions
style(components): format code with prettier

// Avoid
Updated stuff
fixed bug
changes
WIP
```

### Branch Naming

```
feature/add-voice-input
bugfix/fix-authentication-error
docs/update-api-documentation
hotfix/critical-security-patch
```

## Performance Monitoring

### Lighthouse Audit

```bash
# Run Lighthouse audit
npm install -g lighthouse
lighthouse http://localhost:3000

# Check Core Web Vitals
# - Largest Contentful Paint (LCP): < 2.5s
# - First Input Delay (FID): < 100ms
# - Cumulative Layout Shift (CLS): < 0.1
```

### Database Monitoring

```bash
# Check slow queries
npm run prisma:studio

# Enable query logging in development
const prisma = new PrismaClient({
  log: ['query', 'error', 'warn']
})
```

## Scalability Tips

1. **Database**: Use connection pooling (Prisma handles this)
2. **Caching**: Implement Redis for frequently accessed data
3. **CDN**: Serve static assets from CDN
4. **Rate Limiting**: Implement rate limiting on API endpoints
5. **Load Balancing**: Use multiple app instances
6. **Monitoring**: Set up error tracking (Sentry, etc.)

## Production Checklist

- [ ] NEXTAUTH_SECRET is strong (32+ chars)
- [ ] All env variables are set
- [ ] Database backups are configured
- [ ] Error monitoring is set up
- [ ] Rate limiting is implemented
- [ ] HTTPS is enabled
- [ ] Security headers are configured
- [ ] Database is indexed properly
- [ ] API responses are cached appropriately
- [ ] Logs are centralized and monitored

---

**Remember: Write code for humans first, computers second. ✨**
