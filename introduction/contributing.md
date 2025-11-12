# Contributing

We welcome contributions to the JWT Framework! Whether you're fixing bugs, adding features, improving documentation, or helping others, your contributions make this project better for everyone.

## Ways to Contribute

### 🐛 Report Bugs
Found a bug? Please [open an issue](https://github.com/web-token/jwt-framework/issues) with:
- A clear description of the problem
- Steps to reproduce the issue
- Expected vs actual behavior
- Your PHP version and framework version
- Any relevant code snippets or error messages

### ✨ Suggest Features
Have an idea for a new feature? We'd love to hear it! Please:
- Check existing issues to avoid duplicates
- Describe the use case and benefits
- Propose how it might work
- Consider backward compatibility

### 💻 Submit Code

If you feel comfortable writing code, you can:
- Fix [issues where help is wanted](https://github.com/web-token/jwt-framework/labels/help+wanted)
- Tackle [easy issues](https://github.com/web-token/jwt-framework/labels/easy-pick) to get started
- Implement accepted feature requests
- Improve test coverage

**Before submitting a pull request**, please:
1. Read the [contributing guidelines](https://github.com/web-token/jwt-framework/tree/master/.github/CONTRIBUTING.md)
2. Ensure your code follows PSR-12 coding standards
3. Add or update tests for your changes
4. Update documentation if needed
5. Make sure all tests pass

### 📚 Improve Documentation

Documentation is crucial! You can help by:
- Fixing typos and grammar
- Adding code examples
- Clarifying confusing sections
- Translating documentation
- Writing tutorials or guides

### 💬 Help Others

- Answer questions on GitHub Discussions
- Help triage issues
- Review pull requests
- Share your experience using the framework

## Development Setup

```bash
# Clone the repository
git clone https://github.com/web-token/jwt-framework.git
cd jwt-framework

# Install dependencies
composer install

# Run tests
composer test

# Check coding standards
composer cs-check

# Fix coding standards
composer cs-fix
```

## Code Guidelines

- Follow **PSR-12** coding standards
- Write **comprehensive tests** for new features
- Keep **backward compatibility** in mind
- Add **type hints** wherever possible
- Write **clear commit messages**
- Keep pull requests **focused** and **small**

## Testing

All contributions must include tests:
- Unit tests for new functionality
- Integration tests for complex features
- Test edge cases and error conditions
- Ensure RFC compliance for cryptographic operations

Run the test suite:
```bash
vendor/bin/phpunit
```

## Security Issues

{% hint style="danger" %}
**If you discover a security vulnerability, DO NOT open a public issue.**

Please report security issues privately through [GitHub Security Advisories](https://github.com/web-token/jwt-framework/security/advisories).
{% endhint %}

Security vulnerabilities will be addressed with the highest priority. We appreciate responsible disclosure and will acknowledge your contribution.

## Code of Conduct

This project adheres to a Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

## Questions?

If you have questions about contributing:
- Check the [documentation](https://web-token.spomky-labs.com)
- Open a [GitHub Discussion](https://github.com/web-token/jwt-framework/discussions)
- Reach out to the maintainers

## Recognition

Contributors are recognized in:
- The project's contributor list
- Release notes for significant contributions
- The `CHANGELOG.md` file

Thank you for helping make JWT Framework better! 🙏
