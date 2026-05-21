# Windows Setup Script
# Run with: .\setup.ps1

Write-Host "🚀 LibX AI Setup Script" -ForegroundColor Green
Write-Host "======================="

# Check Node.js version
$nodeVersion = node -v
Write-Host "✓ Node.js version: $nodeVersion" -ForegroundColor Green

# Install dependencies
Write-Host ""
Write-Host "📦 Installing dependencies..." -ForegroundColor Cyan
npm install

# Create .env.local if it doesn't exist
if (-not (Test-Path ".env.local")) {
    Write-Host ""
    Write-Host "📝 Creating .env.local..." -ForegroundColor Cyan
    Copy-Item ".env.example" ".env.local"
    Write-Host "⚠️  Please update .env.local with your configuration" -ForegroundColor Yellow
}

# Generate Prisma Client
Write-Host ""
Write-Host "🔧 Setting up Prisma..." -ForegroundColor Cyan
npm run prisma:generate

# Generate NEXTAUTH_SECRET
Write-Host ""
Write-Host "🔐 Generating NEXTAUTH_SECRET..." -ForegroundColor Cyan
$bytes = [System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32)
$secret = [Convert]::ToBase64String($bytes)
(Get-Content ".env.local") -replace 'NEXTAUTH_SECRET=.*', "NEXTAUTH_SECRET=`"$secret`"" | Set-Content ".env.local"

Write-Host ""
Write-Host "✅ Setup Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📚 Next steps:" -ForegroundColor Yellow
Write-Host "1. Update .env.local with your API keys:"
Write-Host "   - OPENAI_API_KEY"
Write-Host "   - GOOGLE_CLIENT_ID (optional)"
Write-Host "   - GOOGLE_CLIENT_SECRET (optional)"
Write-Host ""
Write-Host "2. Set up PostgreSQL database:"
Write-Host "   - Install PostgreSQL or use Neon cloud database"
Write-Host "   - Update DATABASE_URL in .env.local"
Write-Host ""
Write-Host "3. Run database migrations:"
Write-Host "   npm run prisma:migrate"
Write-Host ""
Write-Host "4. Start development server:"
Write-Host "   npm run dev"
Write-Host ""
Write-Host "5. Open http://localhost:3000"
Write-Host ""
