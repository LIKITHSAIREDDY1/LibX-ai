# Troubleshooting Guide

Common issues and their solutions.

## Installation & Setup

### Issue: npm install fails

**Error**: `npm ERR! code ERESOLVE`

**Solution**:
```bash
# Clear npm cache
npm cache clean --force

# Try with legacy peer deps
npm install --legacy-peer-deps

# Or use different node version
nvm install 18
nvm use 18
```

---

### Issue: PostgreSQL connection fails

**Error**: `connection refused at 127.0.0.1:5432`

**Solution**:
```bash
# Check if PostgreSQL is running
# macOS
brew services list

# Start PostgreSQL
brew services start postgresql

# On Linux
sudo systemctl start postgresql

# Test connection
psql -U postgres
```

**For Neon users**:
- Ensure connection string includes `?sslmode=require`
- Check firewall/network access
- Verify password doesn't contain special characters requiring encoding

---

### Issue: Prisma Client not found

**Error**: `Cannot find module '@prisma/client'`

**Solution**:
```bash
# Regenerate Prisma Client
npx prisma generate

# Reinstall package
npm install @prisma/client

# Restart dev server
npm run dev
```

---

### Issue: .env.local not loading

**Error**: Environment variables undefined

**Solution**:
```bash
# Verify .env.local exists in root directory
ls -la .env.local

# Check format (no quotes needed for values)
DATABASE_URL=postgresql://...  # ✅ Correct
DATABASE_URL="postgresql://..."  # ✅ Also correct

# Restart dev server
npm run dev
```

---

## Development

### Issue: Port 3000 already in use

**Error**: `Error: listen EADDRINUSE: address already in use :::3000`

**Solution**:
```bash
# Find process using port 3000
# macOS/Linux
lsof -i :3000

# Kill the process
kill -9 <PID>

# Or use different port
npm run dev -- -p 3001
```

---

### Issue: Hot reload not working

**Error**: Changes don't reflect in browser

**Solution**:
```bash
# Clear Next.js cache
rm -rf .next

# Restart dev server
npm run dev

# Clear browser cache (Cmd+Shift+R or Ctrl+Shift+R)

# Check file watching limits (Linux)
cat /proc/sys/fs/inotify/max_user_watches
# Increase if needed: echo 524288 | sudo tee /proc/sys/fs/inotify/max_user_watches
```

---

### Issue: TypeScript errors in editor

**Error**: Red squiggles in VS Code

**Solution**:
```bash
# Reinstall dependencies
rm -rf node_modules
npm install

# Regenerate Prisma types
npm run prisma:generate

# Restart TS server
# In VS Code: Cmd+Shift+P → TypeScript: Restart TS Server
```

---

### Issue: Module not found errors

**Error**: `Cannot find module '@/lib/utils'`

**Solution**:
```bash
# Check tsconfig.json path aliases
cat tsconfig.json | grep paths

# Verify actual file exists
ls src/lib/utils

# Clear cache and reinstall
rm -rf .next node_modules
npm install
npm run dev
```

---

## Database

### Issue: Database migrations fail

**Error**: `Migration failed`

**Solution**:
```bash
# Check migration status
npx prisma migrate status

# View migration history
ls prisma/migrations

# Reset database (development only!)
npx prisma migrate reset
# This will delete all data, so confirm carefully

# Or manually:
npx prisma db push --force-reset
```

---

### Issue: Prisma Studio won't open

**Error**: Port 5555 in use or connection error

**Solution**:
```bash
# Use different port
npx prisma studio --browser=none

# Visit: http://localhost:5555

# If port is in use:
# Kill process or use: npx prisma studio --port 5556
```

---

### Issue: Seed data not inserting

**Error**: Seed script fails or creates no data

**Solution**:
```bash
# Check seed file
cat prisma/seed.js

# Run with verbose output
npx ts-node --esm prisma/seed.ts

# Verify database connection first
npm run prisma:migrate

# Check for constraint violations
# Verify no duplicate unique fields
```

---

## Authentication

### Issue: NextAuth not working

**Error**: `NEXTAUTH_SECRET not set` or redirect loops

**Solution**:
```bash
# 1. Verify NEXTAUTH_SECRET is set
echo $NEXTAUTH_SECRET

# 2. Ensure it's strong (32+ characters)
node -e "console.log(process.env.NEXTAUTH_SECRET.length)"

# 3. Verify NEXTAUTH_URL
echo $NEXTAUTH_URL

# 4. Check session cookie
# Open DevTools → Application → Cookies
# Should see: next-auth.session-token

# 5. Clear cookies and try again
# DevTools → Application → Clear Site Data

# 6. Restart dev server
npm run dev
```

---

### Issue: Login page shows blank

**Error**: White screen on /auth/login

**Solution**:
```bash
# Check for TypeScript errors
npm run lint

# Check browser console for errors
# DevTools → Console tab

# Verify components are properly exported
grep -r "export.*LoginForm" src/

# Check import paths
# grep -r "@/components/auth" src/
```

---

### Issue: Google OAuth not working

**Error**: `invalid_grant` or `redirect_uri_mismatch`

**Solution**:
1. Go to [console.cloud.google.com](https://console.cloud.google.com)
2. Verify Authorized redirect URIs:
   - `http://localhost:3000/api/auth/callback/google` (dev)
   - `https://yourdomain.com/api/auth/callback/google` (prod)
3. Check credentials:
   ```bash
   echo $GOOGLE_CLIENT_ID
   echo $GOOGLE_CLIENT_SECRET
   ```
4. Ensure cookies are enabled in browser
5. Try incognito mode to clear cookies

---

### Issue: Session expires immediately

**Error**: User logged out after page refresh

**Solution**:
```bash
# Check NEXTAUTH_SECRET consistency
# Must be same in all environments

# Verify cookie settings in .env
NEXTAUTH_URL must match your app URL

# Check session maxAge in auth config
// 30 days in seconds
session: {
  maxAge: 30 * 24 * 60 * 60
}

# Restart dev server
npm run dev
```

---

## API & Chat

### Issue: OpenAI API errors

**Error**: `401 Unauthorized` or `429 Rate limit`

**Solution**:
1. Verify API key:
   ```bash
   echo $OPENAI_API_KEY
   ```

2. Check API key validity:
   - Visit https://platform.openai.com/account/api-keys
   - Verify key is active and not deleted

3. Check API credits:
   - Visit https://platform.openai.com/account/billing/overview
   - Ensure you have usage quota

4. Check model availability:
   - Verify "gpt-3.5-turbo" is available in your region
   - Check OpenAI status page

5. For rate limits:
   - Add retry logic
   - Implement backoff strategy
   - Check usage limits: https://platform.openai.com/account/billing/limits

---

### Issue: Messages not streaming

**Error**: Long pause before response, no real-time streaming

**Solution**:
```typescript
// Check fetch implementation
const response = await fetch('/api/messages', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(...)
})

// Verify ReadableStream handling
const reader = response.body.getReader()
const decoder = new TextDecoder()

while (true) {
  const { done, value } = await reader.read()
  if (done) break
  // Process chunks
}

// Check browser console for errors
// DevTools → Console tab
```

---

### Issue: Conversation not saving

**Error**: Messages appear but don't persist after reload

**Solution**:
```bash
# Check database connection
npm run prisma:studio

# Verify messages table has data
SELECT * FROM "messages";

# Check API response
# DevTools → Network → messages endpoint
# Look for 200 status code

# Verify user is authenticated
# Check session in cookies
```

---

## Deployment

### Issue: Vercel deployment fails

**Error**: Build fails or deployment error

**Solution**:
1. Check build logs:
   - Vercel Dashboard → Deployments → Failed build
   - Review error messages

2. Common issues:
   ```bash
   # Missing environment variables
   # Add to Vercel project settings

   # Build step failing
   npm run build  # Test locally

   # Database migration not running
   # Add build command: npm run build && npx prisma migrate deploy
   ```

---

### Issue: Database connection in production

**Error**: `connection refused` or timeout on Vercel

**Solution**:
1. Verify DATABASE_URL:
   ```bash
   # Check Vercel environment variables
   # Must include: ?sslmode=require for Neon
   ```

2. Check database status:
   - Neon: https://neon.tech/status
   - Supabase: https://status.supabase.com

3. Verify firewall/network:
   - Check IP allowlist in database provider
   - Vercel IPs may need to be whitelisted

---

## Performance

### Issue: Slow responses

**Error**: API takes 10+ seconds to respond

**Solution**:
```bash
# Check Prisma query performance
# Enable query logging
const prisma = new PrismaClient({
  log: ['query', 'error']
})

# Look for N+1 queries or missing indexes

# Check OpenAI API latency
# Some models are slower than others

# Implement caching
// Cache GET requests
export async function GET() {
  return NextResponse.json(data, {
    headers: { 'Cache-Control': 'max-age=60' }
  })
}
```

---

### Issue: High database queries

**Error**: Database connection pool exhausted

**Solution**:
```prisma
// Use select instead of include when possible
// ✅ Good
const users = await prisma.user.findMany({
  select: { id: true, email: true }
})

// ❌ Avoid
const users = await prisma.user.findMany({
  include: { posts: true, comments: true }
})

// Add pagination
const users = await prisma.user.findMany({
  take: 10,
  skip: 0
})
```

---

## Browser Issues

### Issue: Login button doesn't work

**Error**: Button click has no effect

**Solution**:
```bash
# Check JavaScript is enabled
# DevTools → Console → Errors

# Verify form submission
# DevTools → Network → Check POST request

# Check API endpoint is accessible
fetch('/api/auth/register').then(r => r.json())

# Clear browser cache and cookies
# Settings → Privacy → Clear site data
```

---

### Issue: Styling not loading correctly

**Error**: Page looks unstyled or colors wrong

**Solution**:
```bash
# Rebuild Tailwind CSS
npm run build

# Clear browser cache
# Cmd+Shift+R (macOS) or Ctrl+Shift+R (Windows)

# Check dark mode
# DevTools → Elements → HTML has "dark" class

# Verify tailwind.config.ts
cat tailwind.config.ts

# Rebuild CSS
rm -rf .next
npm run dev
```

---

## Getting Help

1. **Check Logs**:
   - Browser console (DevTools)
   - Server logs (terminal)
   - Vercel logs (dashboard)

2. **Search Documentation**:
   - README.md
   - API.md
   - BEST_PRACTICES.md

3. **Search GitHub Issues**:
   - [Next.js Issues](https://github.com/vercel/next.js/issues)
   - [Prisma Issues](https://github.com/prisma/prisma/issues)
   - [NextAuth Issues](https://github.com/nextauthjs/next-auth/issues)

4. **Create Issue**:
   - Include error message
   - Steps to reproduce
   - System info (OS, Node version)
   - Relevant code snippets

---

**Still stuck? Check the FAQ or create an issue! 🆘**
