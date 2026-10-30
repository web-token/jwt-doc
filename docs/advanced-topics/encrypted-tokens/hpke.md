# HPKE (Hybrid Public Key Encryption)

Since 4.3, the library implements [draft-ietf-jose-hpke-encrypt](https://datatracker.ietf.org/doc/draft-ietf-jose-hpke-encrypt/), which brings HPKE ([RFC 9180](https://www.rfc-editor.org/rfc/rfc9180.html), revised by [draft-ietf-hpke-hpke](https://datatracker.ietf.org/doc/draft-ietf-hpke-hpke/)) to JWE. HPKE encrypts to a public key with a KEM, a KDF and an AEAD, and is the building block of the post-quantum JOSE work to come.

!!! info

    The specification is approved and waits in the RFC Editor queue for the publication of the HPKE revision it depends on. The fourteen algorithm identifiers and the `ek` and `psk_id` header parameters are already registered by IANA.

## Two key management modes

The specification defines two families of algorithms. Each identifier names a complete cipher suite: the key, the KEM, the KDF and the AEAD are all fixed by the `alg` value.

**Integrated Encryption** — `HPKE-0` to `HPKE-7`. HPKE encrypts the payload itself: there is no CEK and no content encryption algorithm.

* the `enc` header parameter is absent, and `alg` is in the protected header;
* the JWE has exactly one recipient, whose encrypted key is the HPKE encapsulated key;
* the IV and the authentication tag are empty: the ciphertext carries the HPKE tag;
* the protected header and the JWE AAD are authenticated by HPKE, as they are by a content encryption algorithm.

**Key Encryption** — `HPKE-0-KE`, `HPKE-1-KE`, `HPKE-2-KE`, `HPKE-3-KE`, `HPKE-5-KE` and `HPKE-7-KE`. HPKE encrypts the CEK of a regular content encryption algorithm (`enc`).

* the encapsulated key is the `ek` header parameter, added by the algorithm;
* the `enc` value is bound to the encrypted key: a CEK encrypted for `A128GCM` cannot be decrypted for `A256GCM`;
* the recipients can be combined with any other Key Encryption or Key Wrapping recipient of a JWE JSON Serialization.

| `alg` | Mode | KEM | KDF | AEAD | Key |
|---|---|---|---|---|---|
| `HPKE-0`<br>`HPKE-0-KE` | Integrated<br>Key Encryption | DHKEM(P-256, HKDF-SHA256) | HKDF-SHA256 | AES-128-GCM | `EC`, `P-256` |
| `HPKE-1`<br>`HPKE-1-KE` | Integrated<br>Key Encryption | DHKEM(P-384, HKDF-SHA384) | HKDF-SHA384 | AES-256-GCM | `EC`, `P-384` |
| `HPKE-2`<br>`HPKE-2-KE` | Integrated<br>Key Encryption | DHKEM(P-521, HKDF-SHA512) | HKDF-SHA512 | AES-256-GCM | `EC`, `P-521` |
| `HPKE-3`<br>`HPKE-3-KE` | Integrated<br>Key Encryption | DHKEM(X25519, HKDF-SHA256) | HKDF-SHA256 | AES-128-GCM | `OKP`, `X25519` |
| `HPKE-4` | Integrated | DHKEM(X25519, HKDF-SHA256) | HKDF-SHA256 | ChaCha20Poly1305 | `OKP`, `X25519` |
| `HPKE-5`<br>`HPKE-5-KE` | Integrated<br>Key Encryption | DHKEM(X448, HKDF-SHA512) | HKDF-SHA512 | AES-256-GCM | `OKP`, `X448` |
| `HPKE-6` | Integrated | DHKEM(X448, HKDF-SHA512) | HKDF-SHA512 | ChaCha20Poly1305 | `OKP`, `X448` |
| `HPKE-7`<br>`HPKE-7-KE` | Integrated<br>Key Encryption | DHKEM(P-256, HKDF-SHA256) | HKDF-SHA256 | AES-256-GCM | `EC`, `P-256` |

The classes live in `Jose\Component\Encryption\Algorithm\KeyEncryption`: `HPKE0` to `HPKE7`, and `HPKE0KE`, `HPKE1KE`, `HPKE2KE`, `HPKE3KE`, `HPKE5KE` and `HPKE7KE`.

### Platform requirements

| Suites | Requirement |
|---|---|
| P-256, P-384, P-521 | OpenSSL |
| X25519 | The `sodium` extension, or OpenSSL on PHP 8.4+ |
| X448 | PHP 8.4+ (OpenSSL) |
| ChaCha20Poly1305 (`HPKE-4`, `HPKE-6`) | An OpenSSL library providing the cipher |

`HPKE0::isSupported()` (and its siblings) tells whether the platform can run an algorithm; the constructor throws a `MissingDependencyException` when it cannot, and the Symfony Bundle registers an algorithm only when it can run.

## Integrated Encryption

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\Algorithm\KeyEncryption\HPKE3;
use Jose\Component\Encryption\JWEBuilder;
use Jose\Component\Encryption\JWEDecrypter;
use Jose\Component\Encryption\Serializer\CompactSerializer;
use Jose\Component\KeyManagement\JWKFactory;

$recipientKey = (new JWKFactory())->okp('X25519', ['alg' => 'HPKE-3', 'use' => 'enc']);
$algorithmManager = new AlgorithmManager([new HPKE3()]);

$jwe = (new JWEBuilder($algorithmManager))
    ->withPayload('The payload')
    ->withSharedProtectedHeader(['alg' => 'HPKE-3']) // No "enc"
    ->addRecipient($recipientKey->toPublic())
    ->build();
$token = (new CompactSerializer())->serialize($jwe, 0);

$result = (new JWEDecrypter($algorithmManager))
    ->decrypt((new CompactSerializer())->unserialize($token), $recipientKey, 0);
$result->getJwe()->getPayload(); // "The payload"
```

The builder and the decrypter refuse a JWE that does not follow the rules of the mode: an `enc` header parameter, an `alg` outside the protected header, a second recipient, a non-empty IV or tag.

With the JWE JSON Serialization, an additional authenticated data (`withAAD()`) is authenticated by HPKE. The `iv` and `tag` members are absent from the JSON, as RFC 7516 requires for empty values.

## Key Encryption

A Key Encryption algorithm is used like any other key encryption algorithm, with a content encryption algorithm:

```php
<?php

$jwe = $jweBuilder
    ->withPayload('The payload')
    ->withSharedProtectedHeader(['alg' => 'HPKE-0-KE', 'enc' => 'A128GCM'])
    ->addRecipient($p256Key->toPublic())
    ->build();
```

The `ek` header parameter is computed by the algorithm: do not set it. With a single recipient it lands in the protected header; with several recipients, in the header of each recipient:

```php
<?php

$jwe = $jweBuilder
    ->withPayload('The payload')
    ->withSharedProtectedHeader(['enc' => 'A256GCM'])
    ->addRecipient($p256Key->toPublic(), ['alg' => 'HPKE-0-KE'])
    ->addRecipient($x25519Key->toPublic(), ['alg' => 'HPKE-3-KE'])
    ->addRecipient($rsaKey->toPublic(), ['alg' => 'RSA-OAEP-256'])
    ->build(); // To be serialized with the JWE JSON General Serialization
```

## Pre-shared key

HPKE has a second mode, `mode_psk`, in which the sender also proves the possession of a key shared with the recipient. The mode is selected by the `psk_id` header parameter, the base64url encoding of the identifier of that key, and the key itself is given as the **sender key**, on both sides:

```php
<?php

use Jose\Component\Core\Util\Base64UrlSafe;
use Jose\Component\KeyManagement\JWKFactory;

$psk = (new JWKFactory())->oct(256, ['kid' => 'psk-2026']); // Shared with the recipient beforehand

$jwe = $jweBuilder
    ->withPayload('The payload')
    ->withSharedProtectedHeader([
        'alg' => 'HPKE-3',
        'psk_id' => Base64UrlSafe::encodeUnpadded('psk-2026'),
    ])
    ->withSenderKey($psk)
    ->addRecipient($recipientKey->toPublic())
    ->build();

$result = $jweDecrypter->decrypt($jwe, $recipientKey, 0, $psk);
```

* The pre-shared key is a symmetric key (`kty: oct`) of at least 32 bytes. When it has a `kid`, it must be the identifier carried by `psk_id`.
* A pre-shared key given to the decrypter is always used: a token without `psk_id` is not decrypted. Anyone holding the public key of the recipient can produce a token in the base mode, so accepting one where the sender is expected to be authenticated would defeat the purpose.
* The sender key is shared by all the recipients of a JWE.
* `JWELoader` does not take a sender key: decrypt such tokens with the `JWEDecrypter`, as for `ECDH-SS`.

## Application information

The specification lets the application bind mutually known private information to the encryption: the HPKE `info` of Integrated Encryption, the `recipient_extra_info` of Key Encryption. Both are empty by default. Give the value to the constructor of the algorithm, with the same value on both sides:

```php
<?php

use Jose\Component\Encryption\Algorithm\KeyEncryption\HPKE0KE;
use Jose\Component\Encryption\Algorithm\KeyEncryption\HPKE3;

$integrated = new HPKE3('mutually known private information');
$keyEncryption = new HPKE0KE('mutually known private information');
```

In the Symfony Bundle, the algorithms are registered with the default value. To use another one, declare your own service and tag it with `jose.algorithm` and the alias of the algorithm.

## Symfony Bundle

The algorithms are registered under their identifiers when the platform can run them:

```yaml
jose:
    jwe:
        builders:
            hpke:
                encryption_algorithms: ['HPKE-3', 'HPKE-0-KE', 'A128GCM']
        decrypters:
            hpke:
                encryption_algorithms: ['HPKE-3', 'HPKE-0-KE', 'A128GCM']
```

## Security considerations

* In the base mode, HPKE does not authenticate the sender: use a signed payload (nested token) or the pre-shared key mode when the origin matters.
* Use a key pair with one algorithm only: do not mix HPKE and non-HPKE algorithms (such as `ECDH-ES`) or several HPKE algorithms with the same key. Setting the `alg` parameter of the key enforces it.
* With several recipients, the content is only as protected as the weakest key encryption algorithm in use.
* As for every algorithm, the application decides which algorithms it accepts: restrict them with the [header checker](../../the-components/header-checker.md) (`AlgorithmChecker`).

The test vectors of draft-ietf-jose-hpke-encrypt (appendix A) and of RFC 9180 are part of the test suite of the library.
