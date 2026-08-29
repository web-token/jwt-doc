# The Framework

The JWT Framework is a comprehensive and modular PHP library for working with JSON Web Tokens. It provides a complete implementation of the JOSE (JSON Object Signing and Encryption) specifications, designed to be both powerful and easy to use.

## Architecture

The framework follows a clean, modular architecture that allows you to use only what you need. The codebase is organized into a core library, a Symfony bundle and a few optional packages:

### Core Library (`web-token/jwt-library`)

The core library contains all the essential components for working with JWTs:

**Foundation Components:**
- **Algorithm Management** - Register and manage signature and encryption algorithms
- **Key Management (JWK/JWKSet)** - Create, load, and manage cryptographic keys
- **JWT Core** - Base interfaces and utilities

**Token Operations:**
- **JWS (Signed Tokens)** - Create and verify digitally signed tokens
- **JWE (Encrypted Tokens)** - Create and decrypt encrypted tokens
- **Nested Tokens** - Support for tokens that are both signed and encrypted

**Validation Framework:**
- **Header Checkers** - Validate token header parameters
- **Claim Checkers** - Validate token payload claims
- **Time-based Validation** - Support for expiration, not-before, and issued-at checks

**Serialization:**
- **Compact Serialization** - URL-safe format for web contexts
- **JSON Flattened** - Single signature/recipient in JSON format
- **JSON General** - Multiple signatures/recipients in JSON format

**CLI Tools:**
- Key generation and management commands
- Token inspection and validation tools
- Key conversion utilities

Every service — builders, verifiers, decrypters, loaders and checker managers — is described by an interface (`JWSBuilderInterface`, `JWELoaderInterface`, `HeaderCheckerManagerInterface`…). Type-hint the interface rather than the concrete class: it is what the library itself expects internally, so a decorator can be injected anywhere a service is used.

### Symfony Bundle (`web-token/jwt-bundle`)

The Symfony bundle provides seamless integration with Symfony applications:

- **Dependency Injection** - Auto-configuration of services
- **Configuration Management** - YAML-based configuration for algorithms, keys, and checkers
- **Factory Services** - Pre-configured factories for creating builders, loaders, and validators
- **Debug Tools** - Symfony profiler integration and data collectors
- **Events** - Token lifecycle events for logging and monitoring
- **Controller Helpers** - Utilities for common token operations

### Dangerous Algorithms (`web-token/jwt-unsecured`, `web-token/jwt-rsa15`)

Two standard but dangerous algorithms are shipped separately since 4.3, so that enabling them is an explicit and auditable decision rather than a one-line change:

* **`web-token/jwt-unsecured`** — the `none` signature algorithm (`Jose\Unsecured\Signature\None`), which disables signature verification altogether.
* **`web-token/jwt-rsa15`** — the `RSA1_5` key encryption algorithm (`Jose\Rsa15\KeyEncryption\RSA15`), whose padding is vulnerable to the Bleichenbacher adaptive chosen-ciphertext attack.

They are deliberately not part of `web-token/jwt-experimental`: both are perfectly standard, and an application asking for `Blake2b` should not get `none` in the bargain.

### Experimental Features (`web-token/jwt-experimental`)

The experimental package contains cutting-edge features and algorithms:

- **Experimental Algorithms** - Newer cryptographic algorithms (Blake2b, ES256K, etc.)
- **Performance Optimizations** - Advanced implementations for specific use cases
- **Compatibility Algorithms** - Support for legacy systems (RS1, HS1, HS256/64)
- **Specialized Encryption** - AES-CCM variants and ChaCha20-Poly1305

{% hint style="warning" %}
Experimental features should be used with caution in production environments. They may change between minor versions and are primarily intended for testing, compatibility, or research purposes.
{% endhint %}

## Design Principles

The framework is built on several key principles:

### 1. **Security First**
- Follows RFC specifications strictly
- Implements security best practices by default
- Provides clear warnings about weak or deprecated algorithms
- Mandatory validation steps prevent common vulnerabilities

### 2. **Flexibility**
- Modular design - use only what you need
- Support for multiple algorithms and serialization formats
- Extensible - create custom algorithms, checkers, and serializers
- Framework-agnostic core with optional Symfony integration

### 3. **Developer Experience**
- Fluent, intuitive APIs
- Comprehensive error messages
- Extensive documentation with examples
- Type-safe code with full PHP type hints
- One exception hierarchy: everything the library throws implements `Jose\Component\Core\Exception\JoseException`, and the cause of a failure is chained as the previous exception
- Readonly result objects instead of by-reference output parameters

### 4. **Performance**
- Lazy loading of algorithms and services
- Efficient serialization/deserialization
- Optional GMP/BCMath for faster cryptographic operations
- Caching support for remote key sets

## Package Selection Guide

Choose the right package for your needs:

| Package | Use When |
|---------|----------|
| `web-token/jwt-library` | **Standalone** - You need the core library without Symfony integration |
| `web-token/jwt-bundle` | **Symfony** - You're building a Symfony application (includes the library) |
| `web-token/jwt-experimental` | **Advanced** - You need experimental algorithms or features |
| `web-token/jwt-unsecured` | **Only if you need `none`** - Read [Security Recommendations](security-recommendations.md#avoid-weak-algorithms) first |
| `web-token/jwt-rsa15` | **Only if you need `RSA1_5`** - Read [Security Recommendations](security-recommendations.md#avoid-weak-algorithms) first |

{% hint style="info" %}
You may come across `web-token/jwt-framework` in older instructions. It is the root package of the monorepo and `replace`s the packages above, so requiring it installs everything at once — including the experimental and the dangerous algorithms. Prefer `web-token/jwt-library` or `web-token/jwt-bundle` so your dependencies only contain what you actually use.
{% endhint %}

## Installation

### For any PHP project:
```bash
composer require web-token/jwt-library
```

### For Symfony projects:
```bash
composer require web-token/jwt-bundle
```

The Symfony bundle will be automatically registered.

### Adding experimental features:
```bash
composer require web-token/jwt-experimental
```

### Adding the `none` or `RSA1_5` algorithm:
```bash
composer require web-token/jwt-unsecured  # the "none" algorithm
composer require web-token/jwt-rsa15      # the "RSA1_5" algorithm
```

Install these only if you really need those algorithms.

## Next Steps

- **New to JWT?** Start with [Provided Features](provided-features.md) to see what's available
- **Security conscious?** Read [Security Recommendations](security-recommendations.md) carefully
- **Ready to code?** Jump to [The Components](../the-components/algorithm-management-jwa.md) for detailed usage guides
- **Using Symfony?** Check out [The Symfony Bundle](../the-symfony-bundle/symfony-bundle.md) section
