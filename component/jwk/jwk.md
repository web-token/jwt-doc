Key Management (JWK)
====================

A JWK object represents a key. It contains all parameters needed by the algorithm and also information parameters.
This object is provided by the `web-token/jwt-core` component.

You can create a JWK object using two static methods:

* `JWK::create(array $values)`: creates a JWK using direct values.
* `JWK::createFromJson(string $json)`: creates a JWK using a JSON object.

Hereafter all methods available for a JWK object. The variable `$jwk` is a valid JWK object.

```php
<?php
// Check if the key has a parameter.
$jwk->has('kty');

// Retrieve the key parameter.
$jwk->get('kty');

// Retrieve all key parameters.
$jwk->all();

// Calculate the thumbprint of the key. Acceptable hash algorithms are those returned by the PHP function "hash_algos".
$jwk->thumbprint('sha256');

// If the key is a private key (RSA, EC, OKP), it can be converted into public:
$public_key = $jwk->toPublic();

// The JWK object can be serialized into JSON
json_encode($jwk);
```

# Generate A New Key

This framework is able to create private and public keys easily using the `JWKFactory`.
It is available in the [`web-token/jwt-key-mgmt` component](https://github.com/web-token/jwt-key-mgmt).

```sh
composer require web-token/jwt-key-mgmt
```

4 types of keys are supported:

* Symmetric Key:
    * `oct`: octet string
* Asymmetric Key:
    * `RSA`: RSA key pair
    * `EC` : Elliptic Curve key pair
    * `OKP`: Octet key pair

*Note: for the `none` algorithm, the framework needs a key of type `none`. This is a specific key type that must only be used with this algorithm.*

For all asymmetric keys, you will ALWAYS receive a private key.

## Octet String

The following example will show you how to create an `oct` key.
Additional parameters will be set to limit the scope of this key (e.g. signature/verification only with the `HS256` algorithm).

```php
<?php

use Jose\Component\KeyManagement\JWKFactory;

$key = JWKFactory::createOctKey(
    1024, // Size in bits of the key. We recommend at least 128 bits.
    [
        'alg' => 'HS256', // This key must only be used with the HS256 algorithm
        'use' => 'sig'    // This key is used for signature/verification operations only
    ]
);
```

## RSA Key Pair

The following example will show you how to create a `RSA` key.

```php
<?php

use Jose\Component\KeyManagement\JWKFactory;

$private_key = JWKFactory::createRSAKey(
    4096, // Size in bits of the key. We recommend at least 2048 bits.
    [
        'alg' => 'RSA-OAEP-256', // This key must only be used with the RSA-OAEP-256 algorithm
        'use' => 'enc'    // This key is used for encryption/decryption operations only
    ]);
```

## Elliptic Curve Key Pair

The following example will show you how to create a `EC` key.

```php
<?php

use Jose\Component\KeyManagement\JWKFactory;

$key = JWKFactory::createECKey('P-256');
```

The supported curves are:

* `P-256`
* `P-384`
* `P-521` (note that this is **521** and not 512)

### Octet Key Pair

The following example will show you how to create a `OKP` key.

```php
<?php

use Jose\Component\KeyManagement\JWKFactory;

$key = JWKFactory::createOKPKey('X25519');
```

The supported curves are:

* `Ed25519` for signature/verification only
* `X25519` for encryption/decryption only

## None Key

The `none` key type is a special type used only for the `none` algorithm.

```php
<?php

use Jose\Component\KeyManagement\JWKFactory;

$key = JWKFactory::createNoneKey();
```

# Create Key From External Sources

## From Values

In case you already have key values, you can create a key by passing those values as an argument:

```php
<?php

use Jose\Component\KeyManagement\JWKFactory;

$key = JWKFactory::createFromValues([
    'kid' => '71ee230371d19630bc17fb90ccf20ae632ad8cf8',
    'kty' => 'RSA',
    'alg' => 'RS256',
    'use' => 'sig',
    'n' => 'vnMTRCMvsS04M1yaKR112aB8RxOkWHFixZO68wCRlVLxK4ugckXVD_Ebcq-kms1T2XpoWntVfBuX40r2GvcD9UsTFt_MZlgd1xyGwGV6U_tfQUll5mKxCPjr60h83LXKJ_zmLXIqkV8tAoIg78a5VRWoms_0Bn09DKT3-RBWFjk=',
    'e' => 'AQAB',
]);
```

## From A Key File

You can convert a PKCS#1 or PKCS#8 key file into a JWK.
The following method supports PEM and DER formats. Encrypted keys are also supported.

```php
<?php

use Jose\Component\KeyManagement\JWKFactory;

$key = JWKFactory::createFromKeyFile(
    '/path/to/my/key/file.pem', // The filename
    'Secret',                   // Secret if the key is encrypted
    [
        'use' => 'sig',         // Additional parameters
    ]
);
```

## From A PKCS#12 Certificate

You can convert a PKCS#12 Certificate into a JWK.
Encrypted certificates are also supported.

```php
<?php

use Jose\Component\KeyManagement\JWKFactory;

$key = JWKFactory::createFromPKCS12CertificateFile(
    '/path/to/my/key/file.p12', // The filename
    'Secret',                   // Secret if the key is encrypted
    [
        'use' => 'sig',         // Additional parameters
    ]
);
```

## From A X.509 Certificate

You can convert a X.509 Certificate into a JWK.

```php
<?php

use Jose\Component\KeyManagement\JWKFactory;

$key = JWKFactory::createFromCertificateFile(
    '/path/to/my/key/file.crt', // The filename
    [
        'use' => 'sig',         // Additional parameters
    ]
);
```

*Please note that X.509 certificates only contains public keys*.
