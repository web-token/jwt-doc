# Encryption Algorithms

This framework comes with several encryption algorithms. These algorithms are in the following namespaces:

* `Jose\Component\Encryption\Algorithm\KeyEncryption`: key encryption algorithms
* `Jose\Component\Encryption\Algorithm\ContentEncryption`: content encryption algorithms

## Main Algorithms

### Key Encryption

<table><thead><tr><th width="247.89966436130516">Algorithm</th><th>Additional header parameter</th></tr></thead><tbody><tr><td><p>A128KW</p><p>A192KW</p><p>A256KW</p></td><td>No</td></tr><tr><td><p>A128GCMKW</p><p>A192GCMKW</p><p>A256GCMKW</p></td><td><code>iv</code>:  (initialization vector) this value is the base64url-encoded representation of the 96-bit IV value used for the key encryption operation.<br><code>tag</code>: (authentication tag) the value is the base64url-encoded representation of the 128-bit Authentication Tag value resulting from the key encryption operation.</td></tr><tr><td>dir</td><td>No</td></tr><tr><td><p>ECDH-ES</p><p>ECDH-ES+A128KW</p><p>ECDH-ES+A192KW</p><p>ECDH-ES+A256KW</p></td><td><code>epk</code>: (ephemeral public key) value created by the originator.</td></tr><tr><td><p>ECDH-SS</p><p>ECDH-SS+A128KW</p><p>ECDH-SS+A192KW</p><p>ECDH-SS+A256KW</p></td><td>No</td></tr><tr><td><p>PBES2-HS256+A128KW</p><p>PBES2-HS384+A192KW</p><p>PBES2-HS512+A256KW</p></td><td><code>p2s</code>: (PBES2 salt input) encodes a Salt Input value, which is used as part of the PBKDF2 salt value.<br><code>p2c</code>: (PBES2 count) contains the PBKDF2 iteration count, represented as a positive JSON integer.</td></tr><tr><td><p>RSA1_5</p><p>RSA-OAEP</p><p>RSA-OAEP-256 </p></td><td></td></tr></tbody></table>

{% hint style="warning" %}
Please note that the additional header parameters **MUST** be present and **MUST** be understood. Depending on the algorithm you use, you may be required to check headers BEFORE the decryption operation. Please create a [custom Header Checker](../header-checker.md) for theses parameters.
{% endhint %}

### Content Encryption

| Algorithm                                                    | Package                                     |
| ------------------------------------------------------------ | ------------------------------------------- |
| <p>A128GCM</p><p>A192GCM</p><p>A256GCM</p>                   | `web-token/jwt-encryption-algorithm-aesgcm` |
| <p>A128CBC-HS256</p><p>A192CBC-HS384</p><p>A256CBC-HS512</p> | `web-token/jwt-encryption-algorithm-aescbc` |

{% hint style="danger" %}
The algorithm `RSA1_5` is deprecated due to known [security vulnerability](https://en.wikipedia.org/wiki/Adaptive\_chosen-ciphertext\_attack).

The algorithms `ECDH-ES*` are not recommended unless used with the `OKP` key type.
{% endhint %}

## Experimental Algorithms

The following algorithms are experimental and must not be used in production unless you know what you are doing. <mark style="color:red;">They are proposed for testing purpose only.</mark>

### Key Encryption

<table><thead><tr><th width="225">Algorithm</th><th>Description</th></tr></thead><tbody><tr><td><p>A128CTR</p><p>A192CTR</p><p>A256CTR</p></td><td>AES CTR based encryption</td></tr><tr><td>Chacha20+Poly1305</td><td><em>Please note that this algorithm requires OpenSSL 1.1</em></td></tr><tr><td><p>RSA-OAEP-384</p><p>RSA-OAEP-512</p></td><td>Same algorithm as RSA-OAEP-256 but with SHA-384 and SHA-512 hashing functions</td></tr></tbody></table>

### Content Encryption

<table><thead><tr><th width="226">Algorithm</th><th>Description</th></tr></thead><tbody><tr><td><p>A128CCM-16-128</p><p>A128CCM-16-64</p><p>A128CCM-64-128</p><p>A128CCM-64-64</p><p></p><p>A256CCM-16-128</p><p>A256CCM-16-64</p><p>A256CCM-64-128</p><p>A256CCM-64-64</p></td><td>AES-CCM based algorithms</td></tr></tbody></table>

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
