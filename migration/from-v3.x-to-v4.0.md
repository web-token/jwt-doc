# From v3.x to v4.0

Contrary to upgrading a minor version (where the middle number changes) where no difficulty should be encountered, upgrading a major version (where the first number changes) is subject to significant modifications.

## Update the libraries

First of all, you have to make sure you are using the last v3.x release.

## Spot deprecations

Next, you have to verify you don’t use any deprecated class, interface, method or property. If you have PHPUnit tests, [you can easily get the list of deprecation used in your application](https://symfony.com/doc/current/components/phpunit_bridge.html).

## Breaking Changes

### PSR-20 Clock — Constructor Signature Changed

The time-based checkers now **require** a `Psr\Clock\ClockInterface` as the **first** constructor argument. In v3.x, the clock was optional and passed as the last parameter. The argument order has been changed.

{% hint style="danger" %}
This is a breaking change. You must update every instantiation of these classes.
{% endhint %}

The affected classes are:

* `Jose\Component\Checker\ExpirationTimeChecker`
* `Jose\Component\Checker\IssuedAtChecker`
* `Jose\Component\Checker\NotBeforeChecker`

**Before (v3.x):**

```php
use Jose\Component\Checker\ExpirationTimeChecker;
use Jose\Component\Checker\NotBeforeChecker;
use Jose\Component\Checker\IssuedAtChecker;

// Clock was optional, passed as the last argument
$expChecker = new ExpirationTimeChecker(allowedTimeDrift: 10);
$nbfChecker = new NotBeforeChecker(allowedTimeDrift: 10);
$iatChecker = new IssuedAtChecker(allowedTimeDrift: 10);
```

**After (v4.0):**

```php
use Jose\Component\Checker\ExpirationTimeChecker;
use Jose\Component\Checker\NotBeforeChecker;
use Jose\Component\Checker\IssuedAtChecker;
use Psr\Clock\ClockInterface;

// The clock is now required and is the first argument
$clock = /* your PSR-20 ClockInterface implementation */;

$expChecker = new ExpirationTimeChecker(clock: $clock, allowedTimeDrift: 10);
$nbfChecker = new NotBeforeChecker(clock: $clock, allowedTimeDrift: 10);
$iatChecker = new IssuedAtChecker(clock: $clock, allowedTimeDrift: 10);
```

The internal `InternalClock` class and the Symfony Bundle service `jose.internal_clock` have been removed. You must provide your own `ClockInterface` implementation (e.g. `Symfony\Component\Clock\NativeClock`).

### JWEBuilder and JWEDecrypter — Simplified Constructor

`JWEBuilder` and `JWEDecrypter` no longer accept separate Key Encryption and Content Encryption Algorithm Managers, nor a Compression Method Manager. You must now pass a single `AlgorithmManager` containing all required algorithms.

**Before (v3.x):**

```php
use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\JWEBuilder;
use Jose\Component\Encryption\JWEDecrypter;
use Jose\Component\Encryption\Compression\CompressionMethodManager;
use Jose\Component\Encryption\Compression\Deflate;

$keyEncryptionAlgorithmManager = new AlgorithmManager([new A256KW()]);
$contentEncryptionAlgorithmManager = new AlgorithmManager([new A256CBCHS512()]);
$compressionManager = new CompressionMethodManager([new Deflate()]);

$jweBuilder = new JWEBuilder(
    $keyEncryptionAlgorithmManager,
    $contentEncryptionAlgorithmManager,
    $compressionManager
);

$jweDecrypter = new JWEDecrypter(
    $keyEncryptionAlgorithmManager,
    $contentEncryptionAlgorithmManager,
    $compressionManager
);
```

**After (v4.0):**

```php
use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\JWEBuilder;
use Jose\Component\Encryption\JWEDecrypter;

// A single AlgorithmManager with both key encryption and content encryption algorithms
$algorithmManager = new AlgorithmManager([
    new A256KW(),
    new A256CBCHS512(),
]);

$jweBuilder = new JWEBuilder($algorithmManager);
$jweDecrypter = new JWEDecrypter($algorithmManager);
```

### JWEBuilderFactory and JWEDecrypterFactory — Simplified Signatures

The factory classes have also been simplified accordingly.

**Before (v3.x):**

```php
$jweBuilderFactory = new JWEBuilderFactory(
    $algorithmManagerFactory,
    $compressionMethodManagerFactory
);

$jweBuilder = $jweBuilderFactory->create(
    [‘A256KW’],          // Key encryption algorithms
    [‘A256CBC-HS512’],   // Content encryption algorithms
    [‘DEF’]              // Compression methods
);
```

**After (v4.0):**

```php
$jweBuilderFactory = new JWEBuilderFactory($algorithmManagerFactory);

$jweBuilder = $jweBuilderFactory->create(
    [‘A256KW’, ‘A256CBC-HS512’] // All algorithms in a single list
);
```

The same applies to `JWEDecrypterFactory`.

### Compression Support Removed

Compression methods (`DEF` / Deflate) that were deprecated in v3.3 have been fully removed. This follows the security recommendation from [RFC 8725 Section 3.6](https://datatracker.ietf.org/doc/html/rfc8725#section-3.6). If your application uses JWE compression, you must remove it before upgrading.

The following classes have been removed:

* `Jose\Component\Encryption\Compression\CompressionMethodManager`
* `Jose\Component\Encryption\Compression\Deflate`
* All compression-related interfaces and classes

### Removed Dependencies

The following dependencies have been removed. If you relied on them directly, you may need to adjust your code:

* `fgrosse/phpasn1` — replaced by `spomky-labs/pki-framework`
* `paragonie/constant_time_encoding` — replaced by an internal `Base64UrlSafe` utility
* `psr/http-client` and `psr/http-factory` — replaced by `symfony/http-client-contracts`

### Version Bumped

All previous major releases of the following packages are not supported anymore. Please make sure your platform can use them.

* `PHP`: 8.2+
* `brick/math`: 0.12+
* `symfony/*`: 7.0+
* `spomky-labs/pki-framework`: 1.2.1+ (new dependency, replaces `fgrosse/phpasn1`)
* `psr/clock`: 1.0+ (new dependency for PSR-20 Clock)

## Deprecated Packages

The following packages are deprecated. Please install `web-token/jwt-library` or `web-token/jwt-experimental` instead.

{% hint style="info" %}
In addition to the new library or experimental packages, you may need to require third party dependencies such as `ext-sodium`, `ext-openssl` or similar extensions.
{% endhint %}

* `web-token/jwt-util-ecc`
* `web-token/jwt-key-mgmt`
* `web-token/jwt-core`
* `web-token/jwt-checker`
* `web-token/jwt-console`
* `web-token/jwt-signature`
* `web-token/signature-pack`
* `web-token/jwt-signature-algorithm-*`
* `web-token/jwt-encryption`
* `web-token/encryption-pack`
* `web-token/jwt-encryption-algorithm-*`
* `web-token/jwt-nested-token`

## New Features

### New Checkers

Two new generic checker classes have been added:

* `Jose\Component\Checker\CallableChecker` — allows custom validation logic via a callable. Implements both `ClaimChecker` and `HeaderChecker`.
* `Jose\Component\Checker\IsEqualChecker` — simple equality validation for claims and headers. Implements both `ClaimChecker` and `HeaderChecker`.

### ECDH-SS (Static-Static) Key Agreement

New key encryption algorithms have been added for ECDH Static-Static key agreement:

* `ECDH-SS`
* `ECDH-SS+A128KW`
* `ECDH-SS+A192KW`
* `ECDH-SS+A256KW`

### Code Modernization

Classes throughout the framework now use modern PHP 8.2+ features:

* `readonly` class declarations
* Constructor property promotion
* `#[Override]` attribute on overridden methods (PHP 8.3 compatibility)
* Stricter type declarations

### Package Structure Reorganization

The internal file structure has been reorganized:

* All core component classes are now in `src/Library/` (namespace `Jose\Component\` is unchanged)
* The Symfony Bundle is now in `src/Bundle/` (namespace `Jose\Bundle\JoseFramework\` is unchanged)
* Experimental features are in `src/Experimental/` (namespace `Jose\Experimental\`)
* A `src/Deprecated/` folder provides backward compatibility with old package references

{% hint style="info" %}
The PHP namespaces have not changed. If you use the public API, your code should continue to work without modification.
{% endhint %}

## Upgrade the dependencies and the libraries

Please install PHP 8.2 or a newer version on your platform. Make sure the **OpenSSL** extension is installed (required). You may also need **Sodium** depending on the algorithms you want to use (EdDSA, ECDH-ES with X25519).

{% hint style="info" %}
The `json` and `mbstring` extensions are built-in with PHP 8.2+ and no longer need to be installed separately.
{% endhint %}

It is now time to upgrade the libraries. In your `composer.json`, change all `web-token/*` dependencies from `v3.x` to `v4.0`. When done, execute `composer update`.

You can also update all other dependencies if needed. You can list upgradable libraries by calling `composer outdated`. This step is not mandatory, but highly recommended.

{% hint style="success" %}
[Rector](https://github.com/rectorphp/rector) is a very nice tool for code upgrade. We highly recommend it.
{% endhint %}
