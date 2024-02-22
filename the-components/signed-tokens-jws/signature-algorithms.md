# Signature Algorithms

This framework comes with several signature algorithms. These algorithms are in the following namespace: `Jose\Component\Signature\Algorithm`.

<table><thead><tr><th width="207">Algorithm</th><th>Description</th></tr></thead><tbody><tr><td><p>HS256</p><p>HS384</p><p>HS512</p></td><td>HMAC with SHA-2 Functions</td></tr><tr><td><p></p><p>ES256</p><p>ES384</p><p>ES512</p></td><td>Elliptic Curve Digital Signature Algorithm (ECDSA)</td></tr><tr><td><p>RS256</p><p>RS384</p><p>RS512</p></td><td>RSASSA-PKCS1 v1_5</td></tr><tr><td><p>PS256</p><p>PS384</p><p>PS512</p></td><td>RSASSA-PSS</td></tr><tr><td>EdDSA (<em>only with the</em> Ed25519 <em>curve</em>)</td><td>Edwards-curve Digital Signature Algorithm (EdDSA)</td></tr><tr><td>none</td><td></td></tr></tbody></table>

### Experimental Algorithms

The following signature algorithms are experimental and must not be used in production unless you know what you are doing. <mark style="color:red;">They are proposed for testing purpose only.</mark>

They are provided throught the package `web-token/jwt-experimental`.

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
