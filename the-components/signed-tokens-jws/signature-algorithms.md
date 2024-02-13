# Signature Algorithms

This framework comes with several signature algorithms. These algorithms are in the following namespace: `Jose\Component\Signature\Algorithm`.

| Algorithm                                   | Description                                        | Package                                   |
| ------------------------------------------- | -------------------------------------------------- | ----------------------------------------- |
| <p>HS256</p><p>HS384</p><p>HS512</p>        | HMAC with SHA-2 Functions                          | `web-token/jwt-signature-algorithm-hmac`  |
| <p></p><p>ES256</p><p>ES384</p><p>ES512</p> | Elliptic Curve Digital Signature Algorithm (ECDSA) | `web-token/jwt-signature-algorithm-ecdsa` |
| <p>RS256</p><p>RS384</p><p>RS512</p>        | RSASSA-PKCS1 v1\_5                                 | `web-token/jwt-signature-algorithm-rsa`   |
| <p>PS256</p><p>PS384</p><p>PS512</p>        | RSASSA-PSS                                         | `web-token/jwt-signature-algorithm-rsa`   |
| EdDSA (_only with the_ Ed25519 _curve_)     | Edwards-curve Digital Signature Algorithm (EdDSA)  | `web-token/jwt-signature-algorithm-eddsa` |
| none                                        |                                                    | `web-token/jwt-signature-algorithm-none`  |

**The following signature algorithms are experimental and must not be used in production unless you know what you are doing. They are proposed for testing purpose only.**

**They are provided throught the package** `web-token/jwt-signature-algorithm-experimental`.

| Algorithm | Description                                    |
| --------- | ---------------------------------------------- |
| RS1       | RSASSA-PKCS1 v1\_5 with SHA-1 hashing function |
| HS1       | HMAC with SHA-1 hashing function               |
| ES256K    | Elliptic curve secp256k1 support               |

## How To Use

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
