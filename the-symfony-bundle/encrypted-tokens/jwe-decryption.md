# JWE decryption

## JWE Decrypter Factory Service

A `JWEDecrypterFactory` is available as a service in your application container:

```php
<?php
use Jose\Component\Encryption\JWEDecrypterFactory;

$jweDecrypterFactory = $container->get(JWEDecrypterFactory::class);
```

With this factory, you will be able to create the JWEDecrypter you need:

```php
$jweDecrypter = $jweDecrypterFactory->create(['HS256']);
```

You can now use the JWEDecrypter as explained in the JWE Creation section.

{% hint style="info" %}
Reminder: it is important to check the token headers. See the checker section of this documentation.
{% endhint %}

## JWE Decrypter As Service

There is also another way to create a JWEDecrypter object: using the bundle configuration.

```yaml
jose:
    jwe:
        decrypters:
            decrypter1:
                key_encryption_algorithms: ['A256GCMKW']
                content_encryption_algorithms: ['A256CBC-HS256']
                compression_methods: ['DEF']
                is_public: true
```

With the previous configuration, the bundle will create a public JWE Decrypter service named `jose.jwe_decrypter.decrypter1` with selected encryption algorithms.

```php
<?php
$jweDecrypter = $container->get('jose.jwe_decrypter.decrypter1');
```

## Custom Tags

You can add custom tags and attributes to the services you create.

```yaml
jose:
    jwe:
        decrypters:
            decrypter1:
                key_encryption_algorithms: ['A256GCMKW']
                content_encryption_algorithms: ['A256CBC-HS256']
                compression_methods: ['DEF']
                tags:
                    tag_name1: ~
                    tag_name2: {attribute1: 'foo'}
```

## JWE Loader Service

The [`JWELoaderFactory`](../../the-components/encrypted-tokens-jwe/jwe-loading.md) is available as a public service. You can retrieve it using the container or inject it into your services. It will help you to create `JWELoader` objects on demand.

```php
<?php
use Jose\Component\Encryption\JWELoaderFactory;

$jweLoaderFactory = $container->get(JWELoaderFactory::class);
```

You can also create `JWELoader` objects as services using the configuration of the bundle.

```yaml
jose:
    jwe:
        loaders:
            jwe_loader1:
                key_encryption_algorithms: ['A256GCMKW']
                content_encryption_algorithms: ['A256CBC-HS256']
                compression_methods: ['DEF']
                header_checkers: ['alg', 'enc']
                is_public: true
```

Or using the [`ConfigurationHelper`](../configuration-helper.md).

```php
<?php
use Jose\Bundle\JoseFramework\Helper\ConfigurationHelper;

...
ConfigurationHelper::addJWELoader($container, 'jwe_loader1', ['jwe_compact'], ['A256GCMKW'], ['A256CBC-HS256'], ['DEF'], ['alg', 'enc'], true);
```
