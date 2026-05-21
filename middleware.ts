import { withAuth } from 'next-auth/middleware'
import { NextRequest } from 'next/server'

/**
 * Middleware for protecting routes
 * Redirects unauthenticated users to login page
 */
export const middleware = withAuth(
  function middleware(req: NextRequest) {
    // Custom middleware logic can be added here
  },
  {
    callbacks: {
      authorized({ req, token }) {
        // Allow access if authenticated
        if (token) return true

        // Allow public routes
        if (req.nextUrl.pathname.startsWith('/auth/')) return true
        if (req.nextUrl.pathname === '/') return true

        // Deny access to protected routes
        return false
      },
    },
  }
)

/**
 * Configure which routes use the middleware
 */
export const config = {
  matcher: [
    '/dashboard/:path*',
    '/api/conversations/:path*',
    '/api/messages/:path*',
  ],
}
