# Encryption Algorithms

This framework comes with several encryption algorithms. These algorithms are in the following namespaces:

* `Jose\Component\Encryption\Algorithm\KeyEncryption`: key encryption algorithms
* `Jose\Component\Encryption\Algorithm\ContentEncryption`: content encryption algorithms

Key Encryption

* Package `web-token/jwt-encryption-algorithm-aeskw`
  * `A128KW`
  * `A192KW`
  * `A256KW`
* Package `web-token/jwt-encryption-algorithm-aesgcmkw`
  * `A128GCMKW`
  * `A192GCMKW`
  * `A256GCMKW`
* Package `web-token/jwt-encryption-algorithm-dir`
  * `dir` \(class `Dir`\)
* Package `web-token/jwt-encryption-algorithm-ecdh-es`
  * `ECDH-ES` \(class `ECDHES`\) **READ THE NOTE BELOW**
  * `ECDH-ES+A128KW` \(class `ECDHESA128KW`\) **READ THE NOTE BELOW**
  * `ECDH-ES+A192KW` \(class `ECDHESA192KW`\) **READ THE NOTE BELOW**
  * `ECDH-ES+A256KW` \(class `ECDHESA256KW`\) **READ THE NOTE BELOW**
* Package `web-token/jwt-encryption-algorithm-pbes2`
  * `PBES2-HS256+A128KW` \(class `PBES2HS256A128KW`\)
  * `PBES2-HS384+A192KW` \(class `PBES2HS384A192KW`\)
  * `PBES2-HS512+A259KW` \(class `PBES2HS512A256KW`\)
* Package `web-token/jwt-encryption-algorithm-rsa`
  * `RSA1_5` \(class `RSA15`\) **READ THE NOTE BELOW**
  * `RSA-OAEP` \(class `RSAOAEP`\)
  * `RSA-OAEP-256` \(class `RSAOAEP256`\)

Content Encryption

* Package `web-token/jwt-encryption-algorithm-aesgcm`
  * `A128GCM`
  * `A192GCM`
  * `A256GCM`
* Package `web-token/jwt-encryption-algorithm-aescbc`
  * `A128CBC-HS256` \(class `A128CBCHS256`\)
  * `A192CBC-HS384` \(class `A192CBCHS384`\)
  * `A256CBC-HS512` \(class `A256CBCHS512`\)

{% hint style="danger" %}
The algorithm `RSA1_5` is deprecated due to known [security vulnerability](https://en.wikipedia.org/wiki/Adaptive_chosen-ciphertext_attack).

The algorithms `ECDH-ES*` are not recommended unless used with the `OKP` key type.
{% endhint %}

## Experimental Algorithms

The following algorithms are experimental and must not be used in production unless you know what you are doing. They are proposed for testing purpose only.

They are all part of the package `web-token/jwt-encryption-algorithm-experimental`

Key Encryption

* `A128CTR`, `A192CTR` and `A256CTR`: AES CTR based encryption.
* `Chacha20+Poly1305` : _Please note that this algorithm requires OpenSSL 1.1_
* `RSA-OAEP-384` and `RSA-OAEP-512`: Same algorithm as RSA-OAEP-256 but with SHA-384 and SHA-512 hashing functions.

Content Encryption

* `AxxxCCM-16-128`, `AxxxCCM-16-64`, `AxxxCCM-64-128`, `AxxxCCM-64-64`: AES-CCM based aalgorithms. **xxx** can be 128 or 256.

## How To Use

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

* Salt size: 64 bytes \(512 bits\)
* Count: 4096 

You may need to use other values. This can be done during the instantiation of the algorithm:

Example with 16 bytes \(128 bits\) salt and 1024 counts:

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\Algorithm\KeyEncryption\PBES2HS256A128KW;

$algorithmManager = new AlgorithmManager([
    new PBES2HS256A128KW(16, 1024),
]);
```

