Signed Token Verification
=========================

# JWS Verifier Factory Service

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

# JWS Verifier As Service

There is also another way to create a JWSVerifier object: using the bundle configuration.

```yaml
jose:
    jws:
        verifiers:
            verifier1:
                signature_algorithms: ['HS256', 'RS256', 'ES256']
                is_public: true
```

With the previous configuration, the bundle will create a public JWS Verifier service named `jose.jws_verifier.verifier1`
with selected signature algorithms.

```php
<?php
$jwsVerifier = $container->get('jose.jws_verifier.verifier1');
```

# Custom Tags

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
