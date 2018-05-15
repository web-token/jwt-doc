# Encryption Algorithms

## Encryption Algorithms

## Available Algorithms

This framework comes with several encryption algorithms. These algorithms are in the following namespaces:

* `Jose\Component\Encryption\Algorithm\KeyEncryption`: key encryption algorithms
* `Jose\Component\Encryption\Algorithm\ContentEncryption`: content encryption algorithms
* Key Encryption
  * `A128KW`
  * `A192KW`
  * `A256KW`
  * `A128GCMKW`
  * `A192GCMKW`
  * `A256GCMKW`
  * `dir` \(class `Dir`\)
  * `ECDH-ES` \(class `ECDHES`\) **READ THE NOTE BELOW**
  * `ECDH-ES+A128KW` \(class `ECDHESA128KW`\) **READ THE NOTE BELOW**
  * `ECDH-ES+A192KW` \(class `ECDHESA192KW`\) **READ THE NOTE BELOW**
  * `ECDH-ES+A256KW` \(class `ECDHESA256KW`\) **READ THE NOTE BELOW**
  * `PBES2-HS256+A128KW` \(class `PBES2HS256A128KW`\)
  * `PBES2-HS384+A192KW` \(class `PBES2HS384A192KW`\)
  * `PBES2-HS512+A259KW` \(class `PBES2HS512A1256KW`\)
  * `RSA1_5` \(class `RSA15`\) **READ THE NOTE BELOW**
  * `RSA-OAEP` \(class `RSAOAEP`\)
  * `RSA-OAEP-256` \(class `RSAOAEP256`\)
* Content Encryption
  * `A128GCM`
  * `A192GCM`
  * `A256GCM`
  * `A128CBC-HS256` \(class `A128CBCHS256`\)
  * `A192CBC-HS384` \(class `A192CBCHS384`\)
  * `A256CBC-HS512` \(class `A256CBCHS512`\)

**IMPORTANT NOTE:**

* The algorithm `RSA1_5` is deprecated due to known [security vulnerability](https://en.wikipedia.org/wiki/Adaptive_chosen-ciphertext_attack).
* The algorithms `ECDH-ES*` are not recommended unless used with the `OKP` key type.

## How To Use

These algorithms have to be used with the [Algorithm Manager](../algorithm-management-jwa.md). They do not need any arguments.

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

By default, `PBES2*` algorithms use the following parameter values:

* Salt size: 64 bytes \(512 bits\)
* Count: 4096 

You may need to use other values. This can be done during the instantiation of the algorithm:

Example with 16 bytes \(128 bits\) salt and 1024 counts:

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\Algorithm\KeyEncryption\PBES2HS256A128KW;

$algorithmManager = AlgorithmManager::create([
    new PBES2HS256A128KW(16, 1024),
]);
```

