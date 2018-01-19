JWE Serializers
===============

# JWE Serializer Manager Factory Service

A `JWESerializerManagerFactory` is available as a service in your application container:

```php
<?php
use Jose\Component\Encryption\JWESerializerManagerFactory;

$jweSerializerManagerFactory = $container->get(JWESerializerManagerFactory::class);
```

With this factory, you will be able to create the JWESerializerManager you need:

```php
$jweSerializerManager = $jweSerializerManagerFactory->create(['jwe_compact']);
```

You can now use the JWESerializerManager as explained in the JWE Creation/Loading section.

Available JWE serialization modes are:

* `jwe_compact`
* `jwe_json_general`
* `jwe_json_flattened`

# JWE Serializer Manager As Service

There is also another way to create a JWESerializerManager object: using the bundle configuration.

```yaml
jose:
    jwe:
        serializers:
            serializer1:
                serializers: ['jwe_compact']
                is_public: true
```

With the previous configuration, the bundle will create a public JWE Serializer Manager service named `jose.jwe_serializer.serializer1`
with selected serialization modes.

```php
<?php
$jweSerializerManager = $container->get('jose.jwe_serializer.serializer1');
```

# Custom Tags

You can add custom tags and attributes to the services you create.

```yaml
jose:
    jwe:
        serializers:
            serializer1:
                serializers: ['jwe_compact']
                tags:
                    tag_name1: ~
                    tag_name2: {attribute1: 'foo'}
```
