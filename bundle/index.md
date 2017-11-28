The Bundles
===========

This framework provides a Symfony bundle that will help you to use the components within your Symfony application.

If you are using Symfony Flex, there is nothing to do, otherwise you have to enable the bundle in your kernel file
 
```php
/**
 * {@inheritdoc}
 */
public function registerBundles()
{
    $bundles = [
        ...
        new Jose\Bundle\JoseFramework\JoseFrameworkBundle(),
    ];

    return $bundles;
}
```

The bundle capabilities will depend on the components installed in your application.
The core component is always available.

* [Algorithm Management](jwa/index.md)
* [Header and Claim Checkers](checker/index.md)
* [Keys and key sets](jwk/index.md)
* [Signed tokens](jws/index.md)
* [Encrypted tokens](jwe/index.md)
