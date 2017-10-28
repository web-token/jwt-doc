JWE Loading
===========

Encrypted tokens are loaded by a serializer or the serializer manager and decrypted by the `JWEDecrypter` object.
This JWEDecrypter object requires several services for the process:
* an algorithm manager
* a header checker manager

In the following example, we will use the same assumptions as the ones used during the [JWS Creation process](creation.md).

```php
<?php

require_once 'vendor/autoload.php';

use Jose\Component\Checker\HeaderCheckerManager;
use Jose\Component\Checker;
use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\Converter\JsonConverter;
use Jose\Component\Core\JWK;
use Jose\Component\Encryption\Algorithm\KeyEncryption\A256KW;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A256CBCHS512;
use Jose\Component\Encryption\Compression\CompressionMethodManager;
use Jose\Component\Encryption\Compression\Deflate;
use Jose\Component\Encryption\JWEDecrypter;
use Jose\Component\Encryption\JWETokenSupport;

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

// The header checker manager
$headerCheckerManager = HeaderCheckerManager::create(
    [
        new Checker\AlgorithmChecker(['A256KW']), // We only want to check the key encryption algorithm.
                                                  // Feel free to add more header checkers here
    ],
    [
        new JWETokenSupport(), // We add the JWE Token type (this manager is able to support other token types.
    ]
);

// Our key.
$jwk = JWK::create([
    'kty' => 'oct',
    'k' => 'dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g',
]);

// The JSON Converter.
$jsonConverter = new JsonConverter();

// The serializer manager. We only use the JWS Compact Serialization Mode.
$serializerManager = JWESerializerManager::create([
    new CompactSerializer($jsonConverter),
]);

// We instantiate our JWE Decrypter.
$jweDecrypter = new JWEDecrypter(
    $keyEncryptionAlgorithmManager,
    $contentEncryptionAlgorithmManager,
    $compressionMethodManager,
    $headerCheckerManager
);
```

Now we can use it with the input we receive. We will continue with the result we got during the JWS creation section.

```php
// The input we want to decrypt
$token = 'eyJhbGciOiJBMjU2S1ciLCJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiemlwIjoiREVGIn0.9RLpf3Gauf05QPNCMzPcH4XNBLmH0s3e-YWwOe57MTG844gnc-g2ywfXt_R0Q9qsR6WhkmQEhdLk2CBvfqr4ob4jFlvJK0yW.CCvfoTKO9tQlzCvbAuFAJg.PxrDlsbSRcxC5SuEJ84i9E9_R3tCyDQsEPTIllSCVxVcHiPOC2EdDlvUwYvznirYP6KMTdKMgLqxB4BwI3CWtys0fceSNxrEIu_uv1WhzJg.4DnyeLEAfB4I8Eq0UobnP8ymlX1UIfSSADaJCXr3RlU';

// We try to load the token.
$jwe = $serializerManager->unserialize($token);

// We decrypt the token. This method also check the headers
$jwe = $jweDecrypter->decryptUsingKey($jwe, $jwk);
```

OK so if not exception is thrown, then your token is correctly loaded, its header are verified and the payload correctly decrypted.

Now we want to check the claims.
The payload returned by the `$jwe` variable is a string.
We need to retrieve an array first.

```php
$claims = $jsonConverter->decode(
    $jwe->getPayload()
);

// Our signed tokens must contain claims that have to be checked
if (!is_array($claims)) {
    throw new \InvalidArgumentException('Something went wrong.');
}

$claimChecker = Checker\ClaimCheckerManager::create(
    [
        new Checker\IssuedAtChecker(),
        new Checker\NotBeforeChecker(),
        new Checker\ExpirationTimeChecker(),
    ]
);

$claimChecker->check($claims);
```

If all the checks succeeded, the variable `$claims` will contain all the claims in the payload, even those that have not been verified.

**Be careful**: in this example, we did not checked all claims (`iss` and `aud` claim checkers are missing).
In production, each claim you use should be checked hence it is important to add necessary checkers to your claim checker manager.
