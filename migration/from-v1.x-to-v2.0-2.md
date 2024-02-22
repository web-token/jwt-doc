# From v3.x to v4.0

Contrary to upgrade a minor version (where the middle number changes) where no difficulty should be encountered, upgrade a major version (where the first number changes) is subject to significant modifications.

## Update the libraries

First of all, you have to make sure you are using the last v3.x release.

## Spot deprecations

Next, you have to verify you don’t use any deprecated class, interface, method or property. If you have PHPUnit tests, [you can easily get the list of deprecation used in your application](https://symfony.com/doc/current/components/phpunit\_bridge.html).

### List of deprecations:

#### Deprecated Packages

The following packages are deprecated. Please install `web-token/jwt-library` or `web-token/jwt-experimental` instead.

{% hint style="info" %}
In addtion to the new library or experimental packages, you may need to require third party dependencies such as `ext-sodium`, `ext-openssl` or .
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

In previous versions, the classes that requires time used the PHP time function directly. It is now required to use a PSR-20 Clock implementation and pass it to the classes.

* Jose\Component\Checker\ExpirationTimeChecker
* Jose\Component\Checker\IssuedAtChecker
* Jose\Component\Checker\NotBeforeChecker

For version 3.2.0+ and the Symfony Bundle, an internal implementation service named `jose.internal_clock` existed and is removed.

#### Simplified Algorithm Manager

Classes `Jose\Component\Encryption\JWEBuilder` and `Jose\Component\Encryption\JWEDecrypter` no longer need the Key Encryption and Content Encryption Algorithm Managers. You pass only one Algorithm Manager to the contructor.

#### Version Bumped

All previous major release of the following packages are not supported anymore. Please make sure your platform can use them.

* `PHP`: 8.3+
* `brick/math`: 0.12+
* `symfony/*`: 7.0+ (expect `symfony/polyfill-*` at version 1.29+)

## Upgrade the dependencies and the libraries

Please install this version or a newer one on your platform. Make sure the extensions are also installed. They are namely **JSON** and **MBString**. You may also need **OpenSSL** or **Sodium** depending on the algorithms you want to use.

It is now time to upgrade the libraries. In your composer.json, change all `web-token/*` dependencies from `v3.x` to `v4.0`. When done, execute `composer update`.

You can also update all other dependencies if needed. You can list upgradable libraries by calling `composer outdated`. This step is not mandatory, but highly recommended.

{% hint style="success" %}
[Rector](https://github.com/rectorphp/rector) is a very nice tool from code upgrade. We highly recommend it.
{% endhint %}
