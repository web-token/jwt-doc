# From v3.x to v4.0

Contrary to upgrading a minor version (where the middle number changes) where no difficulty should be encountered, upgrading a major version (where the first number changes) is subject to significant modifications.

## Update the libraries

First of all, you have to make sure you are using the last v3.x release.

## Spot deprecations

Next, you have to verify you don’t use any deprecated class, interface, method or property. If you have PHPUnit tests, [you can easily get the list of deprecation used in your application](https://symfony.com/doc/current/components/phpunit_bridge.html).

### List of deprecations:

#### Deprecated Packages

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

#### PSR-20 Clock

In previous versions, the classes that require time used the PHP time function directly. It is now required to use a PSR-20 Clock implementation and pass it to the classes.

* `Jose\Component\Checker\ExpirationTimeChecker`
* `Jose\Component\Checker\IssuedAtChecker`
* `Jose\Component\Checker\NotBeforeChecker`

For version 3.2.0+ and the Symfony Bundle, an internal implementation service named `jose.internal_clock` existed and is removed.

#### Simplified Algorithm Manager

Classes `Jose\Component\Encryption\JWEBuilder` and `Jose\Component\Encryption\JWEDecrypter` no longer need the Key Encryption and Content Encryption Algorithm Managers. You pass only one Algorithm Manager to the constructor.

#### Compression Support Removed

Compression methods (`DEF` / Deflate) that were deprecated in v3.3 have been fully removed. This follows the security recommendation from [RFC 8725 Section 3.6](https://datatracker.ietf.org/doc/html/rfc8725#section-3.6). If your application uses JWE compression, you must remove it before upgrading.

#### Removed Dependencies

The following dependencies have been removed. If you relied on them directly, you may need to adjust your code:

* `fgrosse/phpasn1` — replaced by `spomky-labs/pki-framework`
* `paragonie/constant_time_encoding` — replaced by an internal `Base64UrlSafe` utility
* `psr/http-client` and `psr/http-factory` — replaced by `symfony/http-client-contracts`

#### New Checkers

Two new generic checker classes have been added:

* `Jose\Component\Checker\CallableChecker` — allows custom validation logic via a callable. Implements both `ClaimChecker` and `HeaderChecker`.
* `Jose\Component\Checker\IsEqualChecker` — simple equality validation for claims and headers. Implements both `ClaimChecker` and `HeaderChecker`.

#### ECDH-SS (Static-Static) Key Agreement

New key encryption algorithms have been added for ECDH Static-Static key agreement:

* `ECDH-SS`
* `ECDH-SS+A128KW`
* `ECDH-SS+A192KW`
* `ECDH-SS+A256KW`

#### Version Bumped

All previous major releases of the following packages are not supported anymore. Please make sure your platform can use them.

* `PHP`: 8.2+
* `brick/math`: 0.12+
* `symfony/*`: 7.0+
* `spomky-labs/pki-framework`: 1.2.1+ (new dependency, replaces `fgrosse/phpasn1`)
* `psr/clock`: 1.0+ (new dependency for PSR-20 Clock)

#### Code Modernization

Classes throughout the framework now use modern PHP 8.2+ features:

* `readonly` class declarations
* Constructor property promotion
* `#[Override]` attribute on overridden methods (PHP 8.3 compatibility)
* Stricter type declarations

#### Package Structure Reorganization

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
