# From v1.x to v2.0

Contrary to upgrade a minor version \(where the middle number changes\) where no difficulty should be encountered, upgrade a major version \(where the first number changes\) is subject to significant modifications.

## Update the libraries

First of all, you have to make sure you are using the last v1.x release \(1.3.8\).

## Spot deprecations

Next, you have to verify you don’t use any deprecated class, interface, method or property. If you have PHPUnit tests, [you can easily get the list of deprecation used in your application](https://symfony.com/doc/current/components/phpunit_bridge.html).

### List of deprecations:

* `Jose\Component\Core\JWK::create()`: this static function is removed. Use the constructor instead
* `Jose\Component\Core\JWKSet::createFromKeys()` : this static function is removed. Use the constructor instead
* `Jose\Component\Core\Converter\JsonConverter`: this interface is removed. No replacement.
* `Jose\Component\Core\Converter\StandardConverter`: this class is removed. No replacement.
* `Jose\Component\Encryption\Compression\CompressionMethodManager::create()`: this static function is removed. Use the constructor instead
* `Jose\Component\Encryption\Compression\GZip`: this class is removed. No replacement.
* `Jose\Component\Encryption\Compression\ZLib`: this class is removed. No replacement.
* `Jose\Component\Encryption\Serializer\JWESerializerManager::list()`: this method is removed. Please use `names()`

With the Symfony bundle, the configuration option `jose.json_converter` is removed.

## Add missing dependencies

In v1.x, when you install the `web-token/jwt-signature` or `web-token/jwt-encryption`, the algorithms are automatically install.

In v2.0, you must explicitly install the algorithms you need. Please refer to the [signature algorithms page](../components/signed-tokens-jws/signature-algorithms.md) or [encryption algorithms page](../components/encrypted-tokens-jwe/encryption-algorithms.md) to know what package you need to install.

## Upgrade the libraries

It is now time to upgrade the libraries. In your composer.json, change all `web-token/*` dependencies from `v1.x` to `v2.0`. When done, execute `composer update`.

You can also update all other dependencies if needed. You can list upgradable libraries by calling `composer outdated`. This step is not mandatory, but highly recommended.

