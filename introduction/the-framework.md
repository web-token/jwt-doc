# The Framework

The JWT Framework is a comprehensive and modular PHP library for working with JSON Web Tokens. It provides a complete implementation of the JOSE (JSON Object Signing and Encryption) specifications, designed to be both powerful and easy to use.

## Architecture

The framework follows a clean, modular architecture that allows you to use only what you need. The codebase is organized into three main packages:

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

### Symfony Bundle (`web-token/jwt-bundle`)

The Symfony bundle provides seamless integration with Symfony applications:

- **Dependency Injection** - Auto-configuration of services
- **Configuration Management** - YAML-based configuration for algorithms, keys, and checkers
- **Factory Services** - Pre-configured factories for creating builders, loaders, and validators
- **Debug Tools** - Symfony profiler integration and data collectors
- **Events** - Token lifecycle events for logging and monitoring
- **Controller Helpers** - Utilities for common token operations

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

### 4. **Performance**
- Lazy loading of algorithms and services
- Efficient serialization/deserialization
- Optional GMP/BCMath for faster cryptographic operations
- Caching support for remote key sets

## Package Selection Guide

Choose the right package for your needs:

| Package | Use When |
|---------|----------|
| `web-token/jwt-framework` | **All-in-one** - You want everything (library + bundle + experimental) |
| `web-token/jwt-library` | **Standalone** - You need the core library without Symfony integration |
| `web-token/jwt-bundle` | **Symfony** - You're building a Symfony application (includes the library) |
| `web-token/jwt-experimental` | **Advanced** - You need experimental algorithms or features |

## Installation

### For any PHP project:
```bash
composer require web-token/jwt-library
```

### For Symfony projects:
```bash
composer require web-token/jwt-framework
```

The Symfony bundle will be automatically registered.

### Adding experimental features:
```bash
composer require web-token/jwt-experimental
```

## Next Steps

- **New to JWT?** Start with [Provided Features](provided-features.md) to see what's available
- **Security conscious?** Read [Security Recommendations](security-recommendations.md) carefully
- **Ready to code?** Jump to [The Components](../the-components/) for detailed usage guides
- **Using Symfony?** Check out [The Symfony Bundle](../the-symfony-bundle/) section
