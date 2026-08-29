# JWS Loading

Signed tokens are loaded by a serializer or the serializer manager and verified by the `JWSVerifier` object. This JWSVerifier object just requires an algorithm manager.

## Serializer And Verifier

In the following example, we will try to load a signed token. We will only use the `HS256` algorithm.

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Signature\Algorithm\HS256;
use Jose\Component\Signature\JWSVerifier;

// The algorithm manager with the HS256 algorithm.
$algorithmManager = new AlgorithmManager([
    new HS256(),
]);

// We instantiate our JWS Verifier.
$jwsVerifier = new JWSVerifier(
    $algorithmManager
);
```

Now we can deserialize the input we receive and check the signature using our key. We will continue with the data we got in the JWS creation section.

{% hint style="danger" %}
We do not check header parameters here, but it is very important to do it. This step is described in the [Header Checker section](../header-checker.md).
{% endhint %}

```php
<?php

use Jose\Component\Core\JWK;
use Jose\Component\Signature\Serializer\JWSSerializerManager;
use Jose\Component\Signature\Serializer\CompactSerializer;

// Our key.
$jwk = new JWK([
    'kty' => 'oct',
    'k' => 'dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g',
]);

// The serializer manager. We only use the JWS Compact Serialization Mode.
$serializerManager = new JWSSerializerManager([
    new CompactSerializer(),
]);

// The input we want to check
$token = 'eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1MDc4OTY5OTIsIm5iZiI6MTUwNzg5Njk5MiwiZXhwIjoxNTA3OTAwNTkyLCJpc3MiOiJNeSBzZXJ2aWNlIiwiYXVkIjoiWW91ciBhcHBsaWNhdGlvbiJ9.eycp9PTdgO4WA-68-AMoHPwsKDr68NhjIQKz4lUkiI0';

// We try to load the token.
$jws = $serializerManager->unserialize($token);

// We verify the signature. This method does NOT check the header.
// The arguments are:
// - The JWS object,
// - The key or the key set,
// - The index of the signature to check.
$result = $jwsVerifier->verify($jws, $jwk, 0);
```

`verify()` returns a `VerificationResult`:

```php
$result->isVerified();        // bool — true when the signature is valid
$result->getSignatureIndex(); // int — the index of the signature that was checked
$result->getKey();            // ?JWK — the key that verified it, null on failure
```

If the signature is valid, you can then check the claims (if any) using the claim checker manager.

The second argument accepts a `JWK` as well as a `JWKSet`; when a key set is given, every key is tried until one verifies the signature, and `getKey()` tells you which one did.

{% hint style="info" %}
`verifyWithKey()` still exists and is not deprecated: it takes a single key and returns a boolean, with no output parameter. `verifyWithKeySet()`, which wrote the successful key into a variable of the caller, is deprecated since 4.3 in favour of `verify()`.
{% endhint %}

## JWSLoader Object

To avoid duplication of code lines, you can create a `JWSLoader` object. This object contains a serializer, a verifier and an optional header checker (highly recommended).

In the following example, the `JWSLoader` object will try to unserialize the token `$token`, check the header parameters and verify the signature with the key `$jwk`. The third argument corresponds to the detached payload (`null` by default).

```php
<?php

use Jose\Component\Signature\JWSLoader;

$jwsLoader = new JWSLoader(
    $serializerManager,
    $jwsVerifier,
    $headerCheckerManager
);

$result = $jwsLoader->loadAndVerify($token, $jwk, $payload);

$jws       = $result->getJws();
$signature = $result->getSignatureIndex(); // Useful with multiple signatures
$key       = $result->getKey();            // The key that verified the signature
```

`loadAndVerify()` accepts a `JWK` as well as a `JWKSet`, and throws when the token cannot be loaded or verified.

{% hint style="warning" %}
`loadAndVerifyWithKey()` and `loadAndVerifyWithKeySet()` wrote the signature index into a variable of the caller. They are deprecated since 4.3 and removed in 5.0: use `loadAndVerify()`, which carries that index in its result. See the [migration guide](../../migration/from-v4.2-to-v4.3.md#result-objects-instead-of-output-parameters).
{% endhint %}

## JWSLoaderFactory Object

The `JWSLoaderFactory` object is able to create `JWSLoader` objects on demand. It requires the following factories:

* `JWSSerializerManagerFactory`
* `JWSVerifierFactory`
* `HeaderCheckerManagerFactory` (optional)

```php
<?php

use Jose\Component\Signature\JWSLoaderFactory;

$jwsLoaderFactory = new JWSLoaderFactory(
    $jwsSerializerManagerFactory,
    $jwsVerifierFactory,
    $headerCheckerManagerFactory
);

$jwsLoader = $jwsLoaderFactory->create(
    ['jws_compact'], // List of serializer aliases
    ['HS256'],       // List of signature algorithm aliases
    ['alg']          // Optional list of header checker aliases
);
```

## Understanding Failures

When a token cannot be loaded or verified, the loaders and the serializer manager chain the last error met along the way as the previous exception. The message of the outer exception stays generic on purpose — it is the one you may safely show — while the cause tells you what actually happened:

```php
<?php

use Jose\Component\Core\Exception\JoseException;

try {
    $result = $jwsLoader->loadAndVerify($token, $jwkset);
} catch (JoseException $throwable) {
    $this->logger->debug($throwable->getMessage(), [
        'cause' => $throwable->getPrevious()?->getMessage(),
    ]);

    throw $throwable;
}
```

Every exception thrown by the framework implements `JoseException`, so a single catch block handles any failure. Each of them extends the SPL exception that was thrown at that place before 4.3, hence catch blocks written for previous versions keep matching.

`JWSVerifier` reports a failure through its result rather than an exception, so the per-key failures it meets while trying a key set are reported through an optional callable. It is called once per key that failed:

```php
$result = $jwsVerifier->verify(
    $jws,
    $jwkset,
    0,
    null, // Detached payload
    static function (Throwable $throwable): void {
        // Called for each key that could not verify the signature.
    }
);
```

