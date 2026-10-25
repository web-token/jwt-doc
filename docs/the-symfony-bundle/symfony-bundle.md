# Symfony bundle

The JWT Framework Symfony Bundle provides seamless integration of the JWT Framework into your Symfony applications. It leverages Symfony's dependency injection container to automatically configure and wire all services, making it easy to work with JSON Web Tokens in your Symfony projects.

## Why use the Symfony bundle?

The bundle offers several advantages for Symfony developers:

### 🎯 **Zero configuration**
- Auto-discovery of algorithms and services
- Automatic service registration
- Sensible defaults out of the box

### 🔧 **Configuration-driven**
- YAML-based configuration for all components
- Type-safe configuration validation
- Environment variable support

### 📊 **Developer tools**
- Symfony Profiler integration
- Debug toolbar with token inspection
- Data collectors for performance monitoring

### 🔄 **Event system**
- Token lifecycle events
- Hook into token creation and validation
- Perfect for logging and auditing

### 🏭 **Factory services**
- Pre-configured factories for common operations
- Easy creation of builders, loaders, and validators
- Support for multiple configurations

## Installation

!!! info

    The bundle supports Symfony 7.0 and Symfony 8.0.

### With Symfony Flex (Recommended)

The bundle is automatically detected and installed when using Symfony Flex:

```bash
composer require web-token/jwt-bundle
```

!!! info

    As the recipes are third party recipes not officially supported by Symfony, you will be asked whether to execute the recipe or not. When applied, the recipes will display a message: `Web Token Framework is ready.`

After installation, the bundle is automatically registered and ready to use!

### Without Symfony Flex

If you're not using Symfony Flex, you need to register the bundle manually:

```php title="config/bundles.php"
<?php

return [
    // ...
    Jose\Bundle\JoseFramework\JoseFrameworkBundle::class => ['all' => true],
];
```

## Quick start example

After installation, you can configure a simple JWS service:

```yaml title="config/packages/jose.yaml"
jose:
    # Configure the algorithm manager
    jws:
        builders:
            my_jws_builder:
                signature_algorithms: ['HS256']

        verifiers:
            my_jws_verifier:
                signature_algorithms: ['HS256']
```

Then use it in your services:

```php
use Jose\Component\Signature\JWSBuilder;
use Jose\Component\Signature\JWSVerifier;

class TokenService
{
    public function __construct(
        private JWSBuilder $jwsBuilder,
        private JWSVerifier $jwsVerifier
    ) {}

    public function createToken(array $claims): string
    {
        // Your token creation logic
    }
}
```

## Bundle features

The bundle provides comprehensive support for all JWT Framework components. Explore the documentation based on your needs:

### Core features

* **[Algorithm Management](algorithm-management.md)** - Configure signature and encryption algorithms
* **[Key and Key Set Management](key-and-key-set-management/README.md)** - Manage cryptographic keys via configuration
* **[Header and Claim Checkers](header-and-claim-checker-management.md)** - Validate token headers and claims

### Token operations

* **[Signed Tokens (JWS)](signed-tokens/README.md)** - Create and verify signed tokens
  * [JWS Serializers](signed-tokens/jws-serializers.md)
  * [JWS Creation](signed-tokens/jws-creation.md)
  * [JWS Verification](signed-tokens/jws-verification.md)

* **[Encrypted Tokens (JWE)](encrypted-tokens/README.md)** - Create and decrypt encrypted tokens
  * [JWE Serializers](encrypted-tokens/jwe-serializers.md)
  * [JWE Creation](encrypted-tokens/jwe-creation.md)
  * [JWE Decryption](encrypted-tokens/jwe-decryption.md)

### Advanced features

* **[Configuration Helper](configuration-helper.md)** - Programmatic configuration
* **[Events](events.md)** - Token lifecycle events and listeners

## Service auto-wiring

All services created through the bundle configuration are automatically available for auto-wiring. You can inject them by type or by name:

```php
use Jose\Component\Signature\JWSBuilderFactory;
use Jose\Component\Signature\JWSVerifierFactory;

class MyService
{
    public function __construct(
        JWSBuilderFactory $jwsBuilderFactory,
        JWSVerifierFactory $jwsVerifierFactory
    ) {
        // Services are automatically injected
    }
}
```

## Configuration reference

For a complete configuration reference, run:

```bash
php bin/console config:dump-reference jose
```

## Next steps

- **New to the bundle?** Start with [Algorithm Management](algorithm-management.md)
- **Need to sign tokens?** Check [Signed Tokens](signed-tokens/README.md)
- **Need to encrypt tokens?** Check [Encrypted Tokens](encrypted-tokens/README.md)
- **Advanced configuration?** See [Configuration Helper](configuration-helper.md)
