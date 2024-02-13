# JWS creation

## JWS Builder Factory Service

A `JWSBuilderFactory` is available as a service in your application container:

```php
<?php
use Jose\Component\Signature\JWSBuilderFactory;

$jwsBuilderFactory = $container->get(JWSBuilderFactory::class);
```

With this factory, you will be able to create the JWSBuilder you need:

```php
$jwsBuilder = $jwsBuilderFactory->create(['HS256']);
```

You can now use the JWSBuilder as explained in the JWS Creation section.

## JWS Builder As Service

There is also another way to create a JWSBuilder object: using the bundle configuration.

```yaml
jose:
    jws:
        builders:
            builder1:
                signature_algorithms: ['HS256', 'RS256', 'ES256']
                is_public: true
```

With the previous configuration, the bundle will create a public JWS Builder service named `jose.jws_builder.builder1` with selected signature algorithms.

```php
<?php
$jwsBuilder = $container->get('jose.jws_builder.builder1');
```

## Custom Tags

You can add custom tags and attributes to the services you create.

```yaml
jose:
    jws:
        builders:
            builder1:
                signature_algorithms: ['HS256', 'RS256', 'ES256']
                tags:
                    tag_name1: ~
                    tag_name2: {attribute1: 'foo'}
```
