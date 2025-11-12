# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the documentation repository for the JWT Framework, a PHP library implementing JSON Web Token (JWT), JSON Web Signature (JWS), and JSON Web Encryption (JWE) standards. The documentation is built using GitBook and published at https://web-token.spomky-labs.com.

The actual PHP implementation is maintained in a separate repository at https://github.com/web-token/jwt-framework (locally available at ~/Projects/jwt-framework)

## Repository Structure

This is a documentation-only repository organized as a GitBook project:

- **Root level**: Main documentation files (README.md, SUMMARY.md, GLOSSARY.md, security-recommendations.md)
- **components/**: Documentation for low-level PHP components (algorithm management, key management, JWS, JWE)
- **symfony-bundle/**: Documentation for Symfony bundle integration
- **console/**: Documentation for standalone CLI tools and PHAR application
- **advanced-topics/**: Advanced features (nested tokens, multiple signatures/recipients, AAD, custom algorithms)
- **migration/**: Migration guides from legacy libraries
- **benchmarks/**: Performance documentation and results
- **book.json**: GitBook configuration file

## Documentation Architecture

### Content Organization

1. **Core Concepts** (components/):
   - Algorithm Management (JWA) - signature and encryption algorithms
   - Key Management (JWK) and Key Sets (JWKSet)
   - Header Checker and Claim Checker - validation logic
   - Signed Tokens (JWS) - creation and verification
   - Encrypted Tokens (JWE) - encryption and decryption

2. **Integration** (symfony-bundle/):
   - Service configuration for Symfony applications
   - Bundle-specific features for key/algorithm management
   - JWS and JWE integration with Symfony DI

3. **Tooling** (console/):
   - Standalone console application
   - Symfony console integration
   - PHAR distribution

### Key Terminology (from GLOSSARY.md)

- **JWT**: JSON Web Token (RFC 7519)
- **JWS**: Digitally signed JWT
- **JWE**: Digitally encrypted JWT
- **Nested token**: A JWE containing a JWS as payload
- **AAD**: Additional Authenticated Data for encrypted tokens

## Working with Documentation

### GitBook Structure

- **SUMMARY.md** defines the table of contents and navigation structure
- All documentation files are in Markdown format
- Internal links use relative paths between markdown files
- The documentation follows a hierarchical structure mirrored in the filesystem

### Making Documentation Changes

When editing documentation:

1. Ensure links in SUMMARY.md are updated if adding/removing/moving pages
2. Use relative links between documentation pages
3. Follow the existing documentation style (heading hierarchy, code blocks, tables)
4. Reference RFC specifications where appropriate (e.g., RFC 7515 for JWS, RFC 7516 for JWE)
5. Maintain consistency with security-recommendations.md when discussing security topics

### Security Focus

The framework emphasizes security best practices. When documenting features:

- Reference security-recommendations.md for guidance on secure usage
- Warn about weak or deprecated algorithms (none, RSA1_5)
- Emphasize the importance of key rotation, appropriate key sizes, and secure connections
- Highlight the mandatory validation steps (header checking, claim checking)

## Git Workflow

- Main branch: `4.0` (latest version)
- Repository: git@github.com:web-token/jwt-doc.git
- Clean working directory should be maintained (documentation repository)

## Documentation Publishing

This documentation is published using **GitBook** at https://web-token.spomky-labs.com. GitBook automatically builds and deploys from the repository.

## Key Documentation Sections

### Algorithm Support

The framework supports extensive algorithms documented in README.md:
- Signature: HS256/384/512, ES256/384/512, RS256/384/512, PS256/384/512, EdDSA
- Key encryption: RSA-OAEP, ECDH-ES variants, AES-KW, PBES2, GCM-KW
- Content encryption: AES-CBC+HMAC, AES-GCM
- Compression: Deflate, GZip, ZLib

### Serialization Modes

All three JWT serialization modes are supported:
- Compact JSON Serialization (URL-safe, single signature/recipient)
- Flattened JSON Serialization (JSON format, single signature/recipient)
- General JSON Serialization (JSON format, multiple signatures/recipients)

## Implementation Repository Architecture (~/Projects/jwt-framework)

The JWT Framework implementation is a monorepo containing three main packages:

### Package Structure

```
src/
├── Library/          (Jose\Component\*)      - Core components
├── Bundle/           (Jose\Bundle\*)         - Symfony Bundle
└── Experimental/     (Jose\Experimental\*)  - Experimental features
```

### Core Library Components (src/Library/)

The library is organized into self-contained modules:

1. **Core/** - Foundation classes
   - `JWK` - JSON Web Key representation
   - `JWKSet` - Key set management
   - `Algorithm` - Algorithm interface
   - `AlgorithmManager` - Algorithm registry and selection
   - `JWT` - Base token interface
   - **Util/** - Cryptographic utilities (RSA, EC, Base64UrlSafe, Hash, etc.)

2. **Signature/** - JWS (signed tokens)
   - `JWS` - Signed token representation
   - `JWSBuilder` - Token creation
   - `JWSVerifier` - Signature verification
   - `JWSLoader` - Load and verify in one step
   - **Algorithm/** - Signature algorithms (HMAC, RSA-PSS, ECDSA, EdDSA, None)
   - **Serializer/** - Three serialization formats (Compact, JSONFlattened, JSONGeneral)

3. **Encryption/** - JWE (encrypted tokens)
   - `JWE` - Encrypted token representation
   - `JWEBuilder` - Token encryption
   - `JWEDecrypter` - Token decryption
   - `JWELoader` - Load and decrypt in one step
   - **Algorithm/** - Key encryption and content encryption algorithms
   - **Serializer/** - Three serialization formats (Compact, JSONFlattened, JSONGeneral)

4. **Checker/** - Validation framework
   - `HeaderChecker` - Validates protected/unprotected headers
   - `ClaimChecker` - Validates payload claims
   - `HeaderCheckerManager` / `ClaimCheckerManager` - Orchestrate multiple checkers
   - Built-in checkers: Algorithm, Audience, Expiration, IssuedAt, Issuer, NotBefore

5. **KeyManagement/** - Key operations
   - `JWKFactory` - Create keys from various sources (file, certificate, random generation)
   - `UrlKeySetFactory` - Load key sets from URLs
   - `JKUFactory` - JKU header parameter support
   - `X5UFactory` - X5U header parameter support
   - **Analyzer/** - Key quality analysis
   - **KeyConverter/** - Key format conversion

6. **NestedToken/** - Nested token support (JWE containing JWS)

7. **Console/** - Standalone CLI commands for key management

### Symfony Bundle (src/Bundle/)

Integration layer for Symfony applications:

- **DependencyInjection/** - Service definitions and configuration
- **DataCollector/** - Symfony profiler integration
- **Controller/** - JWKSet endpoints
- **Serializer/** - Integration with Symfony Serializer component
- **Event/** - Event dispatcher integration for token lifecycle hooks
- **Helper/** - Configuration helper classes

### Development Commands

The project uses Castor for task automation (castor.php). Common tasks:

**Testing:**
- `castor phpunit` - Run PHPUnit tests with coverage
- `castor infect` - Run mutation testing with Infection

**Code Quality:**
- `castor ecs` - Check coding standards (Easy Coding Standard)
- `castor ecs_fix` - Fix coding standard issues
- `castor rector` - Check for code modernization (dry-run)
- `castor rector_fix` - Apply Rector fixes
- `castor phpstan` - Run static analysis
- `castor lint` - Run PHP parallel linter
- `castor deptrac` - Verify architectural boundaries

**Dependencies:**
- `castor install` - Install dependencies
- `castor checkLicenses` - Verify allowed licenses

**Note:** Castor tasks use Docker containers for PHP QA tools, ensuring consistent environments. Tests are located in `tests/` with coverage reports in `.ci-tools/coverage/`.

## Key Architecture Patterns

### Factory Pattern
Each major component has a corresponding factory:
- `AlgorithmManagerFactory` - Build algorithm managers
- `JWSBuilderFactory`, `JWSVerifierFactory`, `JWSLoaderFactory`
- `JWEBuilderFactory`, `JWEDecrypterFactory`, `JWELoaderFactory`
- `JWSSerializerManagerFactory`, `JWESerializerManagerFactory`
- `HeaderCheckerManagerFactory`, `ClaimCheckerManagerFactory`

### Builder Pattern
Token creation uses fluent builders:
```php
JWSBuilder -> withPayload() -> addSignature() -> build()
JWEBuilder -> withPayload() -> withSharedProtectedHeader() -> addRecipient() -> build()
```

### Strategy Pattern
- Algorithms implement `Algorithm` interface (signature vs encryption)
- Checkers implement `HeaderChecker` or `ClaimChecker` interfaces
- Serializers implement `JWSSerializer` or `JWESerializer` interfaces

### Immutability
Core objects (JWK, JWKSet, JWS, JWE) are immutable value objects.

## PHP Version & Dependencies

- **Minimum PHP:** 8.2+
- **Required extensions:** openssl
- **Key dependencies:**
  - `spomky-labs/pki-framework` - PKI operations
  - `brick/math` - Arbitrary precision math for cryptography
  - Symfony components (7.0+ or 8.0+) for bundle and console
  - `psr/clock`, `psr/event-dispatcher` - PSR interfaces
- **Optional:** `ext-sodium`, `ext-gmp`, `spomky-labs/aes-key-wrap`

## Testing Philosophy

- PSR-12 coding standard enforced
- Comprehensive PHPUnit test suite covering all algorithms
- RFC 7520 test vectors implemented
- Mutation testing with Infection
- Architecture validated with Deptrac

## Related Resources

- Live documentation: https://web-token.spomky-labs.com
- Implementation repository: https://github.com/web-token/jwt-framework
- RFC references: 7515 (JWS), 7516 (JWE), 7517 (JWK), 7518 (JWA), 7519 (JWT), 7638 (thumbprint), 7797 (unencoded payload)
