Signature Algorithms
====================

# Available Algorithms

This framework comes with several signature algorithms.
These algorithms are in the following namespace: `Jose\Component\Signature\Algorithm`.

* HMAC with SHA-2 Functions
    * `HS256`
    * `HS384`
    * `HS512`
* Elliptic Curve Digital Signature Algorithm (ECDSA)
    * `ES256`
    * `ES384`
    * `ES512`
* RSASSA-PKCS1 v1_5
    * `RS256`
    * `RS384`
    * `RS512`
* RSASSA-PSS
    * `PS256`
    * `PS384`
    * `PS512`
* Edwards-curve Digital Signature Algorithm (EdDSA)
    * `EdDSA` (*only with the `Ed25519` curve*)
* Unsecured algorithm
    * `none`

# How To Use

These algorithms have to be used with the [Algorithm Manager](../jwa/index.md).
They do not need any arguments.

Example:

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Signature\Algorithm\PS256;
use Jose\Component\Signature\Algorithm\ES512;
use Jose\Component\Signature\Algorithm\None;

$algorithm_manager = AlgorithmManager::create([
    new PS256(),
    new ES512(),
    new None(),
]);
```
