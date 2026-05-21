# Installation & Setup Guide

Complete step-by-step guide to set up LibX AI locally.

## System Requirements

- **Node.js**: 18.17 or higher
- **npm**: 8.x or higher (or yarn/pnpm)
- **PostgreSQL**: 14+ or use cloud database (Neon)
- **Git**: Latest version
- **Code Editor**: VS Code recommended

## Step 1: Clone Repository

```bash
# Clone the repository
git clone <repository-url>
cd libx-ai

# Or if starting fresh
mkdir libx-ai
cd libx-ai
```

## Step 2: Install Dependencies

```bash
# Install all project dependencies
npm install

# Verify installation
npm list --depth=0
```

Expected packages:
- next@14.x
- react@18.x
- prisma@5.x
- next-auth@4.x
- And other dependencies listed in package.json

## Step 3: Database Setup

### Option A: Local PostgreSQL

```bash
# Install PostgreSQL (macOS with Homebrew)
brew install postgresql

# Start PostgreSQL service
brew services start postgresql

# Create database
createdb libx_ai

# Get connection string
# postgresql://localhost:5432/libx_ai
```

### Option B: Cloud Database (Neon - Recommended)

1. Visit [neon.tech](https://neon.tech)
2. Sign up for free account
3. Create new project
4. Copy connection string
5. Include in `.env.local`

### Option C: Cloud Database (Supabase)

1. Visit [supabase.com](https://supabase.com)
2. Create new project
3. Get PostgreSQL connection string
4. Include in `.env.local`

## Step 4: Environment Configuration

### Create `.env.local` file

```bash
# Create file
touch .env.local

# Or on Windows
New-Item -Path .env.local -Type File
```

### Configure Environment Variables

```env
# ==========================================
# DATABASE CONFIGURATION
# ==========================================
# Format: postgresql://username:password@host:port/database
# Local: postgresql://postgres:password@localhost:5432/libx_ai
# Neon: postgresql://user:password@host/dbname?sslmode=require
DATABASE_URL="postgresql://user:password@host:5432/libx_ai"

# ==========================================
# NEXTAUTH CONFIGURATION
# ==========================================
# Generate with: openssl rand -base64 32
NEXTAUTH_SECRET="your-32-character-secret-key-here"

# Your app URL
NEXTAUTH_URL="http://localhost:3000"

# ==========================================
# GOOGLE OAUTH (Optional)
# ==========================================
# Get from: https://console.cloud.google.com
GOOGLE_CLIENT_ID="your-google-client-id.apps.googleusercontent.com"
GOOGLE_CLIENT_SECRET="your-google-client-secret"

# ==========================================
# OPENAI API
# ==========================================
# Get from: https://platform.openai.com/api-keys
OPENAI_API_KEY="sk-your-openai-api-key-here"

# ==========================================
# PUBLIC APP SETTINGS
# ==========================================
NEXT_PUBLIC_APP_URL="http://localhost:3000"
NEXT_PUBLIC_APP_NAME="LibX AI"
```

### Generate NEXTAUTH_SECRET

```bash
# Using OpenSSL (macOS/Linux)
openssl rand -base64 32

# Using Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"

# Using Python
python3 -c "import secrets; print(secrets.token_urlsafe(32))"
```

## Step 5: Database Schema Setup

### Initialize Prisma

```bash
# Generate Prisma Client
npm run prisma:generate

# Push schema to database
npm run prisma:push

# Or run migrations
npm run prisma:migrate
```

### Verify Database Setup

```bash
# View database with Prisma Studio
npm run prisma:studio

# This opens http://localhost:5555 in your browser
```

### Optional: Seed Database

```bash
# Install bcryptjs for password hashing
npm install bcryptjs

# Seed with sample data
npm run prisma:seed
```

This creates a test user:
- **Email**: test@example.com
- **Password**: password123

## Step 6: Get API Keys

### OpenAI API Key

1. Visit [platform.openai.com](https://platform.openai.com)
2. Sign up or log in
3. Go to "API keys" section
4. Click "Create new secret key"
5. Copy and save securely
6. Add to `.env.local`

### Google OAuth (Optional)

1. Visit [console.cloud.google.com](https://console.cloud.google.com)
2. Create new project
3. Enable "Google+ API"
4. Go to "Credentials"
5. Click "Create Credentials" → "OAuth 2.0 Client ID"
6. Select "Web application"
7. Add Authorized redirect URIs:
   - `http://localhost:3000/api/auth/callback/google`
   - `http://127.0.0.1:3000/api/auth/callback/google`
8. Copy Client ID and Secret
9. Add to `.env.local`

## Step 7: Start Development Server

```bash
# Start development server
npm run dev

# Output should show:
# ▲ Next.js 14.0.0
# - Local: http://localhost:3000
# - Environments: .env.local
```

Visit `http://localhost:3000` in your browser.

## Step 8: Test the Application

### Create Account

1. Click "Get Started" on landing page
2. Sign up with:
   - Name: Your name
   - Email: your-email@example.com
   - Password: Must have uppercase, lowercase, and numbers
3. Click "Create Account"

### Login

1. Use credentials from registration
2. Or use test account (if seeded):
   - Email: test@example.com
   - Password: password123

### Create First Chat

1. Click "New Chat" in sidebar
2. Type a message
3. Send message (Ctrl+Enter or click Send)
4. Wait for AI response
5. Test features:
   - Copy message button
   - Dark/Light mode toggle
   - Rename conversation
   - Delete conversation

## Development Workflow

### Common Commands

```bash
# Start development server with hot reload
npm run dev

# Build for production
npm run build

# Start production build
npm start

# Run linter
npm run lint

# Generate Prisma types
npm run prisma:generate

# Open Prisma Studio
npm run prisma:studio

# Create new migration
npm run prisma:migrate

# View API documentation
# Add comments to your routes and use tools like Swagger
```

### Directory Structure Reference

```
src/
├── app/
│   ├── api/
│   │   ├── auth/[...nextauth]/route.ts     # Auth endpoints
│   │   ├── auth/register/route.ts          # Register endpoint
│   │   ├── conversations/route.ts          # List & create chats
│   │   ├── conversations/[id]/route.ts     # Individual chat ops
│   │   └── messages/route.ts               # Send message
│   ├── auth/
│   │   ├── login/page.tsx                  # Login page
│   │   └── register/page.tsx               # Signup page
│   ├── dashboard/
│   │   ├── page.tsx                        # Dashboard home
│   │   ├── chat/[id]/page.tsx             # Chat interface
│   │   └── layout.tsx                      # Dashboard layout
│   ├── layout.tsx                          # Root layout
│   ├── page.tsx                            # Landing page
│   ├── globals.css                         # Global styles
│   └── providers.tsx                       # Context providers
├── components/
│   ├── ui/                                 # Reusable components
│   ├── chat/                               # Chat components
│   └── auth/                               # Auth components
├── lib/
│   ├── auth/                               # Auth config
│   ├── utils/                              # Utilities
│   ├── prisma.ts                          # Prisma client
│   └── schemas.ts                         # Validation schemas
├── context/                                # React Context
└── hooks/                                  # Custom hooks
```

## Troubleshooting Setup

### Issue: Dependencies Installation Fails

```bash
# Clear npm cache
npm cache clean --force

# Remove node_modules
rm -rf node_modules

# Reinstall
npm install
```

### Issue: Database Connection Error

```bash
# Test PostgreSQL connection
psql -U postgres -d libx_ai

# Check DATABASE_URL format
echo $DATABASE_URL

# For Neon, ensure ?sslmode=require is included
```

### Issue: Prisma Client Not Found

```bash
# Regenerate Prisma Client
npx prisma generate

# Ensure package is installed
npm install @prisma/client
```

### Issue: OpenAI API Errors

```bash
# Verify API key is set
echo $OPENAI_API_KEY

# Check OpenAI API status
curl https://status.openai.com/

# Verify account has credits
# Visit https://platform.openai.com/account/billing
```

### Issue: NextAuth Not Working

```bash
# Verify NEXTAUTH_SECRET is strong (32+ chars)
node -e "console.log(process.env.NEXTAUTH_SECRET.length)"

# Check NEXTAUTH_URL matches localhost
echo $NEXTAUTH_URL

# Clear browser cookies
# Settings → Privacy → Cookies → Clear Site Data
```

## Next Steps

After successful installation:

1. **Explore the Codebase**: Read through the components and API routes
2. **Customize**: Update branding, colors, and configuration
3. **Extend Features**: Add new functionality as needed
4. **Deploy**: Follow the deployment guide when ready
5. **Optimize**: Implement caching and performance improvements

## IDE Setup (VS Code)

### Recommended Extensions

```json
{
  "extensions": [
    "ms-dotnettools.csharp",
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "PKief.material-icon-theme",
    "ThemeOfficial.theme-dracula",
    "Prisma.prisma"
  ]
}
```

### VS Code Settings

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.enablePromptUseWorkspaceTsdk": true
}
```

## Performance Tips

- Keep node_modules clean: `npm prune`
- Use faster package manager: `yarn` or `pnpm`
- Enable faster refresh in Next.js
- Use environment variables for sensitive data
- Optimize database queries with Prisma

---

**Setup Complete! You're ready to develop. 🚀**
