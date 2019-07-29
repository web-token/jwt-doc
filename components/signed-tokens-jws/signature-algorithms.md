# Signature Algorithms

This framework comes with several signature algorithms. These algorithms are in the following namespace: `Jose\Component\Signature\Algorithm`.

* HMAC with SHA-2 Functions. Package `web-token/jwt-signature-algorithm-hmac`
  * `HS256`
  * `HS384`
  * `HS512`
* Elliptic Curve Digital Signature Algorithm \(ECDSA\). Package `web-token/jwt-signature-algorithm-ecdsa`
  * `ES256`
  * `ES384`
  * `ES512`
* RSASSA-PKCS1 v1\_5. Package `web-token/jwt-signature-algorithm-rsa`
  * `RS256`
  * `RS384`
  * `RS512`
* RSASSA-PSS. Package `web-token/jwt-signature-algorithm-rsa`
  * `PS256`
  * `PS384`
  * `PS512`
* Edwards-curve Digital Signature Algorithm \(EdDSA\) Package `web-token/jwt-signature-algorithm-eddsa`
  * `EdDSA` \(_only with the_ `Ed25519` _curve_\)
* Unsecured algorithm Package `web-token/jwt-signature-algorithm-none`
  * `none`

**The following signature algorithms are experimental and must not be used in production unless you know what you are doing. They are proposed for testing purpose only.**

They are all part of the package `web-token/jwt-signature-algorithm-experimental`

* `RS1`: RSASSA-PKCS1 v1\_5 with SHA-1 hashing function.
* `HS1`: HMAC with SHA-1 hashing function.
* `ES256K`: Elliptic curve secp256k1 support \(v2.1+\).

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

