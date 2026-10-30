# Encryption algorithms

This framework comes with several encryption algorithms. These algorithms are in the following namespaces:

* `Jose\Component\Encryption\Algorithm\KeyEncryption`: key encryption algorithms
* `Jose\Component\Encryption\Algorithm\ContentEncryption`: content encryption algorithms

## Main algorithms

### Key encryption

!!! info

    `spomky-labs/aes-key-wrap` is required for \*KW algorithms

| Algorithm | Additional header parameter |
|---|---|
| A128KW<br>A192KW<br>A256KW | No |
| A128GCMKW<br>A192GCMKW<br>A256GCMKW | `iv`:  (initialization vector) this value is the base64url-encoded representation of the 96-bit IV value used for the key encryption operation.<br>`tag`: (authentication tag) the value is the base64url-encoded representation of the 128-bit Authentication Tag value resulting from the key encryption operation. |
| dir | No |
| ECDH-ES<br>ECDH-ES+A128KW<br>ECDH-ES+A192KW<br>ECDH-ES+A256KW | `epk`: (ephemeral public key) value created by the originator. |
| ECDH-SS<br>ECDH-SS+A128KW<br>ECDH-SS+A192KW<br>ECDH-SS+A256KW | No |
| PBES2-HS256+A128KW<br>PBES2-HS384+A192KW<br>PBES2-HS512+A256KW | `p2s`: (PBES2 salt input) encodes a Salt Input value, which is used as part of the PBKDF2 salt value.<br>`p2c`: (PBES2 count) contains the PBKDF2 iteration count, represented as a positive JSON integer. |
| RSA1_5<br>RSA-OAEP<br>RSA-OAEP-256 |  |
| HPKE-0-KE<br>HPKE-1-KE<br>HPKE-2-KE<br>HPKE-3-KE<br>HPKE-5-KE<br>HPKE-7-KE | `ek`: (encapsulated key) the base64url-encoded HPKE encapsulated key, added by the algorithm.<br>`psk_id`: (pre-shared key identifier) set by the application to use a pre-shared key. |
| HPKE-0<br>HPKE-1<br>HPKE-2<br>HPKE-3<br>HPKE-4<br>HPKE-5<br>HPKE-6<br>HPKE-7 | `psk_id`: (pre-shared key identifier) set by the application to use a pre-shared key.<br>These algorithms encrypt the content themselves: there is no `enc` header parameter. |

!!! warning

    Please note that the additional header parameters **MUST** be present and **MUST** be understood. Depending on the algorithm you use, you may be required to check headers BEFORE the decryption operation. Please create a [custom Header Checker](../header-checker.md) for theses parameters.

### Content encryption

| Algorithm                                                    | Namespace                                                             |
| ------------------------------------------------------------ | --------------------------------------------------------------------- |
|A128GCM<br>A192GCM<br>A256GCM| `Jose\Component\Encryption\Algorithm\ContentEncryption` |
|A128CBC-HS256<br>A192CBC-HS384<br>A256CBC-HS512| `Jose\Component\Encryption\Algorithm\ContentEncryption` |

!!! danger

    The algorithm `RSA1_5` is deprecated due to known [security vulnerability](https://en.wikipedia.org/wiki/Adaptive_chosen-ciphertext_attack).

    The algorithms `ECDH-ES*` are not recommended unless used with the `OKP` key type.

### The `RSA1_5` algorithm

Since 4.3, `RSA1_5` lives in its own package, so that enabling an algorithm whose padding is vulnerable to the Bleichenbacher adaptive chosen-ciphertext attack is an explicit and auditable decision:

```bash
composer require web-token/jwt-rsa15
```

```php
<?php

use Jose\Rsa15\KeyEncryption\RSA15;
```

!!! warning

    `Jose\Component\Encryption\Algorithm\KeyEncryption\RSA15` still works — it is an empty subclass of the new class — but it is deprecated since 4.3 and removed in 5.0. In the Symfony Bundle, the configuration alias is unchanged: `RSA1_5` still names the algorithm.

### The HPKE algorithms

Since 4.3, the `HPKE-*` algorithms of [draft-ietf-jose-hpke-encrypt](https://datatracker.ietf.org/doc/draft-ietf-jose-hpke-encrypt/) bring HPKE to JWE in two key management modes: Integrated Encryption (`HPKE-0` to `HPKE-7`), where HPKE encrypts the payload itself and the token has no `enc`, and Key Encryption (`HPKE-*-KE`), where HPKE encrypts the CEK of a regular content encryption algorithm. Each identifier fixes the key type, the curve and the HPKE cipher suite. See the [HPKE](../../advanced-topics/encrypted-tokens/hpke.md) page for the details, the pre-shared key mode and the platform requirements.

### Curves supported by the key agreement algorithms

The `ECDH-ES*` and `ECDH-SS*` algorithms accept:

* `EC` keys using the `P-256`, `P-384`, `P-521`, `secp256k1`, `BP-256`, `BP-384` or `BP-512` curve,
* `OKP` keys using the `X25519` curve (SODIUM extension, or OpenSSL on PHP 8.4+) or the `X448` curve (PHP 8.4+ is required, OpenSSL; since 4.3).

The `BP-*` curves are the Brainpool curves. They are part of the core library and do not require the experimental package. Please read the [warning about their interoperability](../key-jwk-and-key-set-jwkset/key-management.md#elliptic-curve-key-pair) before using them.

## Experimental algorithms

The following algorithms are experimental and must not be used in production unless you know what you are doing. **They are proposed for testing purpose only.**

### Key encryption

| Algorithm | Description |
|---|---|
| A128CTR<br>A192CTR<br>A256CTR | AES CTR based encryption |
| Chacha20+Poly1305 | *Please note that this algorithm requires OpenSSL 1.1* |
| RSA-OAEP-384<br>RSA-OAEP-512 | Same algorithm as RSA-OAEP-256 but with SHA-384 and SHA-512 hashing functions |

### Content encryption

| Algorithm | Description |
|---|---|
| A128CCM-16-128<br>A128CCM-16-64<br>A128CCM-64-128<br>A128CCM-64-64<br>A256CCM-16-128<br>A256CCM-16-64<br>A256CCM-64-128<br>A256CCM-64-64 | AES-CCM based algorithms |

## How to use

These algorithms have to be used with the [Algorithm Manager](../algorithm-management-jwa.md).

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\Algorithm\KeyEncryption\A128KW;
use Jose\Component\Encryption\Algorithm\KeyEncryption\PBES2HS256A128KW;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A128CBCHS256;

$algorithmManager = new AlgorithmManager([
    new A128KW(),
    new PBES2HS256A128KW(),
    new A128CBCHS256(),
]);
```

By default, `PBES2*` algorithms use the following parameter values:

* Salt size: 64 bytes (512 bits)
* Count: 4096&#x20;

You may need to use other values. This can be done during the instantiation of the algorithm:

Example with 16 bytes (128 bits) salt and 1024 counts:

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\Algorithm\KeyEncryption\PBES2HS256A128KW;

$algorithmManager = new AlgorithmManager([
    new PBES2HS256A128KW(16, 1024),
]);
```
