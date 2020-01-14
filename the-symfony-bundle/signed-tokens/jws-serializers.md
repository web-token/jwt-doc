# JWS serializers

## JWS Serializer Manager Factory Service

A `JWSSerializerManagerFactory` is available as a service in your application container:

```php
<?php
use Jose\Component\Signature\JWSSerializerManagerFactory;

$jwsSerializerManagerFactory = $container->get(JWSSerializerManagerFactory::class);
```

With this factory, you will be able to create the JWSSerializerManager you need:

```php
$jwsSerializerManager = $jwsSerializerManagerFactory->create(['jws_compact']);
```

You can now use the JWSSerializerManager as explained in the JWS Creation/Loading section.

Available JWS serialization modes are:

* `jws_compact`
* `jws_json_general`
* `jws_json_flattened`

## JWS Serializer Manager As Service

There is also another way to create a JWSSerializerManager object: using the bundle configuration.

```yaml
jose:
    jws:
        serializers:
            serializer1:
                serializers: ['jws_compact']
                is_public: true
```

With the previous configuration, the bundle will create a public JWS Serializer Manager service named `jose.jws_serializer.serializer1` with selected serialization modes.

```php
<?php
$jwsSerializerManager = $container->get('jose.jws_serializer.serializer1');
```

## Custom Tags

You can add custom tags and attributes to the services you create.

```yaml
jose:
    jws:
        serializers:
            serializer1:
                serializers: ['jws_compact']
                tags:
                    tag_name1: ~
                    tag_name2: {attribute1: 'foo'}
```

