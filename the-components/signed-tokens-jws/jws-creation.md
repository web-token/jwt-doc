# JWS Creation

Now that you have an algorithm manager and a key, it is time to create your first signed token.

The computation is done by the `JWSBuilder` object. This object only requires the algorithm manager.

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\JWK;
use Jose\Component\Signature\Algorithm\HS256;
use Jose\Component\Signature\JWSBuilder;

// The algorithm manager with the HS256 algorithm.
$algorithmManager = new AlgorithmManager([
    new HS256(),
]);

// Our key.
$jwk = new JWK([
    'kty' => 'oct',
    'k' => 'dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g',
]);

// We instantiate our JWS Builder.
$jwsBuilder = new JWSBuilder($algorithmManager);
```

Now let's create our first JWS object.

```php
// The payload we want to sign. The payload MUST be a string.
$payload = json_encode([
    'iat' => time(),
    'nbf' => time(),
    'exp' => time() + 3600,
    'iss' => 'My service',
    'aud' => 'Your application',
]);

$jws = $jwsBuilder
    ->withPayload($payload)                  // We set the payload
    ->addSignature($jwk, ['alg' => 'HS256']) // We add a signature with a protected header
    ->build();                               // We build it
```

{% hint style="info" %}
The `addSignature()` method accepts a third optional parameter for unprotected headers:
```php
->addSignature($jwk, ['alg' => 'HS256'], ['kid' => 'key-2023'])
```
where the second parameter is the protected header and the third is the unprotected header.
{% endhint %}

## Already Encoded Payloads

Sometimes the payload you hold is already Base64Url encoded. GNAP request signing is such a case: the payload is the Base64Url encoded SHA-256 hash of the request body.

Passing that string to `withPayload()` would encode it a second time and silently produce a token nobody expects. Use `withEncodedPayload()` instead: it takes the payload in the form you already have it.

```php
$jws = $jwsBuilder
    ->withEncodedPayload($base64UrlEncodedHash) // Not encoded again
    ->addSignature($jwk, ['alg' => 'HS256'])
    ->build();
```

The value is validated as strictly as the `CompactSerializer` validates a token it loads: padding, characters outside the Base64Url alphabet, impossible lengths and non-canonical trailing bits are rejected with an `InvalidArgumentException`. The builder can therefore never emit a token the library itself would refuse to read back.

Like `withPayload()`, the method accepts a second argument to mark the payload as [detached](../../advanced-topics/signed-tokens/detached-payload.md).

{% hint style="warning" %}
An encoded payload contradicts the [unencoded payload option](../../advanced-topics/signed-tokens/unencoded-payload.md) (`b64` set to `false`), which removes the encoding altogether. The combination is rejected whichever order the two are set in.
{% endhint %}

## The Builder Is Immutable

Every `with*()` and `addSignature()` call returns a **new** builder and leaves the receiver untouched, so a configured builder can be kept and derived from as many times as needed:

```php
$base = $jwsBuilder->withPayload($payload);

$first  = $base->addSignature($key1, ['alg' => 'HS256'])->build();
$second = $base->addSignature($key2, ['alg' => 'RS256'])->build(); // $base is unchanged
```

The checks that span several calls — the `b64` consistency in particular — are performed by `build()`, so **the order of the calls does not matter**.

{% hint style="warning" %}
Until 4.2 the builder accumulated its state on the receiver, which is why `create()` existed: not as a named constructor, but as a reset. Since 4.3 there is no state to reset and `create()` is deprecated — remove the call. It is removed in 5.0.
{% endhint %}

## Serialization

Great! If everything is fine you will get a JWS object with one signature. We want to send it to the audience. Before that, it must be serialized.

We will use the compact serialization mode. This is the most common mode as it is URL safe and very compact. Perfect for a use in a web context!

```php
use Jose\Component\Signature\Serializer\CompactSerializer;

$serializer = new CompactSerializer(); // The serializer

$token = $serializer->serialize($jws, 0); // We serialize the signature at index 0 (we only have one signature).
```

All good! The variable `$token` now contains a string that should be something like this:

```
eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1MDc4OTY5OTIsIm5iZiI6MTUwNzg5Njk5MiwiZXhwIjoxNTA3OTAwNTkyLCJpc3MiOiJNeSBzZXJ2aWNlIiwiYXVkIjoiWW91ciBhcHBsaWNhdGlvbiJ9.eycp9PTdgO4WA-68-AMoHPwsKDr68NhjIQKz4lUkiI0
```

Other serialization modes exist. We will see them in the Advanced Topics section.
