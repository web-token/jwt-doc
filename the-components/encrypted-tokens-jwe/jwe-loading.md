# JWE Loading

Encrypted tokens are loaded by a serializer or the serializer manager and decrypted by the `JWEDecrypter` object. This JWEDecrypter object requires an algorithm manager with both key encryption and content encryption algorithms.

In the following example, we will use the same assumptions as the ones used during the [JWE Creation process](jwe-creation.md).

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\Algorithm\KeyEncryption\A256KW;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A256CBCHS512;
use Jose\Component\Encryption\JWEDecrypter;

// The algorithm manager with both key encryption and content encryption algorithms.
$algorithmManager = new AlgorithmManager([
    new A256KW(),        // Key Encryption Algorithm
    new A256CBCHS512(),  // Content Encryption Algorithm
]);

// We instantiate our JWE Decrypter.
$jweDecrypter = new JWEDecrypter($algorithmManager);
```

Now we can try to deserialize and decrypt the input we receive. We will continue with the result we got during the JWE creation section.

{% hint style="danger" %}
We do not check header parameters here, but it is very important to do it. This step is described in the [Header Checker](../header-checker.md) section.
{% endhint %}

```php
<?php

use Jose\Component\Core\JWK;
use Jose\Component\Encryption\Serializer\JWESerializerManager;
use Jose\Component\Encryption\Serializer\CompactSerializer;

// Our key.
$jwk = new JWK([
    'kty' => 'oct',
    'k' => 'dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g',
]);

// The serializer manager. We only use the JWE Compact Serialization Mode.
$serializerManager = new JWESerializerManager([
    new CompactSerializer(),
]);

// The input we want to decrypt
$token = 'eyJhbGciOiJBMjU2S1ciLCJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiemlwIjoiREVGIn0.9RLpf3Gauf05QPNCMzPcH4XNBLmH0s3e-YWwOe57MTG844gnc-g2ywfXt_R0Q9qsR6WhkmQEhdLk2CBvfqr4ob4jFlvJK0yW.CCvfoTKO9tQlzCvbAuFAJg.PxrDlsbSRcxC5SuEJ84i9E9_R3tCyDQsEPTIllSCVxVcHiPOC2EdDlvUwYvznirYP6KMTdKMgLqxB4BwI3CWtys0fceSNxrEIu_uv1WhzJg.4DnyeLEAfB4I8Eq0UobnP8ymlX1UIfSSADaJCXr3RlU';

// We try to load the token.
$jwe = $serializerManager->unserialize($token);

// We decrypt the token. This method does NOT check the header.
$success = $jweDecrypter->decryptUsingKey($jwe, $jwk, 0);
```

OK so if no exception is thrown, then your token is loaded and the payload correctly decrypted.

## JWELoader Object

To avoid duplication of code lines, you can create a `JWELoader` object. This object contains a serializer, a decrypter and an optional header checker (highly recommended).

In the following example, the `JWELoader` object will try to unserialize the token `$token`, check the header parameters and decrypt with the key `$key`.

If the decryption succeeded, the variable `$recipient` will be set with the recipient index and should be in case of multiple recipients. The method returns the JWE object.

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

## JWELoaderFactory Object

The `JWELoaderFactory` object is able to create `JWELoader` objects on demand. It requires the following factories:

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
    ['jwe_compact'],           // List of serializer aliases
    ['A256KW', 'A256CBCHS512'], // List of encryption algorithm aliases (both key and content)
    ['alg', 'enc']             // Optional list of header checker aliases
);
```

## Header Validation

[RFC 7516 section 7.2.1](https://datatracker.ietf.org/doc/html/rfc7516#section-7.2.1) requires the header parameter names of the three locations — shared protected header, shared unprotected header and per-recipient header — to be **disjoint**. The `JWEDecrypter` enforces it and rejects a token that repeats a parameter across two locations.

Two consequences are worth knowing:

* the protected header always wins. An unprotected parameter can never override an integrity protected one, `alg` and `enc` included;
* `alg` and `enc` are never read from the **shared unprotected** header. That header is not covered by the AAD and, unlike the per-recipient header, nothing requires those parameters to be located there. Put them in the shared protected header.

{% hint style="warning" %}
This is enforced since 4.2. Tokens built like the [RFC 7520](https://datatracker.ietf.org/doc/html/rfc7520) sections 5.11 and 5.12 vectors are still parsed, but are no longer decrypted. See the [migration guide](../../migration/from-v4.1-to-v4.2.md#stricter-header-validation-on-decryption).
{% endhint %}

This validation is not a substitute for the [Header Checker](../header-checker.md): it only checks where the parameters are, not what they contain.

## Static Key Agreement

The `ECDH-SS*` algorithms derive the agreement key from two **static** keys, so no `epk` header parameter is present in the token and the decrypter must be given both keys.

Beware that the roles are swapped compared to the [creation side](jwe-creation.md#static-key-agreement-ecdh-ss): the key used to decrypt is the **public key of the sender**, and the additional key is the **private key of the recipient**.

```php
$success = $jweDecrypter->decryptUsingKey(
    $jwe,
    $senderPublicKey,     // The key of the sender
    0,
    $recipientPrivateKey  // Your own private key
);
```

## Understanding Failures

When a token cannot be loaded or decrypted, the loaders and the serializer manager chain the last error met along the way as the previous exception:

```php
<?php

use Throwable;

try {
    $jwe = $jweLoader->loadAndDecryptWithKeySet($token, $jwkset, $recipient);
} catch (Throwable $throwable) {
    $this->logger->debug($throwable->getMessage(), [
        'cause' => $throwable->getPrevious()?->getMessage(),
    ]);

    throw $throwable;
}
```

`JWEDecrypter` returns a boolean and cannot throw without changing that contract, so its per-key failures are reported through a callable it accepts as an additional argument. It is called once per key that failed:

```php
$success = $jweDecrypter->decryptUsingKeySet(
    $jwe,
    $jwkset,
    0,
    $jwk,        // Set with the key that succeeded
    $senderKey,  // Static key agreement only, see "Static Key Agreement" below
    static function (Throwable $throwable): void {
        // Called for each key that could not decrypt the token.
    }
);
```

{% hint style="info" %}
That callable is not declared in the signature of `decryptUsingKeySet()` yet — it is read with `func_num_args()`/`func_get_arg(5)` so that classes extending the decrypter keep working. It will become part of the signature in 5.0.
{% endhint %}

