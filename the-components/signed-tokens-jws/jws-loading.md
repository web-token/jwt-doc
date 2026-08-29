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
// - The key,
// - The index of the signature to check.
$isVerified = $jwsVerifier->verifyWithKey($jws, $jwk, 0);
```

The method `verifyWithKey` returns a boolean. If true, then your token signature is valid. You can then check the claims (if any) using the claim checker manager.

## JWSLoader Object

To avoid duplication of code lines, you can create a `JWSLoader` object. This object contains a serializer, a verifier and an optional header checker (highly recommended).

In the following example, the `JWSLoader` object will try to unserialize the token `$token`, check the header parameters and verify the signature with the key `$jwk`. The variable `$payload` corresponds to the detached payload (`null` by default).

If the verification succeeded, the variable `$signature` will be set with the signature index and should be in case of multiple signatures. The method returns the JWS object.

```php
<?php

use Jose\Component\Signature\JWSLoader;

$jwsLoader = new JWSLoader(
    $serializerManager,
    $jwsVerifier,
    $headerCheckerManager
);

$jws = $jwsLoader->loadAndVerifyWithKey($token, $jwk, $signature, $payload);
```

In case you use a key set, you can use the method `loadAndVerifyWithKeySet`.

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

use Throwable;

try {
    $jws = $jwsLoader->loadAndVerifyWithKeySet($token, $jwkset, $signature);
} catch (Throwable $throwable) {
    $this->logger->debug($throwable->getMessage(), [
        'cause' => $throwable->getPrevious()?->getMessage(),
    ]);

    throw $throwable;
}
```

`JWSVerifier` returns a boolean and cannot throw without changing that contract, so its per-key failures are reported through a callable it accepts as an additional argument. It is called once per key that failed:

```php
$isVerified = $jwsVerifier->verifyWithKeySet(
    $jws,
    $jwkset,
    0,
    null,        // Detached payload
    $jwk,        // Set with the key that succeeded
    static function (Throwable $throwable): void {
        // Called for each key that could not verify the signature.
    }
);
```

{% hint style="info" %}
That callable is not declared in the signature of `verifyWithKeySet()` yet — it is read with `func_num_args()`/`func_get_arg(5)` so that classes extending the verifier keep working. It will become part of the signature in 5.0.
{% endhint %}

