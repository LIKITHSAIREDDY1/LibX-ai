# LibX AI - Production-Ready AI Chatbot

A modern, full-stack AI chatbot web application built with Next.js 14, React, TypeScript, and powered by OpenAI API.

## 🌟 Features

- **AI-Powered Conversations**: Real-time chat with GPT models through OpenAI API
- **User Authentication**: Secure login with email/password and Google OAuth
- **Conversation History**: Save and manage multiple conversations
- **Streaming Responses**: Real-time streaming for smooth AI responses
- **Dark/Light Mode**: Full theme support with smooth transitions
- **Responsive Design**: Works seamlessly on desktop, tablet, and mobile
- **Markdown Support**: AI responses with markdown rendering and code highlighting
- **Production Ready**: Optimized for deployment on Vercel
- **Type-Safe**: Full TypeScript implementation
- **Modern UI**: Built with Tailwind CSS and custom components

## 📋 Tech Stack

### Frontend
- **Framework**: Next.js 14 (App Router)
- **UI Library**: React 18
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **Components**: Custom ShadCN-inspired UI components
- **State Management**: React Context + NextAuth.js
- **Form Handling**: React Hook Form + Zod

### Backend
- **API**: Next.js API Routes
- **Authentication**: NextAuth.js v4
- **Database ORM**: Prisma
- **Validation**: Zod

### Database
- **Database**: PostgreSQL
- **Hosting**: Neon (recommended)

### AI
- **Provider**: OpenAI API
- **Model**: GPT-3.5 Turbo

### Deployment
- **Hosting**: Vercel
- **Database**: Neon PostgreSQL

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ and npm/yarn
- PostgreSQL database
- OpenAI API key
- Google OAuth credentials (optional, for social login)

### 1. Clone and Install

```bash
git clone <repository-url>
cd libx-ai
npm install
```

### 2. Environment Setup

Create `.env.local`:

```env
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/libx_ai"

# NextAuth
NEXTAUTH_SECRET="your-secret-key-here-min-32-characters"
NEXTAUTH_URL="http://localhost:3000"

# Google OAuth (optional)
GOOGLE_CLIENT_ID="your-google-client-id"
GOOGLE_CLIENT_SECRET="your-google-client-secret"

# OpenAI API
OPENAI_API_KEY="your-openai-api-key"

# App Settings
NEXT_PUBLIC_APP_URL="http://localhost:3000"
NEXT_PUBLIC_APP_NAME="LibX AI"
```

### 3. Database Setup

```bash
# Generate Prisma client
npm run prisma:generate

# Run migrations
npm run prisma:migrate

# (Optional) Seed database
npm run prisma:seed
```

### 4. Development

```bash
npm run dev
```

Visit `http://localhost:3000`

### 5. Production Build

```bash
npm run build
npm start
```

## 📁 Project Structure

```
libx-ai/
├── src/
│   ├── app/
│   │   ├── api/                 # API routes
│   │   │   ├── auth/           # Authentication endpoints
│   │   │   ├── conversations/   # Conversation CRUD
│   │   │   └── messages/        # Message endpoints
│   │   ├── auth/                # Auth pages (login, register)
│   │   ├── dashboard/           # Protected dashboard
│   │   │   └── chat/           # Chat interface
│   │   ├── page.tsx            # Landing page
│   │   ├── layout.tsx          # Root layout
│   │   ├── globals.css         # Global styles
│   │   └── providers.tsx       # Context providers
│   ├── components/
│   │   ├── ui/                 # Reusable UI components
│   │   ├── chat/               # Chat-related components
│   │   └── auth/               # Auth components
│   ├── lib/
│   │   ├── auth/               # Auth utilities
│   │   ├── utils/              # Helper functions
│   │   ├── prisma.ts          # Prisma client
│   │   └── schemas.ts         # Zod schemas
│   ├── context/                # React Context
│   ├── hooks/                  # Custom hooks
│   └── styles/                 # Global styles
├── prisma/
│   ├── schema.prisma          # Database schema
│   └── seed.js                # Seed data
├── public/                     # Static files
├── package.json
├── tsconfig.json
├── next.config.js
├── tailwind.config.ts
└── .env.example

```

## 🗄️ Database Schema

### Users Table
- `id`: Unique identifier
- `email`: User email (unique)
- `name`: User name
- `password`: Hashed password (for credentials login)
- `emailVerified`: Email verification timestamp
- `image`: Profile image URL
- `createdAt`: Account creation time
- `updatedAt`: Last update time

### Conversations Table
- `id`: Unique identifier
- `userId`: Reference to user
- `title`: Conversation title
- `createdAt`: Creation timestamp
- `updatedAt`: Last update timestamp

### Messages Table
- `id`: Unique identifier
- `conversationId`: Reference to conversation
- `content`: Message content
- `role`: "user" or "assistant"
- `createdAt`: Message creation time

## 🔐 Authentication

### Features
- **Email/Password Login**: Secure credential-based authentication
- **Google OAuth**: One-click sign-in with Google
- **Session Management**: JWT-based sessions
- **Password Hashing**: bcryptjs for secure password storage
- **Protected Routes**: Authorization checks on all protected endpoints

### Security
- NEXTAUTH_SECRET for session encryption
- Zod validation for all inputs
- SQL injection prevention with Prisma ORM
- Password requirements: 8+ chars, uppercase, lowercase, numbers
- XSS protection with React built-in sanitization

## 💬 Chat Features

### Conversation Management
- Create new conversations
- View conversation history
- Rename conversations
- Delete conversations
- Auto-save conversations

### Message Features
- Send text messages
- Streaming AI responses
- Markdown rendering
- Code syntax highlighting
- Copy message functionality
- Message timestamps
- Auto-scroll to latest message

### AI Integration
- OpenAI GPT-3.5 Turbo
- Context-aware responses
- Streaming for real-time responses
- Error handling for API limits
- Automatic retry on failure

## 🎨 UI/UX

### Components
- Custom Button with variants
- Input with validation display
- Card components with sections
- Textarea with auto-resize
- Toast notifications
- Loading skeletons
- Markdown renderer
- Code highlighter

### Features
- Dark/Light mode toggle
- Smooth animations
- Responsive design
- Loading states
- Error handling
- Empty states
- Sidebar navigation
- Mobile menu

## 📱 Responsive Design

- **Desktop**: Full sidebar + chat area
- **Tablet**: Collapsible sidebar
- **Mobile**: Mobile menu with hamburger
- All components tested on various screen sizes

## 🚀 Deployment

### Deploy to Vercel

1. **Push to GitHub**
   ```bash
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```

2. **Connect to Vercel**
   - Go to [vercel.com](https://vercel.com)
   - Import your GitHub repository
   - Select the project

3. **Configure Environment Variables**
   - Add all variables from `.env.example`
   - Set `NEXTAUTH_URL` to your Vercel domain

4. **Database Setup**
   - Create PostgreSQL on [Neon](https://neon.tech)
   - Add `DATABASE_URL` to environment variables
   - Run migrations: `npx prisma migrate deploy`

5. **Deploy**
   - Click "Deploy"
   - Monitor deployment logs

### Post-Deployment

```bash
# Run migrations on production
npx prisma migrate deploy

# Seed production database (optional)
npx prisma db seed
```

## 🔑 API Endpoints

### Authentication
- `POST /api/auth/register` - Create new account
- `POST /api/auth/[...nextauth]` - NextAuth endpoints

### Conversations
- `GET /api/conversations` - Get all conversations
- `POST /api/conversations` - Create new conversation
- `GET /api/conversations/[id]` - Get specific conversation
- `PUT /api/conversations/[id]` - Rename conversation
- `DELETE /api/conversations/[id]` - Delete conversation

### Messages
- `POST /api/messages` - Send message and get AI response

## 📊 Performance Optimization

- **Image Optimization**: Next.js Image component
- **Code Splitting**: Automatic with App Router
- **Caching**: Server-side and client-side caching
- **Database**: Prisma with connection pooling
- **Streaming**: Server Streaming for real-time responses
- **Bundle Size**: Optimized dependencies

## 🛡️ Security Best Practices

1. **Environment Variables**: Never commit `.env` files
2. **SQL Injection**: Prisma ORM prevents SQL injection
3. **XSS Protection**: React sanitization
4. **CSRF Protection**: Built-in with NextAuth
5. **Password Security**: Bcryptjs hashing + validation
6. **API Rate Limiting**: Implement middleware for production
7. **HTTPS**: Required for production
8. **CORS**: Configured appropriately

## 🐛 Common Issues & Solutions

### Issue: "Cannot find module"
**Solution**: Run `npm install` and verify all dependencies

### Issue: Database connection failed
**Solution**: Check `DATABASE_URL` in `.env.local`

### Issue: OpenAI API errors
**Solution**: 
- Verify `OPENAI_API_KEY` is correct
- Check API key has sufficient credits
- Review OpenAI dashboard for usage limits

### Issue: NextAuth authentication not working
**Solution**:
- Ensure `NEXTAUTH_SECRET` is set (min 32 characters)
- Check `NEXTAUTH_URL` matches your domain
- Clear browser cookies and try again

### Issue: Prisma migration errors
**Solution**:
```bash
# Reset database (development only)
npm run prisma:push -- --force-reset

# Or manually:
npx prisma db push
```

## 🚀 Future Enhancements

1. **Features**
   - Voice input/output
   - Image uploads and analysis
   - Conversation sharing
   - Search within conversations
   - Custom AI parameters
   - Conversation folders/organization

2. **Technical**
   - Rate limiting middleware
   - User analytics
   - Caching layer (Redis)
   - WebSocket for real-time updates
   - Mobile app (React Native)
   - API documentation (Swagger)

3. **Performance**
   - Implement ISR for landing page
   - Database indexing optimization
   - CDN for static assets
   - Service workers for offline support

4. **Monetization**
   - Subscription plans
   - Usage-based pricing
   - Premium features

## 📚 Additional Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [NextAuth.js Documentation](https://next-auth.js.org)
- [Prisma Documentation](https://www.prisma.io/docs)
- [OpenAI API Documentation](https://platform.openai.com/docs)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)

## 📝 License

MIT License - feel free to use this project for personal or commercial purposes.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 💡 Tips

- **Development**: Use `npm run dev` for hot reload
- **Database**: Use `npm run prisma:studio` to view data
- **Type Safety**: Always use TypeScript for new code
- **Components**: Keep components small and reusable
- **Testing**: Add tests before deployment
- **Performance**: Monitor Vercel Analytics

## 📞 Support

For issues and questions:
1. Check the FAQ section above
2. Review the GitHub issues
3. Create a new issue with detailed information

---

**Happy Coding! 🚀**
