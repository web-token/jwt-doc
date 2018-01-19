Encrypted Token Decryption
==========================

# JWE Decrypter Factory Service

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

**Reminder: it is important to check the token headers. See the checker section of this documentation.**

# JWE Decrypter As Service

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

With the previous configuration, the bundle will create a public JWE Decrypter service named `jose.jwe_decrypter.decrypter1`
with selected encryption algorithms.

```php
<?php
$jweDecrypter = $container->get('jose.jwe_decrypter.decrypter1');
```

# Custom Tags

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
