# From v4.0 to v4.1

This is a minor version upgrade. Most applications should upgrade without any code changes.

## New Features

### Symfony 8.0 Support

The Symfony Bundle now supports both Symfony 7.0 and Symfony 8.0. All Symfony component constraints have been updated accordingly.

### Sodium-based Base64URL Encoding

When the `ext-sodium` PHP extension is available, the framework now uses native Sodium functions for Base64URL encoding and decoding. This provides significant performance improvements without requiring any code changes on your side.

### PHP 8.5 Compatibility

Several internal fixes have been applied to ensure forward compatibility with PHP 8.5:

* EC key generation now includes the `private_key_bits` parameter required by PHP 8.5+
* `substr()` calls no longer pass `null` as the third parameter
* `chr()` calls are now constrained to the 0-255 range

### Sensitive Parameter Attributes

Methods handling potentially sensitive data in `Base64UrlSafe` now use the PHP 8.2+ `#[SensitiveParameter]` attribute. This prevents sensitive values from being leaked in stack traces or debug output.

### brick/math 0.14 Support

The framework now supports `brick/math` version 0.14, in addition to 0.12 and 0.13.

## Deprecations

### `UrlKeySetFactory::enabledCache()`

The `enabledCache()` method on `UrlKeySetFactory` is deprecated since 4.1 and will be removed in 5.0.

**Migration path:** use HTTP Client-level caching instead. When configuring your Symfony HTTP Client, use a caching layer (e.g. Symfony's `CachingHttpClient` or an HTTP cache middleware) rather than relying on the `UrlKeySetFactory` to cache responses.

**Before (deprecated):**

```php
$factory->enabledCache($cacheItemPool, 3600);
$jwkset = $factory->loadFromUrl($url);
```

**After:**

```php
// Configure caching at the HTTP client level
// In Symfony, use framework.http_client with caching enabled
$jwkset = $factory->loadFromUrl($url);
```

In the Symfony Bundle configuration for distant key sets (JKU/X5U), it is recommended to configure HTTP client caching:

```yaml
jose:
    jku_factory:
        enabled: true
        client: 'http_client' # Use a cached HTTP client
```

## Console Commands

Console commands have been refactored for Symfony Console 7.0+ compatibility:

* Help text is now defined via `setHelp()` in the `configure()` method instead of the `help` parameter in the `#[AsCommand]` attribute
* Default `null` values have been removed from optional command options

These changes are internal and do not affect how you use the commands.
