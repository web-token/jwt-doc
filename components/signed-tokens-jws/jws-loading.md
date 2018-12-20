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
$algorithmManager = AlgorithmManager::create([
    new HS256(),
]);

// We instantiate our JWS Verifier.
$jwsVerifier = new JWSVerifier(
    $algorithmManager
);
```

Now we can deserialize the input we receive and check the signature using our key. We will continue with the data we got in the JWS creation section.

**Note: we do not check header parameters here, but it is very important to do it. This step is described in the Header Checker section.**

```php
<?php

use Jose\Component\Core\Converter\StandardConverter;
use Jose\Component\Core\JWK;
use Jose\Component\Signature\Serializer\JWSSerializerManager;
use Jose\Component\Signature\Serializer\CompactSerializer;

// Our key.
$jwk = JWK::create([
    'kty' => 'oct',
    'k' => 'dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g',
]);

// The JSON Converter.
$jsonConverter = new StandardConverter();

// The serializer manager. We only use the JWS Compact Serialization Mode.
$serializerManager = JWSSerializerManager::create([
    new CompactSerializer($jsonConverter),
]);

// The input we want to check
$token = 'eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1MDc4OTY5OTIsIm5iZiI6MTUwNzg5Njk5MiwiZXhwIjoxNTA3OTAwNTkyLCJpc3MiOiJNeSBzZXJ2aWNlIiwiYXVkIjoiWW91ciBhcHBsaWNhdGlvbiJ9.eycp9PTdgO4WA-68-AMoHPwsKDr68NhjIQKz4lUkiI0';

// We try to load the token.
$jws = $serializerManager->unserialize($token);

// We verify the signature. This method does NOT check the header.
// The arguments are:
// - The JWS object,
// - The key,
// - The index of the signature to check. See 
$isVerified = $jwsVerifier->verifyWithKey($jws, $jwk, 0);
```

The method `verifyWithKey` returns a boolean. If true, then your token signature is valid. You can then check the claims \(if any\) using the claim checker manager.

## JWSLoader Object

To avoid duplication of code lines, you can create a `JWSLoader` object. This object contains a serializer, a verifier and an optional header checker \(highly recommended\).

In the following example, the `JWSLoader` object will try to unserialize the token `$token`, check the header parameters and verify the signature with the key `$jwk`. The variable `$payload` corresponds to the detached payload \(`null` by default\).

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

> This feature was introduced in version 1.1.

The `JWSLoaderFactory` object is able to create `JWSLoader` objects on demand. It requires the following factories:

* `JWSSerializerManagerFactory`
* `JWSVerifierFactory`
* `HeaderCheckerManagerFactory` \(optional\)

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

