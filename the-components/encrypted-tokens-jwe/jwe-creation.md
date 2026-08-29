# JWE Creation

The computation of a JWE is done by the `JWEBuilder` object. This object requires an algorithm manager with both key encryption and content encryption algorithms.

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\Algorithm\KeyEncryption\A256KW;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A256CBCHS512;
use Jose\Component\Encryption\JWEBuilder;

// The algorithm manager with both key encryption and content encryption algorithms.
$algorithmManager = new AlgorithmManager([
    new A256KW(),        // Key Encryption Algorithm
    new A256CBCHS512(),  // Content Encryption Algorithm
]);

// We instantiate our JWE Builder.
$jweBuilder = new JWEBuilder($algorithmManager);
```

{% hint style="danger" %}
Compression is not recommended. Please avoid its use. See [RFC8725](https://datatracker.ietf.org/doc/html/rfc8725#section-3.6) for more information.
{% endhint %}

Now let's create our first JWE object.

```php
use Jose\Component\Core\JWK;

// Our key.
$jwk = new JWK([
    'kty' => 'oct',
    'k' => 'dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g',
]);

// The payload we want to encrypt. It MUST be a string.
$payload = json_encode([
    'iat' => time(),
    'nbf' => time(),
    'exp' => time() + 3600,
    'iss' => 'My service',
    'aud' => 'Your application',
]);

$jwe = $jweBuilder
    ->create()              // We want to create a new JWE
    ->withPayload($payload) // We set the payload
    ->withSharedProtectedHeader([
        'alg' => 'A256KW',        // Key Encryption Algorithm
        'enc' => 'A256CBC-HS512', // Content Encryption Algorithm
    ])
    ->addRecipient($jwk)    // We add a recipient (a shared key or public key).
    ->build();              // We build it
```

## Static Key Agreement (ECDH-SS)

The `ECDH-SS*` algorithms derive the agreement key from two **static** keys: no ephemeral key pair is generated, so no `epk` header parameter is added to the token and the recipient has to know the public key of the sender.

Give the private key of the sender to the builder with `withSenderKey()`:

```php
$jwe = $jweBuilder
    ->create()
    ->withPayload($payload)
    ->withSharedProtectedHeader([
        'alg' => 'ECDH-SS',
        'enc' => 'A128CBC-HS256',
    ])
    ->withSenderKey($senderPrivateKey)              // Your own private key
    ->addRecipient($recipientPublicKey)             // The key of the recipient
    ->build();
```

The sender key does not add a recipient, so it may be set before or after `addRecipient()`. It is checked by `build()`, once the recipients and the content encryption algorithm are known. A direct static key agreement without a sender key fails with `The sender key shall be set`.

{% hint style="info" %}
The decryption side needs both keys too, with the roles swapped. See [JWE Loading](jwe-loading.md#static-key-agreement).
{% endhint %}

## Header Parameters

[RFC 7516 section 7.2.1](https://datatracker.ietf.org/doc/html/rfc7516#section-7.2.1) requires the header parameter names of the shared protected header, the shared unprotected header and the per-recipient headers to be **disjoint**. The builder rejects a token that would repeat a parameter across two of those locations.

The parameters computed by the key encryption algorithm itself — `epk`, `iv`, `tag`, `p2s`, `p2c`… — are filtered out of the per-recipient header when you already set them in a shared header, so setting e.g. `p2c` in the shared protected header of a multi-recipient `PBES2` token is safe.

## Serialization

Great! If everything is fine you will get a JWE object with one recipient. We want to send it to the audience. Before that, it must be serialized.

We will use the compact serialization mode. This is the most common mode as it is URL safe and very compact. Perfect for a use in a web context!

```php
use Jose\Component\Encryption\Serializer\CompactSerializer;

$serializer = new CompactSerializer(); // The serializer

$token = $serializer->serialize($jwe, 0); // We serialize the recipient at index 0 (we only have one recipient).
```

All good! The variable `$token` now contains a string that should be something like that:

```php
eyJhbGciOiJBMjU2S1ciLCJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiemlwIjoiREVGIn0.9RLpf3Gauf05QPNCMzPcH4XNBLmH0s3e-YWwOe57MTG844gnc-g2ywfXt_R0Q9qsR6WhkmQEhdLk2CBvfqr4ob4jFlvJK0yW.CCvfoTKO9tQlzCvbAuFAJg.PxrDlsbSRcxC5SuEJ84i9E9_R3tCyDQsEPTIllSCVxVcHiPOC2EdDlvUwYvznirYP6KMTdKMgLqxB4BwI3CWtys0fceSNxrEIu_uv1WhzJg.4DnyeLEAfB4I8Eq0UobnP8ymlX1UIfSSADaJCXr3RlU
```
