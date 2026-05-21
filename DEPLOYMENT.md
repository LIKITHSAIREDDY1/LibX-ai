# Deployment Guide

This guide covers deploying LibX AI to production using Vercel and Neon PostgreSQL.

## Prerequisites

- GitHub account with your repository
- Vercel account (free)
- Neon account (free tier available)
- OpenAI API key

## Step 1: Database Setup (Neon PostgreSQL)

### Create Neon Project

1. Visit [neon.tech](https://neon.tech)
2. Sign up/login to your account
3. Create a new project
4. Select your region
5. Note the connection string

### Get Connection String

1. In Neon dashboard, go to your project
2. Click on database (typically "neondb")
3. Copy the connection string with your password
4. Format: `postgresql://user:password@host/dbname`

### Store Connection String

Save this for Step 3 when setting up Vercel environment variables.

## Step 2: Prepare Your Code

### Generate Secrets

```bash
# Generate NEXTAUTH_SECRET (min 32 characters)
openssl rand -base64 32
```

Copy this for later use.

### Push to GitHub

```bash
# Initialize git (if not already done)
git init
git add .
git commit -m "Initial commit: LibX AI chatbot"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/libx-ai.git
git push -u origin main
```

## Step 3: Deploy to Vercel

### Import Project

1. Go to [vercel.com](https://vercel.com)
2. Click "Add New..." → "Project"
3. Click "Import Git Repository"
4. Search for your `libx-ai` repository
5. Click "Import"

### Configure Project

1. Keep default settings
2. Click "Deploy"
3. Wait for initial deployment (2-5 minutes)

### Add Environment Variables

After initial deployment fails (expected, no env vars):

1. Go to project settings
2. Click "Environment Variables"
3. Add the following variables:

```
DATABASE_URL=postgresql://user:password@host/dbname
NEXTAUTH_SECRET=your-32-character-secret-key
NEXTAUTH_URL=https://your-domain.vercel.app
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
OPENAI_API_KEY=your-openai-api-key
NEXT_PUBLIC_APP_URL=https://your-domain.vercel.app
NEXT_PUBLIC_APP_NAME=LibX AI
```

### Run Database Migrations

1. In Vercel dashboard, go to "Deployments"
2. Find the latest deployment
3. Click the "..." menu → "Redeploy"
4. After successful deployment, run in terminal:

```bash
npx prisma migrate deploy
```

### Redeploy

1. Redeploy the project in Vercel dashboard
2. Wait for deployment to complete
3. Visit your deployed URL

## Step 4: Google OAuth Setup (Optional)

### Create Google OAuth Credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create new project
3. Go to "Credentials"
4. Click "Create Credentials" → "OAuth 2.0 Client IDs"
5. Select "Web application"
6. Add authorized redirect URIs:
   - `http://localhost:3000/api/auth/callback/google` (development)
   - `https://your-domain.vercel.app/api/auth/callback/google` (production)
7. Copy Client ID and Client Secret
8. Add to Vercel environment variables

## Step 5: Custom Domain (Optional)

1. In Vercel project settings
2. Go to "Domains"
3. Click "Add"
4. Enter your domain name
5. Follow DNS configuration instructions
6. Point domain to Vercel nameservers
7. Wait for DNS propagation (can take up to 48 hours)

## Step 6: Monitoring & Maintenance

### Monitor Performance

1. In Vercel dashboard, check "Analytics"
2. Monitor function execution time
3. Check error rates

### Database Maintenance

```bash
# View database in Prisma Studio
npx prisma studio

# Run migrations
npx prisma migrate deploy

# Check database status
npx prisma db seed
```

### Update Environment Variables

When you need to update secrets or keys:

1. Go to Vercel project settings
2. Click "Environment Variables"
3. Update the value
4. Redeploy the project

### Backup Database

Neon provides automated backups. To download:

1. In Neon dashboard
2. Go to project settings
3. Check "Backups" section
4. Download as needed

## Troubleshooting Deployment

### Issue: Build Fails

**Check logs**:
1. Go to Vercel Deployments
2. Click failed deployment
3. Check "Build Logs" tab
4. Look for errors

**Common solutions**:
- Run `npm install` locally
- Check for TypeScript errors
- Verify all imports are correct

### Issue: Database Connection Error

**Solutions**:
```bash
# Verify connection string
echo $DATABASE_URL

# Test connection locally
npx prisma db push

# Check Neon status at neon.tech/status
```

### Issue: Authentication Not Working

**Check**:
1. NEXTAUTH_URL matches deployment domain
2. NEXTAUTH_SECRET is set and same as local
3. Cookie settings are correct
4. Try incognito mode (cookie issue)

### Issue: OpenAI API Errors

**Verify**:
1. API key is valid
2. API key has sufficient credits
3. Rate limits not exceeded
4. Model name is correct (gpt-3.5-turbo)

## Performance Optimization

### Enable Caching

Add to `next.config.js`:

```javascript
const nextConfig = {
  // ... existing config
  onDemandEntries: {
    maxInactiveAge: 60 * 1000,
    pagesBufferLength: 5,
  },
}
```

### Monitor Build Size

```bash
# Analyze bundle size
npm run build -- --analyze
```

### Database Query Optimization

Use Prisma's query logging:

```typescript
const prisma = new PrismaClient({
  log: ['query', 'error', 'warn'],
})
```

## Security Checklist

- [ ] NEXTAUTH_SECRET is strong (32+ characters)
- [ ] All environment variables are set
- [ ] NEXTAUTH_URL matches production domain
- [ ] Google OAuth URIs are correctly configured
- [ ] Database password is strong
- [ ] API keys are restricted to your domain
- [ ] HTTPS is enabled
- [ ] No secrets in code/repository

## Cost Estimation

### Vercel
- Free tier: Perfect for small projects
- Pro: $20/month for professional features
- Usage pricing: Pay-as-you-go for excessive resources

### Neon PostgreSQL
- Free tier: 3 GB storage, perfect for testing
- Pro: $75+ per month for production workloads
- Usage: Storage and compute based

### OpenAI API
- Pay-as-you-go based on tokens used
- GPT-3.5: ~$0.0015 per 1K tokens
- Set up usage alerts in OpenAI dashboard

## Maintenance Schedule

**Weekly**:
- Monitor Vercel analytics
- Check error rates

**Monthly**:
- Review database size
- Update dependencies
- Check OpenAI usage

**Quarterly**:
- Security audit
- Performance review
- Backup verification

## Rollback Plan

If deployment has issues:

1. Go to Vercel Deployments
2. Click on previous working deployment
3. Click "..." → "Promote to Production"
4. Verify application works
5. Check logs for the failed deployment

## Support

For deployment issues:
- Check Vercel documentation
- Review Neon documentation
- Check OpenAI API status
- Search GitHub issues

---

**Happy Deploying! 🚀**
