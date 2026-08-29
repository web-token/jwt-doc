# Symfony Bundle

The JWT Framework Symfony Bundle provides seamless integration of the JWT Framework into your Symfony applications. It leverages Symfony's dependency injection container to automatically configure and wire all services, making it easy to work with JSON Web Tokens in your Symfony projects.

## Why Use the Symfony Bundle?

The bundle offers several advantages for Symfony developers:

### 🎯 **Zero Configuration**
- Auto-discovery of algorithms and services
- Automatic service registration
- Sensible defaults out of the box

### 🔧 **Configuration-Driven**
- YAML-based configuration for all components
- Type-safe configuration validation
- Environment variable support

### 📊 **Developer Tools**
- Symfony Profiler integration
- Debug toolbar with token inspection
- Data collectors for performance monitoring

### 🔄 **Event System**
- Token lifecycle events
- Hook into token creation and validation
- Perfect for logging and auditing

### 🏭 **Factory Services**
- Pre-configured factories for common operations
- Easy creation of builders, loaders, and validators
- Support for multiple configurations

## Installation

{% hint style="info" %}
The bundle supports Symfony 7.0 and Symfony 8.0.
{% endhint %}

### With Symfony Flex (Recommended)

The bundle is automatically detected and installed when using Symfony Flex:

```bash
composer require web-token/jwt-bundle
```

{% hint style="info" %}
As the recipes are third party recipes not officially supported by Symfony, you will be asked whether to execute the recipe or not. When applied, the recipes will display a message: `Web Token Framework is ready.`
{% endhint %}

After installation, the bundle is automatically registered and ready to use!

### Without Symfony Flex

If you're not using Symfony Flex, you need to register the bundle manually:

{% code title="config/bundles.php" %}
```php
<?php

return [
    // ...
    Jose\Bundle\JoseFramework\JoseFrameworkBundle::class => ['all' => true],
];
```
{% endcode %}

## Quick Start Example

After installation, you can configure a simple JWS service:

{% code title="config/packages/jose.yaml" %}
```yaml
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
{% endcode %}

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

## Bundle Features

The bundle provides comprehensive support for all JWT Framework components. Explore the documentation based on your needs:

### Core Features

* **[Algorithm Management](algorithm-management.md)** - Configure signature and encryption algorithms
* **[Key and Key Set Management](key-and-key-set-management/README.md)** - Manage cryptographic keys via configuration
* **[Header and Claim Checkers](header-and-claim-checker-management.md)** - Validate token headers and claims

### Token Operations

* **[Signed Tokens (JWS)](signed-tokens/README.md)** - Create and verify signed tokens
  * [JWS Serializers](signed-tokens/jws-serializers.md)
  * [JWS Creation](signed-tokens/jws-creation.md)
  * [JWS Verification](signed-tokens/jws-verification.md)

* **[Encrypted Tokens (JWE)](encrypted-tokens/README.md)** - Create and decrypt encrypted tokens
  * [JWE Serializers](encrypted-tokens/jwe-serializers.md)
  * [JWE Creation](encrypted-tokens/jwe-creation.md)
  * [JWE Decryption](encrypted-tokens/jwe-decryption.md)

### Advanced Features

* **[Configuration Helper](configuration-helper.md)** - Programmatic configuration
* **[Events](events.md)** - Token lifecycle events and listeners

## Service Auto-wiring

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

### Auto-wiring By Interface

Every service you declare in the configuration is aliased both with its concrete class and with its **interface**. Naming the argument after the service picks the right one:

```yaml
jose:
    jws:
        builders:
            builder1:
                signature_algorithms: ['ES256']
        verifiers:
            verifier1:
                signature_algorithms: ['ES256']
```

```php
use Jose\Component\Signature\JWSBuilderInterface;
use Jose\Component\Signature\JWSVerifierInterface;

class MyService
{
    public function __construct(
        JWSBuilderInterface $builder1JwsBuilder,   // jose.jws_builder.builder1
        JWSVerifierInterface $verifier1JwsVerifier, // jose.jws_verifier.verifier1
    ) {
    }
}
```

The argument name is the service name followed by the kind of service: `builder1` + `JwsBuilder`. The same convention applies to `JwsLoader`, `JweBuilder`, `JweDecrypter`, `JweLoader`, `NestedTokenBuilder` and `NestedTokenLoader`.

{% hint style="info" %}
Interfaces were introduced in 4.3. Prefer them over the concrete classes: they are what the library type-hints internally, so a decorator can be injected in place of any service. Type-hinting the concrete class keeps working.
{% endhint %}

The key factory is aliased the same way:

```php
use Jose\Component\KeyManagement\JWKFactoryInterface;

public function __construct(private JWKFactoryInterface $jwkFactory) {}
```

### Decorating A Service

Because every service is described by an interface, decorating one is standard Symfony:

```php
#[AsDecorator('jose.jws_loader.jws_loader1')]
final readonly class LoggingJwsLoader implements JWSLoaderInterface
{
    public function __construct(
        #[AutowireDecorated] private JWSLoaderInterface $inner,
        private LoggerInterface $logger,
    ) {
    }

    public function loadAndVerify(string $token, JWK|JWKSet $keys, ?string $payload = null): LoadingResult
    {
        $result = $this->inner->loadAndVerify($token, $keys, $payload);
        $this->logger->info('Token verified', ['kid' => $result->getKey()->find('kid')]);

        return $result;
    }

    // ... the remaining methods of the interface delegate to $this->inner
}
```

{% hint style="warning" %}
Extending the concrete classes — `JWSLoader`, `JWEDecrypter`… — is deprecated since 4.3 and raises a notice. Implement the interface and decorate instead. The bundle itself did the same: its event dispatching services are decorators now, and the inheritance based ones are deprecated. They keep their class names, their service ids and their behaviour, so **no configuration change is needed**.
{% endhint %}

## Configuration Reference

For a complete configuration reference, run:

```bash
php bin/console config:dump-reference jose
```

## Next Steps

- **New to the bundle?** Start with [Algorithm Management](algorithm-management.md)
- **Need to sign tokens?** Check [Signed Tokens](signed-tokens/README.md)
- **Need to encrypt tokens?** Check [Encrypted Tokens](encrypted-tokens/README.md)
- **Advanced configuration?** See [Configuration Helper](configuration-helper.md)
