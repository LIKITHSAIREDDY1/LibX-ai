#!/bin/bash

# LibX AI Setup Script
# This script sets up the development environment

set -e  # Exit on error

echo "🚀 LibX AI Setup Script"
echo "======================="

# Check Node.js version
NODE_VERSION=$(node -v)
echo "✓ Node.js version: $NODE_VERSION"

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
npm install

# Create .env.local if it doesn't exist
if [ ! -f .env.local ]; then
    echo ""
    echo "📝 Creating .env.local..."
    cp .env.example .env.local
    echo "⚠️  Please update .env.local with your configuration"
fi

# Generate Prisma Client
echo ""
echo "🔧 Setting up Prisma..."
npm run prisma:generate

# Prompt for database setup
echo ""
echo "🗄️  Database Setup"
echo "Choose an option:"
echo "1) Create local PostgreSQL database"
echo "2) Use Neon cloud database (skip)"
read -p "Enter choice (1-2): " db_choice

if [ "$db_choice" = "1" ]; then
    echo ""
    echo "📝 Creating local PostgreSQL database..."
    echo "Enter PostgreSQL password:"
    read -s PG_PASSWORD
    
    # Create database (this assumes PostgreSQL is installed)
    psql -U postgres -c "CREATE DATABASE libx_ai;" 2>/dev/null || echo "Database may already exist"
    
    # Update .env.local
    sed -i.bak "s|DATABASE_URL=.*|DATABASE_URL=\"postgresql://postgres:$PG_PASSWORD@localhost:5432/libx_ai\"|" .env.local
fi

# Generate NEXTAUTH_SECRET
echo ""
echo "🔐 Generating NEXTAUTH_SECRET..."
SECRET=$(openssl rand -base64 32)
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s|NEXTAUTH_SECRET=.*|NEXTAUTH_SECRET=\"$SECRET\"|" .env.local
else
    sed -i "s|NEXTAUTH_SECRET=.*|NEXTAUTH_SECRET=\"$SECRET\"|" .env.local
fi

# Run migrations
echo ""
echo "🔄 Running database migrations..."
npm run prisma:migrate

# Optional: Seed database
read -p "Do you want to seed the database with sample data? (y/n): " seed_choice
if [ "$seed_choice" = "y" ]; then
    npm run prisma:seed
fi

echo ""
echo "✅ Setup Complete!"
echo ""
echo "📚 Next steps:"
echo "1. Update .env.local with your API keys:"
echo "   - OPENAI_API_KEY"
echo "   - GOOGLE_CLIENT_ID (optional)"
echo "   - GOOGLE_CLIENT_SECRET (optional)"
echo ""
echo "2. Start development server:"
echo "   npm run dev"
echo ""
echo "3. Open http://localhost:3000"
echo ""
echo "📖 Documentation:"
echo "   - README.md - Project overview"
echo "   - INSTALLATION.md - Detailed setup guide"
echo "   - API.md - API documentation"
echo "   - DEPLOYMENT.md - Production deployment"
echo ""
