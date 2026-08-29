# Introduction

Welcome to the **JWT Framework** documentation. This is a modern, secure, and comprehensive PHP library for working with JSON Web Tokens (JWT), designed for both standalone applications and Symfony projects.

## What is JWT Framework?

JWT Framework is a complete implementation of the JOSE (JSON Object Signing and Encryption) specifications, providing robust tools for creating, signing, encrypting, and validating JSON Web Tokens. It follows industry standards and security best practices to help you implement secure token-based authentication and data exchange in your applications.

## Supported Standards

This framework provides full implementation of the following RFCs:

* **JWS** - [JSON Web Signature (RFC 7515)](https://tools.ietf.org/html/rfc7515) - Sign your tokens to ensure integrity and authenticity
* **JWE** - [JSON Web Encryption (RFC 7516)](https://tools.ietf.org/html/rfc7516) - Encrypt your tokens to ensure confidentiality
* **JWK** - [JSON Web Key (RFC 7517)](https://tools.ietf.org/html/rfc7517) - Manage cryptographic keys in a standardized format
* **JWA** - [JSON Web Algorithms (RFC 7518)](https://tools.ietf.org/html/rfc7518) - Use industry-standard cryptographic algorithms
* **JWT** - [JSON Web Token (RFC 7519)](https://tools.ietf.org/html/rfc7519) - Create and validate token claims
* **JSON Web Key Thumbprint** - [RFC 7638](https://tools.ietf.org/html/rfc7638) - Generate unique key identifiers
* **Unencoded Payload Option** - [RFC 7797](https://tools.ietf.org/html/rfc7797) - Support for unencoded payloads in JWS

## Key Features

### 🔐 Comprehensive Security
- Support for all standard signature algorithms (HMAC, RSA, ECDSA, EdDSA)
- Support for all standard encryption algorithms (AES-GCM, AES-CBC, RSA-OAEP, ECDH-ES)
- Built-in header and claim validation
- Protection against common JWT vulnerabilities

### 🛠️ Flexible Integration
- **Standalone library** - Use it in any PHP project
- **Symfony Bundle** - Seamless integration with Symfony applications
- **Console commands** - CLI tools for key management and token inspection

### 🚀 Developer Friendly
- Fluent API for building and loading tokens
- Factory pattern for creating services
- PSR-20 Clock support for time-based validation
- Comprehensive error handling

### 📦 Production Ready
- Extensively tested against RFC test vectors
- Support for nested tokens (signed then encrypted)
- Multiple serialization formats (Compact, JSON Flattened, JSON General)
- Key set management for key rotation

## Installation

Install the package that matches your project:

```bash
# Any PHP project — the core library
composer require web-token/jwt-library

# Symfony application — the bundle (pulls the library in)
composer require web-token/jwt-bundle
```

For Symfony projects, the bundle is automatically registered.

## Quick Start

```php
use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\JWK;
use Jose\Component\Signature\Algorithm\HS256;
use Jose\Component\Signature\JWSBuilder;
use Jose\Component\Signature\Serializer\CompactSerializer;

// Create an algorithm manager
$algorithmManager = new AlgorithmManager([new HS256()]);

// Create a JWS Builder
$jwsBuilder = new JWSBuilder($algorithmManager);

// Create a key
$jwk = new JWK([
    'kty' => 'oct',
    'k' => 'your-secret-key-here',
]);

// Build and sign your token
$jws = $jwsBuilder
    ->create()
    ->withPayload(json_encode(['user_id' => 123]))
    ->addSignature($jwk, ['alg' => 'HS256'])
    ->build();

// Serialize to compact format
$serializer = new CompactSerializer();
$token = $serializer->serialize($jws, 0);
```

## Documentation Structure

This documentation is organized to help you get started quickly and dive deep when needed:

* **[Introduction](introduction/the-framework.md)** - Overview, features, prerequisites, and security recommendations
* **[The Components](the-components/algorithm-management-jwa.md)** - Core library documentation for standalone usage
* **[The Symfony Bundle](the-symfony-bundle/symfony-bundle.md)** - Integration guide for Symfony applications
* **[Console Commands](console-command/console.md)** - CLI tools for key and token management
* **[Advanced Topics](advanced-topics/nested-tokens.md)** - Nested tokens, custom algorithms, and advanced features
* **[Migration Guides](migration/from-v4.1-to-v4.2.md)** - Upgrade guides for major versions

## Requirements

* PHP 8.2 or higher
* OpenSSL extension
* Recommended: GMP or BCMath for better performance
* Recommended: Sodium extension for EdDSA and ECDH-ES algorithms

## Get Help

* **GitHub Issues**: [https://github.com/web-token/jwt-framework/issues](https://github.com/web-token/jwt-framework/issues)
* **Documentation**: [https://web-token.spomky-labs.com](https://web-token.spomky-labs.com)
* **Security Issues**: Please report security vulnerabilities privately to the maintainers

## Contributing

Contributions are welcome! Please read the [contributing guidelines](introduction/contributing.md) before submitting pull requests.

## License

This project is released under the [MIT license](https://github.com/web-token/jwt-framework/blob/4.2.x/LICENSE).
