JWE Creation
============

We suppose here that you have an algorithm manager and a key.

The computation of a JWE is done by the `JWEBuilder` object.
This object requires the algorithm manager and a JSON converter.
In the following example, we will use the standard converter provided by the framework.

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\Converter\StandardConverter;
use Jose\Component\Core\JWK;
use Jose\Component\Encryption\Algorithm\KeyEncryption\A256KW;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A256CBCHS512;
use Jose\Component\Encryption\Compression\CompressionMethodManager;
use Jose\Component\Encryption\Compression\Deflate;
use Jose\Component\Encryption\JWEBuilder;

// The key encryption algorithm manager with the A256KW algorithm.
$keyEncryptionAlgorithmManager = AlgorithmManager::create([
    new A256KW(),
]);

// The content encryption algorithm manager with the A256CBC-HS256 algorithm.
$contentEncryptionAlgorithmManager = AlgorithmManager::create([
    new A256CBCHS512(),
]);

// The compression method manager with the DEF (Deflate) method.
$compressionMethodManager = CompressionMethodManager::create([
    new Deflate(),
]);

// Our key.
$jwk = JWK::create([
    'kty' => 'oct',
    'k' => 'dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g',
]);

// The JSON Converter.
$jsonConverter = new StandardConverter();

// We instantiate our JWE Builder.
$jweBuilder = new JWEBuilder(
    $jsonConverter,
    $keyEncryptionAlgorithmManager,
    $contentEncryptionAlgorithmManager,
    $compressionMethodManager
);
```

Now let's create our first JWE object.

```php
// The payload we want to encrypt. The payload MUST be a string hence we use our JSON Converter.
$payload = $jsonConverter->encode([
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
        'zip' => 'DEF'            // We enable the compression (irrelevant as the payload is small, just for the example).
    ])
    ->addRecipient($jwk)    // We add a recipient (a shared key or public key).
    ->build();              // We build it
```

Great! If everything is fine you will get a JWE object with one recipient.
We want to send it to the audience. Before that, it must be serialized.

We will use the compact serialization mode.
This is the most common mode as it is URL safe and very compact.
Perfect for a use in a web context!

```php
use Jose\Component\Encryption\Serializer\CompactSerializer;

$serializer = new CompactSerializer($jsonConverter); // The serializer

$token = $serializer->serialize($jwe, 0); // We serialize the recipient at index 0 (we only have one recipient).
```

All good!
The variable `$token` now contains a string that should be something like that: `eyJhbGciOiJBMjU2S1ciLCJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiemlwIjoiREVGIn0.9RLpf3Gauf05QPNCMzPcH4XNBLmH0s3e-YWwOe57MTG844gnc-g2ywfXt_R0Q9qsR6WhkmQEhdLk2CBvfqr4ob4jFlvJK0yW.CCvfoTKO9tQlzCvbAuFAJg.PxrDlsbSRcxC5SuEJ84i9E9_R3tCyDQsEPTIllSCVxVcHiPOC2EdDlvUwYvznirYP6KMTdKMgLqxB4BwI3CWtys0fceSNxrEIu_uv1WhzJg.4DnyeLEAfB4I8Eq0UobnP8ymlX1UIfSSADaJCXr3RlU`.
