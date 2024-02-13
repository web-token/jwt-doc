# Symfony Bundle

This framework provides a Symfony bundle that will help you to use the components within your Symfony application.

## With Symfony Flex

Since the version 3.0, Symfony Flex recipes are provided through a dedicated repository. It is mandatory to add this repository before installing the bundle.

```shell
tra.symfony.endpoint '["https://api.github.com/repos/Spomky-Labs/recipes/contents/index.json?ref=main", "flex://defaults"]'
```

{% code title="composer.json" %}
```json
{
    ...
    "extra": {
        "symfony": {
            "endpoint": [
                "https://api.github.com/repos/Spomky-Labs/recipes/contents/index.json?ref=main",
                "flex://defaults"
            ]
        }
    }
}
```
{% endcode %}

Then, you can install the bundle or the complete framework:

```shell
composer require web-token/jwt-bundle #Will only install the bundle
composer require web-token/jwt-framework # Will install the whole framework (not recommended)
```

{% hint style="info" %}
As the recipes are third party ones not officially supported by Symfony, you will be asked to execute the recipe or not. When applied, the recipes will prompt a message such as `Web Token Framework is ready.`
{% endhint %}

## Without Symfony Flex

If you don't use Symfony Flex, you must register the bundle manually.

{% code title="config/bundles.php" %}
```php
<?php

return [
    //...
    Jose\Bundle\JoseFramework\JoseFrameworkBundle::class => ['all' => true],
];

```
{% endcode %}

## Bundle Features

The bundle capabilities will depend on the components installed in your application.

* [Algorithm Management](algorithm-management.md)
* [Header and Claim Checkers](header-and-claim-checker-management.md)
* [Keys and key sets](key-and-key-set-management/)
* [Signed tokens](signed-tokens/)
* [Encrypted tokens](encrypted-tokens/)
