# Signature algorithms

This framework comes with several signature algorithms. These algorithms are in the following namespace: `Jose\Component\Signature\Algorithm`.

| Algorithm | Description |
|---|---|
| HS256<br>HS384<br>HS512 | HMAC with SHA-2 Functions |
| ES256<br>ES384<br>ES512 | Elliptic Curve Digital Signature Algorithm (ECDSA) |
| RS256<br>RS384<br>RS512 | RSASSA-PKCS1 v1_5 |
| PS256<br>PS384<br>PS512 | RSASSA-PSS |
| EdDSA (*only with the* Ed25519 *curve*) | Edwards-curve Digital Signature Algorithm (EdDSA) |
| none | **Not a secure algorithm. Please use with caution** |

### Experimental algorithms

The following signature algorithms are experimental and must not be used in production unless you know what you are doing. **They are proposed for testing purpose only.**

They are provided through the package `web-token/jwt-experimental`.

| Algorithm | Description                                                                    |
| --------- | ------------------------------------------------------------------------------ |
| RS1       | RSASSA-PKCS1 v1\_5 with SHA-1 hashing function                                |
| HS1       | HMAC with SHA-1 hashing function                                               |
| HS256/64  | HMAC with SHA-256 truncated to 64 bits                                         |
| ES256K    | Elliptic curve secp256k1 support                                               |
| BP256R1   | ECDSA using the brainpoolP256r1 curve (`BP-256`) and SHA-256                   |
| BP384R1   | ECDSA using the brainpoolP384r1 curve (`BP-384`) and SHA-384                   |
| BP512R1   | ECDSA using the brainpoolP512r1 curve (`BP-512`) and SHA-512                   |
| Blake2b   | Blake2b MAC algorithm. Sodium extension required |

!!! warning

    The Brainpool algorithms and their curves are **not registered with IANA**. The identifiers `BP256R1`/`BP384R1`/`BP512R1` and `BP-256`/`BP-384`/`BP-512` follow the convention already adopted by the other implementations, so tokens using them are only interoperable with the implementations sharing that convention.

    The curves themselves are part of the core library: [creating a Brainpool key](../key-jwk-and-key-set-jwkset/key-management.md#elliptic-curve-key-pair) or using one with `ECDH-ES`/`ECDH-SS` does not require the experimental package.

## How to use

These algorithms have to be used with the [Algorithm Manager](../algorithm-management-jwa.md). They do not need any arguments.

Example:

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Signature\Algorithm\PS256;
use Jose\Component\Signature\Algorithm\ES512;
use Jose\Component\Signature\Algorithm\None;

$algorithm_manager = new AlgorithmManager([
    new PS256(),
    new ES512(),
    new None(),
]);
```
