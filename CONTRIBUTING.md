# Contributing to FinWatch

Thank you for your interest in contributing to FinWatch! This document provides guidelines and information for contributors.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.24.5 or higher
- Dart 3.0 or higher
- Android Studio / VS Code with Flutter extensions
- Git for version control

### Development Setup
1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/FinWatch.git`
3. Run the setup script: `chmod +x scripts/setup.sh && ./scripts/setup.sh`
4. Create a new branch: `git checkout -b feature/your-feature-name`

## 📝 Code Style

### Dart/Flutter Guidelines
- Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` to format your code
- Run `dart analyze` to check for issues
- Maintain 80-character line length where possible

### Architecture
- Follow Clean Architecture principles
- Use Riverpod for state management
- Implement proper error handling with AsyncValue
- Write type-safe code with proper null safety

### File Organization
```
lib/
├── core/           # Core functionality (config, theme, services)
├── features/       # Feature modules (auth, dashboard, etc.)
├── shared/         # Shared widgets and utilities
└── main.dart       # App entry point
```

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Writing Tests
- Write unit tests for business logic
- Write widget tests for UI components
- Write integration tests for user flows
- Aim for 80%+ code coverage

## 🔧 Pull Request Process

### Before Submitting
1. Ensure all tests pass
2. Run `dart analyze` and fix any issues
3. Format code with `dart format`
4. Update documentation if needed
5. Add/update tests for new features

### PR Guidelines
- Use descriptive titles and descriptions
- Reference related issues with `Fixes #123`
- Keep PRs focused and atomic
- Include screenshots for UI changes
- Update CHANGELOG.md for significant changes

### Review Process
1. Automated checks must pass
2. Code review by maintainers
3. Address feedback and update PR
4. Merge after approval

## 🐛 Bug Reports

### Before Reporting
- Check existing issues for duplicates
- Test on the latest version
- Gather relevant information

### Bug Report Template
```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. See error

**Expected behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Environment:**
- Device: [e.g. iPhone 12, Pixel 5]
- OS: [e.g. iOS 15.0, Android 12]
- App Version: [e.g. 1.0.0]
```

## 💡 Feature Requests

### Before Requesting
- Check existing issues and discussions
- Consider if it fits the app's scope
- Think about implementation complexity

### Feature Request Template
```markdown
**Is your feature request related to a problem?**
A clear description of what the problem is.

**Describe the solution you'd like**
A clear description of what you want to happen.

**Describe alternatives you've considered**
Other solutions you've considered.

**Additional context**
Any other context or screenshots.
```

## 🏗️ Development Guidelines

### Adding New Features
1. Create feature branch from main
2. Implement feature with tests
3. Update documentation
4. Submit PR with detailed description

### Database Changes
- Use Hive for local storage
- Implement proper migration strategies
- Test data persistence scenarios

### UI/UX Changes
- Follow Material 3 design guidelines
- Ensure accessibility compliance
- Test on different screen sizes
- Maintain consistent theming

### API Integration
- Use proper error handling
- Implement offline support
- Add loading states
- Cache responses when appropriate

## 📚 Documentation

### Code Documentation
- Document public APIs with dartdoc comments
- Include usage examples
- Explain complex algorithms
- Keep comments up to date

### User Documentation
- Update README for new features
- Add setup instructions
- Include troubleshooting guides
- Provide usage examples

## 🔒 Security

### Reporting Security Issues
- Email security issues to: security@finwatch.app
- Do not create public issues for security vulnerabilities
- Provide detailed reproduction steps
- Allow time for fixes before disclosure

### Security Guidelines
- Never commit sensitive data
- Use secure storage for credentials
- Validate all user inputs
- Follow OWASP mobile security guidelines

## 📞 Community

### Getting Help
- GitHub Discussions for questions
- GitHub Issues for bugs and features
- Discord server for real-time chat
- Stack Overflow with `finwatch` tag

### Code of Conduct
- Be respectful and inclusive
- Help others learn and grow
- Provide constructive feedback
- Follow community guidelines

## 📄 License

By contributing to FinWatch, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to FinWatch! 🎉