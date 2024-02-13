# From v3.x to v4.0

Contrary to upgrade a minor version (where the middle number changes) where no difficulty should be encountered, upgrade a major version (where the first number changes) is subject to significant modifications.

## Update the libraries

First of all, you have to make sure you are using the last v3.x release.

## Spot deprecations

Next, you have to verify you don’t use any deprecated class, interface, method or property. If you have PHPUnit tests, [you can easily get the list of deprecation used in your application](https://symfony.com/doc/current/components/phpunit\_bridge.html).

### List of deprecations:

* <mark style="color:purple;">TO BE WRITTEN</mark>

## Upgrade the dependencies and the libraries

The version 4.0 now requires **PHP 8.2**. Please install this version or a newer one on your platform. Make sure the extensions are also installed. They are namely **JSON** and **MBString**. You may also need **OpenSSL** or **Sodium** depending on the algorithms you want to use.

If you require **Symfony components**, you shall have the version **6.4** or **7.x**. for each of these components.

It is now time to upgrade the libraries. In your composer.json, change all `web-token/*` dependencies from `v3.x` to `v4.0`. When done, execute `composer update`.

You can also update all other dependencies if needed. You can list upgradable libraries by calling `composer outdated`. This step is not mandatory, but highly recommended.

{% hint style="success" %}
[Rector](https://github.com/rectorphp/rector) is a very nice tool from code upgrade. We highly recommend it.
{% endhint %}
