Encryption Algorithms
=====================

# Available Algorithms

This framework comes with several encryption algorithms.
These algorithms are in the following namespaces:

* `Jose\Component\Encryption\Algorithm\KeyEncryption`: key encryption algorithms
* `Jose\Component\Encryption\Algorithm\ContentEncryption`: content encryption algorithms

* Key Encryption
    * `A128KW`
    * `A192KW`
    * `A256KW`
    * `A128GCMKW`
    * `A192GCMKW`
    * `A256GCMKW`
    * `dir` (class `Dir`)
    * `ECDH-ES` (class `ECDHES`)
    * `ECDH-ES+A128KW` (class `ECDHESA128KW`)
    * `ECDH-ES+A192KW` (class `ECDHESA192KW`)
    * `ECDH-ES+A256KW` (class `ECDHESA256KW`)
    * `PBES2-HS256+A128KW` (class `PBES2HS256A128KW`)
    * `PBES2-HS384+A192KW` (class `PBES2HS384A192KW`)
    * `PBES2-HS512+A259KW` (class `PBES2HS512A1256KW`)
    * `RSA1_5` (class `RSA15`)
    * `RSA-OAEP` (class `RSAOAEP`)
    * `RSA-OAEP-256` (class `RSAOAEP256`)
* Content Encryption
    * `A128GCM`
    * `A192GCM`
    * `A256GCM`
    * `A128CBC-HS256` (class `A128CBCHS256`)
    * `A192CBC-HS384` (class `A192CBCHS384`)
    * `A256CBC-HS512` (class `A256CBCHS512`)

Please consider the following information:

* The algorithm `RSA1_5` is deprecated due to known [security vulnerability](https://en.wikipedia.org/wiki/Adaptive_chosen-ciphertext_attack).
* The algorithms `ECDH-ES*` are not recommended unless used with the `OKP` keys.

# How To Use

These algorithms have to be used with the [Algorithm Manager](../jwa/index.md).
They do not need any arguments.

Example:

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\Algorithm\KeyEncryption\A128KW;
use Jose\Component\Encryption\Algorithm\KeyEncryption\PBES2HS256A128KW;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A128CBCHS256;

$algorithmManager = AlgorithmManager::create([
    new A128KW(),
    new PBES2HS256A128KW(),
    new A128CBCHS256(),
]);
```
