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

They are provided throught the package `web-token/jwt-experimental`.

| Algorithm | Description                                    |
| --------- | ---------------------------------------------- |
| RS1       | RSASSA-PKCS1 v1\_5 with SHA-1 hashing function |
| HS1       | HMAC with SHA-1 hashing function               |
| ES256K    | Elliptic curve secp256k1 support               |

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
