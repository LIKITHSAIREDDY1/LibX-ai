# API Documentation

Complete API reference for LibX AI backend.

## Base URL

```
Development: http://localhost:3000/api
Production: https://your-domain.vercel.app/api
```

## Authentication

All protected endpoints require an authenticated session via NextAuth.js. Include credentials in requests:

```javascript
fetch('/api/endpoint', {
  credentials: 'include', // Send cookies
})
```

## Response Format

### Success Response
```json
{
  "data": {},
  "status": "success",
  "code": 200
}
```

### Error Response
```json
{
  "error": "Error message",
  "details": {}
}
```

## Endpoints

### Authentication

#### Register User
**POST** `/auth/register`

Create a new user account.

**Request Body**:
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "SecurePass123",
  "confirmPassword": "SecurePass123"
}
```

**Response** (201 Created):
```json
{
  "message": "User created successfully",
  "user": {
    "id": "clx123...",
    "email": "john@example.com",
    "name": "John Doe"
  }
}
```

**Status Codes**:
- `201`: User created successfully
- `400`: Invalid input
- `409`: User already exists

---

#### Login
**POST** `/auth/[...nextauth]`

Login endpoint handled by NextAuth.js. Use `signIn()` from `next-auth/react`.

```javascript
import { signIn } from 'next-auth/react'

await signIn('credentials', {
  email: 'user@example.com',
  password: 'password',
  redirect: true,
  callbackUrl: '/dashboard',
})
```

---

### Conversations

#### Get All Conversations
**GET** `/conversations`

Retrieve all conversations for the authenticated user.

**Response** (200 OK):
```json
[
  {
    "id": "clx123...",
    "userId": "clx456...",
    "title": "My First Chat",
    "createdAt": "2024-01-01T12:00:00Z",
    "updatedAt": "2024-01-02T15:30:00Z",
    "messages": [
      { "id": "msg1" },
      { "id": "msg2" }
    ]
  }
]
```

**Query Parameters**: None

**Status Codes**:
- `200`: Success
- `401`: Unauthorized

---

#### Create Conversation
**POST** `/conversations`

Create a new conversation.

**Request Body**:
```json
{
  "title": "Chat about AI"
}
```

**Response** (201 Created):
```json
{
  "id": "clx789...",
  "userId": "clx456...",
  "title": "Chat about AI",
  "createdAt": "2024-01-03T10:00:00Z",
  "updatedAt": "2024-01-03T10:00:00Z"
}
```

**Validation**:
- `title`: 1-200 characters

**Status Codes**:
- `201`: Conversation created
- `400`: Invalid input
- `401`: Unauthorized

---

#### Get Conversation
**GET** `/conversations/[id]`

Retrieve a specific conversation with all messages.

**Response** (200 OK):
```json
{
  "id": "clx789...",
  "userId": "clx456...",
  "title": "Chat about AI",
  "createdAt": "2024-01-03T10:00:00Z",
  "updatedAt": "2024-01-03T10:00:00Z",
  "messages": [
    {
      "id": "msg1",
      "conversationId": "clx789...",
      "content": "What is AI?",
      "role": "user",
      "createdAt": "2024-01-03T10:05:00Z"
    },
    {
      "id": "msg2",
      "conversationId": "clx789...",
      "content": "AI stands for Artificial Intelligence...",
      "role": "assistant",
      "createdAt": "2024-01-03T10:06:00Z"
    }
  ]
}
```

**Status Codes**:
- `200`: Success
- `401`: Unauthorized
- `404`: Conversation not found

---

#### Update Conversation
**PUT** `/conversations/[id]`

Rename a conversation.

**Request Body**:
```json
{
  "title": "New Chat Title"
}
```

**Response** (200 OK):
```json
{
  "success": true
}
```

**Validation**:
- `title`: Required, 1-200 characters

**Status Codes**:
- `200`: Updated successfully
- `400`: Invalid input
- `401`: Unauthorized
- `404`: Conversation not found

---

#### Delete Conversation
**DELETE** `/conversations/[id]`

Delete a conversation and all its messages.

**Response** (200 OK):
```json
{
  "success": true
}
```

**Status Codes**:
- `200`: Deleted successfully
- `401`: Unauthorized
- `404`: Conversation not found

---

### Messages

#### Send Message
**POST** `/messages`

Send a message and get an AI response. **Streaming response**.

**Request Body**:
```json
{
  "content": "What is machine learning?",
  "conversationId": "clx789..."
}
```

**Response** (Streaming):

Server-Sent Events (SSE) format:

```
data: {"content":"Machine"}

data: {"content":" learning"}

data: {"content":" is..."}

data: {"done":true}
```

**JavaScript Example**:
```javascript
const response = await fetch('/api/messages', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    content: 'Your message',
    conversationId: 'conv-id',
  }),
})

const reader = response.body.getReader()
const decoder = new TextDecoder()

while (true) {
  const { done, value } = await reader.read()
  if (done) break

  const chunk = decoder.decode(value)
  const lines = chunk.split('\n')
  
  for (const line of lines) {
    if (line.startsWith('data: ')) {
      const data = JSON.parse(line.slice(6))
      console.log(data)
    }
  }
}
```

**Validation**:
- `content`: 1-5000 characters
- `conversationId`: Must exist and belong to user

**Status Codes**:
- `200`: Success (SSE stream)
- `400`: Invalid input
- `401`: Unauthorized
- `404`: Conversation not found
- `500`: API error

---

## Error Handling

### Common Error Responses

#### 400 Bad Request
```json
{
  "error": "Invalid input",
  "details": {
    "email": ["Invalid email address"],
    "password": ["Password must be at least 8 characters"]
  }
}
```

#### 401 Unauthorized
```json
{
  "error": "Unauthorized"
}
```

#### 404 Not Found
```json
{
  "error": "Conversation not found"
}
```

#### 409 Conflict
```json
{
  "error": "User with this email already exists"
}
```

#### 500 Internal Server Error
```json
{
  "error": "Failed to process request"
}
```

---

## Rate Limiting

Current implementation:
- No rate limiting (implement in production)

**Recommended Production Setup**:
```javascript
// Implement middleware like express-rate-limit
// 100 requests per 15 minutes per IP
```

---

## Example Usage

### Complete Chat Flow

```javascript
// 1. Register user
const registerRes = await fetch('/api/auth/register', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    name: 'John Doe',
    email: 'john@example.com',
    password: 'SecurePass123',
    confirmPassword: 'SecurePass123',
  }),
})

// 2. Login
const loginRes = await fetch('/api/auth/[...nextauth]', {
  method: 'POST',
  credentials: 'include',
  // Handled by NextAuth
})

// 3. Create conversation
const convRes = await fetch('/api/conversations', {
  method: 'POST',
  credentials: 'include',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ title: 'My Chat' }),
})
const { id } = await convRes.json()

// 4. Send message
const msgRes = await fetch('/api/messages', {
  method: 'POST',
  credentials: 'include',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    content: 'Hello AI!',
    conversationId: id,
  }),
})

// 5. Read streaming response
const reader = msgRes.body.getReader()
const decoder = new TextDecoder()
while (true) {
  const { done, value } = await reader.read()
  if (done) break
  const text = decoder.decode(value)
  console.log(text)
}

// 6. Retrieve conversation with messages
const finalRes = await fetch(`/api/conversations/${id}`, {
  credentials: 'include',
})
const conversation = await finalRes.json()
console.log(conversation.messages)
```

---

## Webhooks (Future Enhancement)

Planned webhooks for production:
- `message.created`: When new message is sent
- `conversation.created`: When new conversation is created
- `conversation.deleted`: When conversation is deleted

---

## Version History

### v1.0.0 (Current)
- User authentication (email/password, Google OAuth)
- Conversation CRUD operations
- Message sending with streaming responses
- User session management

### v2.0.0 (Planned)
- Webhooks support
- Rate limiting
- Message search
- Conversation sharing
- API key authentication

---

## Support

For API issues:
1. Check error response for details
2. Verify NEXTAUTH_SECRET and NEXTAUTH_URL
3. Ensure OpenAI API key is valid
4. Check request format matches documentation
5. Review server logs for details

---

**API Documentation v1.0 - Last Updated: 2024**
