JWE Decryption
==============

Encrypted tokens are loaded by a serializer or the serializer manager and decrypted by the `JWEDecrypter` object.
This JWEDecrypter object requires several services for the process:
* an algorithm manager with key encryption algorithms
* an algorithm manager with content encryption algorithms
* a compression method manager. No compression method is needed if you do not intent to compress the payload.

In the following example, we will use the same assumptions as the ones used during the [JWE Creation process](creation.md).

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\Algorithm\KeyEncryption\A256KW;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A256CBCHS512;
use Jose\Component\Encryption\Compression\CompressionMethodManager;
use Jose\Component\Encryption\Compression\Deflate;
use Jose\Component\Encryption\JWEDecrypter;

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

// We instantiate our JWE Decrypter.
$jweDecrypter = new JWEDecrypter(
    $keyEncryptionAlgorithmManager,
    $contentEncryptionAlgorithmManager,
    $compressionMethodManager
);
```

Now we can try to deserialize and decrypt the input we receive.
We will continue with the result we got during the JWE creation section.

**Note: we do not check header parameters here, but it is very important to do it. This step is described in the Header Checker section.**

```php
<?php

use Jose\Component\Core\Converter\StandardConverter;
use Jose\Component\Core\JWK;
use Jose\Component\Encryption\Serializer\JWESerializerManager;
use Jose\Component\Encryption\Serializer\CompactSerializer;

// Our key.
$jwk = JWK::create([
    'kty' => 'oct',
    'k' => 'dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g',
]);

// The JSON Converter.
$jsonConverter = new StandardConverter();

// The serializer manager. We only use the JWE Compact Serialization Mode.
$serializerManager = JWESerializerManager::create([
    new CompactSerializer($jsonConverter),
]);

// The input we want to decrypt
$token = 'eyJhbGciOiJBMjU2S1ciLCJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiemlwIjoiREVGIn0.9RLpf3Gauf05QPNCMzPcH4XNBLmH0s3e-YWwOe57MTG844gnc-g2ywfXt_R0Q9qsR6WhkmQEhdLk2CBvfqr4ob4jFlvJK0yW.CCvfoTKO9tQlzCvbAuFAJg.PxrDlsbSRcxC5SuEJ84i9E9_R3tCyDQsEPTIllSCVxVcHiPOC2EdDlvUwYvznirYP6KMTdKMgLqxB4BwI3CWtys0fceSNxrEIu_uv1WhzJg.4DnyeLEAfB4I8Eq0UobnP8ymlX1UIfSSADaJCXr3RlU';

// We try to load the token.
$jwe = $serializerManager->unserialize($token);

// We decrypt the token. This method does NOT check the header.
$jwe = $jweDecrypter->decryptUsingKey($jwe, $jwk);
```

OK so if not exception is thrown, then your token is loaded and the payload correctly decrypted.

# JWELoader Object

To avoid duplication of code lines, you can create a `JWELoader` object.
This object contains a serializer, a decrypter and an optional header checker (highly recommended).

In the following example, the `JWELoader` object will try to unserialize the token `$token`, check the header parameters and decrypt with the key `$key`.

If the decryption succeeded, the variable `$recipient` will be set with the recipient index and should be in case of multiple recipients.
The method returns the JWE object.

```php
<?php

use Jose\Component\Encryption\JWELoader;

$jweLoader = new JWELoader(
    $serializerManager,
    $jweDecrypter,
    $headerCheckerManager
);

$jwe = $jweLoader->loadAndDecryptWithKey($token, $key, $recipient);
```

In case you use a key set, you can use the method `loadAndDecryptWithKeySet`.

# JWELoaderFactory Object

The `JWELoaderFactory` object is able to create `JWELoader` objects on demand.
It requires the following factories:

* `JWESerializerManagerFactory`
* `JWEDecrypterFactory`
* `HeaderCheckerManagerFactory` (optional)

```php
<?php

use Jose\Component\Encryption\JWELoaderFactory;

$jweLoaderFactory = new JWELoaderFactory(
    $jweSerializerManagerFactory,
    $jweDecrypterFactory,
    $headerCheckerManagerFactory
);

$jweLoader = $jweLoaderFactory->create(
    ['jwe_compact'], // List of serializer aliases
    ['A128KW'],      // List of key encryption algorithm aliases
    ['A128KW'],      // List of content encryption algorithm aliases
    ['DEF'],         // List of compression method aliases
    ['alg', 'enc']   // Optional list of header checker aliases
);
```
