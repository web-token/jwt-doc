# JWS verification

## JWS Verifier Factory Service

A `JWSVerifierFactory` is available as a service in your application container:

```php
<?php
use Jose\Component\Signature\JWSVerifierFactory;

$jwsVerifierFactory = $container->get(JWSVerifierFactory::class);
```

With this factory, you will be able to create the JWSVerifier you need:

```php
$jwsVerifier = $jwsVerifierFactory->create(['HS256']);
```

You can now use the JWSVerifier as explained in the JWS Creation section.

**Reminder: it is important to check the token headers. See the checker section of this documentation.**

## JWS Verifier As Service

There is also another way to create a JWSVerifier object: using the bundle configuration.

```yaml
jose:
    jws:
        verifiers:
            verifier1:
                signature_algorithms: ['HS256', 'RS256', 'ES256']
                is_public: true
```

With the previous configuration, the bundle will create a public JWS Verifier service named `jose.jws_verifier.verifier1` with selected signature algorithms.

```php
<?php
$jwsVerifier = $container->get('jose.jws_verifier.verifier1');
```

## Custom Tags

> This feature was introduced in version 1.1.

You can add custom tags and attributes to the services you create.

```yaml
jose:
    jws:
        verifiers:
            verifier1:
                signature_algorithms: ['HS256', 'RS256', 'ES256']
                tags:
                    tag_name1: ~
                    tag_name2: {attribute1: 'foo'}
```

## JWS Loader Service

> This feature was introduced in version 1.1.

The [`JWSLoaderFactory`](../../the-components/signed-tokens-jws/jws-loading.md) is available as a public service. You can retrieve it using the container or inject it into your services. It will help you to create `JWSLoader` objects on demand.

```php
<?php
use Jose\Component\Signature\JWSLoaderFactory;

$jwsLoaderFactory = $container->get(JWSLoaderFactory::class);
```

You can also create `JWSLoader` objects as services using the configuration of the bundle.

```yaml
jose:
    jws:
        loaders:
            jws_loader1:
                serializers: ['jws_compact']
                signature_algorithms: ['HS256']
                header_checkers: ['alg']
                is_public: true
```

Or using the [`ConfigurationHelper`](../configuration-helper.md).

```php
<?php
use Jose\Bundle\JoseFramework\Helper\ConfigurationHelper;

...
ConfigurationHelper::addJWSLoader($container, 'jws_loader1', ['jws_compact'], ['HS256'], ['alg'], true);
```

