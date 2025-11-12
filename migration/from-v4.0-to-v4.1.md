# Migration Guide: From v4.0 to v4.1

This guide will help you upgrade your application from JWT Framework v4.0 to v4.1. This is a minor version upgrade with new features and improvements, plus some deprecations to be aware of.

{% hint style="success" %}
**Estimated Migration Time:** 15-30 minutes
**Difficulty Level:** Easy
**Breaking Changes:** None
{% endhint %}

## Overview of Changes

Version 4.1 introduces:
- **Symfony 8.0 support** - Full compatibility with Symfony 8.0
- **Performance improvements** - Better Base64UrlSafe performance with ext-sodium
- **Deprecations** - Cache methods marked for removal in v5.0
- **Dependencies** - Support for brick/math 0.14

## What's New

### 1. Symfony 8.0 Support

Full support for Symfony 8.0 while maintaining backward compatibility with Symfony 7.0.

**No action required** - Your code works with both Symfony 7.x and 8.x.

### 2. Performance Improvements

When `ext-sodium` is installed, Base64UrlSafe encoding/decoding is significantly faster.

**Recommendation:** Install the sodium extension:
```bash
# Debian/Ubuntu
apt-get install php-sodium

# macOS
brew install php-sodium

# Verify
php -m | grep sodium
```

### 3. EC Key Generation Improvements

New `private_key_bits` option:
```php
$key = JWKFactory::createECKey('P-256', [
    'use' => 'sig',
    'private_key_bits' => 256
]);
```

## Deprecations

### UrlKeySetFactory Cache Method

The `enableCache()` method is **deprecated** and will be removed in v5.0.

**Old (deprecated):**
```php
$factory = new UrlKeySetFactory();
$factory->enableCache($cache, $ttl); // ⚠️ DEPRECATED
```

**New (recommended):**

Use HTTP client caching instead:

```php
use Symfony\Component\HttpClient\HttpClient;

// Use HTTP client with cache
$client = HttpClient::create(['max_duration' => 30]);
$factory = new UrlKeySetFactory($client);
$keySet = $factory->loadFromUrl('https://example.com/.well-known/jwks.json');
```

**For Symfony:**
```yaml
# config/packages/framework.yaml
framework:
    http_client:
        scoped_clients:
            jwks.client:
                http_cache:
                    enabled: true
```

## Migration Steps

### Step 1: Update Dependencies

```bash
composer require web-token/jwt-framework:^4.1
```

### Step 2: Clear Caches

```bash
# Symfony
php bin/console cache:clear

# Composer
composer clear-cache
```

### Step 3: Check for Deprecations

Enable deprecation logging and run tests:
```bash
vendor/bin/phpunit
```

### Step 4: Update Cache Usage (Optional)

If using `UrlKeySetFactory::enableCache()`, migrate to HTTP client caching.

### Step 5: Test

Test thoroughly:
- Token creation/verification
- Token encryption/decryption
- Remote key loading
- Custom algorithms

## New Features You Can Use

### Symfony 8.0

```bash
composer require symfony/framework-bundle:^8.0
composer require web-token/jwt-framework:^4.1
```

## Troubleshooting

### Deprecation Warning

If you see "Method enableCache is deprecated", migrate to HTTP client caching.

### Performance Issues

Ensure ext-sodium is installed for optimal performance.

## Rollback

```bash
composer require web-token/jwt-framework:^4.0
php bin/console cache:clear
```

## Summary

**✅ Must do:**
- Update to 4.1.x
- Clear caches

**⚠️ Should do:**
- Install ext-sodium
- Migrate from `enableCache()`

**🎁 Can do:**
- Use Symfony 8.0
- Enjoy performance improvements
