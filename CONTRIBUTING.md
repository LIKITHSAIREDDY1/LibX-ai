# CONTRIBUTING.md

Contribution Guidelines

## Code of Conduct

- Be respectful and inclusive
- No harassment or discrimination
- Report issues privately if needed

## How to Contribute

### 1. Fork and Clone

```bash
git clone https://github.com/YOUR_USERNAME/libx-ai.git
cd libx-ai
```

### 2. Create Feature Branch

```bash
git checkout -b feature/your-feature-name
```

### 3. Make Changes

- Follow the existing code style
- Add comments for complex logic
- Update tests if applicable

### 4. Commit with Clear Messages

```bash
git commit -m "feat(component): add new feature"
```

### 5. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a PR on GitHub with:
- Clear title
- Description of changes
- Related issue numbers
- Screenshots if UI changes

## Pull Request Process

1. Ensure tests pass: `npm test`
2. Follow code style: `npm run lint`
3. Update documentation if needed
4. Link related issues
5. Request review from maintainers

## Code Style

### TypeScript/React

```typescript
// Use 'const' for components
export const MyComponent: React.FC<Props> = ({ prop }) => {
  return <div>{prop}</div>
}

// Use proper type annotations
interface Props {
  name: string
  age?: number
}

// Use arrow functions
const handleClick = () => {
  // ...
}
```

### Naming

- Components: PascalCase (`UserProfile`)
- Functions: camelCase (`getUserData`)
- Constants: UPPER_SNAKE_CASE (`MAX_RETRIES`)
- Files: Same as exports or index

## Testing

Add tests for new features:

```typescript
describe('NewComponent', () => {
  it('should render correctly', () => {
    // Test implementation
  })
})
```

Run tests: `npm test`

## Documentation

- Update README if adding features
- Add JSDoc comments to functions
- Include examples for new APIs
- Update CHANGELOG.md

## Areas to Contribute

- [ ] Features
  - Voice input
  - Image uploads
  - Conversation sharing

- [ ] Bug Fixes
  - UI improvements
  - Performance optimization
  - Error handling

- [ ] Documentation
  - API docs
  - Setup guides
  - Code examples

- [ ] Tests
  - Unit tests
  - Integration tests
  - E2E tests

## Getting Help

- Read documentation in `/docs`
- Check existing issues and discussions
- Ask in PR comments
- Join community discussions

## License

By contributing, you agree your work is licensed under MIT License.

---

Thank you for contributing! 🙌
