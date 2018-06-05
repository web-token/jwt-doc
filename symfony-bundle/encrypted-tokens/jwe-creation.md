# JWE creation

## JWE Builder Factory Service

A `JWEBuilderFactory` is available as a service in your application container:

```php
<?php
use Jose\Component\Encryption\JWEBuilderFactory;

$jweBuilderFactory = $container->get(JWEBuilderFactory::class);
```

With this factory, you will be able to create the JWEBuilder you need:

```php
$jweBuilder = $jweBuilderFactory->create(
    ['A256GCMKW'],
    ['A256CBC-HS256'],
    ['DEF'] // Compression methods
);
```

Available compression methods are:

* `DEF`: deflate \(recommended\)
* `GZ`: gzip
* `ZLIB`: zlib

You can now use the JWEBuilder as explained in the JWE Creation section.

## JWE Builder As Service

There is also another way to create a JWEBuilder object: using the bundle configuration.

```yaml
jose:
    jwe:
        builders:
            builder1:
                key_encryption_algorithms: ['A256GCMKW']
                content_encryption_algorithms: ['A256CBC-HS256']
                compression_methods: ['DEF']
                is_public: true
```

With the previous configuration, the bundle will create a public JWE Builder service named `jose.jwe_builder.builder1` with selected encryption algorithms.

```php
<?php
$jweBuilder = $container->get('jose.jwe_builder.builder1');
```

## Custom Tags

> This feature was introduced in version 1.1.

You can add custom tags and attributes to the services you create.

```yaml
jose:
    jwe:
        builders:
            builder1:
                key_encryption_algorithms: ['A256GCMKW']
                content_encryption_algorithms: ['A256CBC-HS256']
                compression_methods: ['DEF']
                tags:
                    tag_name1: ~
                    tag_name2: {attribute1: 'foo'}
```

