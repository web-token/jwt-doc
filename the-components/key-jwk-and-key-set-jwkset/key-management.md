# Key (JWK)

You can create a JWK object using two methods:

* `new JWK(array $values)`: creates a JWK using direct values.
* `JWK::createFromJson(string $json)`: creates a JWK from a JSON string.

Below are all methods available for a JWK object. The variable `$jwk` is a valid JWK object.

{% hint style="warning" %}
Please note a JWK object is an immutable object. If you change a value using a setter, it will return a new object.
{% endhint %}

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

## Typed Accessors

`get()` returns an undeclared `mixed` and throws when the parameter is absent, so reading a parameter meant writing the same three steps every time: `has()`, `get()`, then a type assertion. The typed accessors do it for you:

```php
<?php
// The key type. Always present.
$jwk->kty();            // string

// The algorithm and the usage this key is restricted to.
// Both return null when the key carries no such restriction.
$jwk->alg();            // ?string
$jwk->use();            // ?string

// Read any parameter and assert it is a string.
$jwk->getString('kid'); // string, throws if absent or not a string

// Read any parameter without throwing when it is absent.
$jwk->find('kid');      // mixed|null
```

{% hint style="info" %}
These accessors are available since 4.3.
{% endhint %}

{% hint style="warning" %}
`JWK` becomes `final readonly` in 5.0, and extending it raises a deprecation notice since 4.3. A key is a value object: it carries no behaviour to change, and the state a subclass adds to it cannot survive the constructor becoming the only way to populate it. Build the key with its constructor and keep your own state in the object that uses it:

```php
final readonly class ManagedKey
{
    public function __construct(
        public JWK $key,
        public DateTimeImmutable $rotatedAt,
    ) {
    }
}
```
{% endhint %}

## Generate A New Key

This framework is able to create private and public keys on the fly using the key factory. 4 types of keys are supported:

* Symmetric Key:
  * `oct`: octet string
* Asymmetric Key:
  * `RSA`: RSA key pair
  * `EC` : Elliptic Curve key pair
  * `OKP`: Octet key pair

{% hint style="info" %}
The `none` algorithm needs a key of type `none`. This is a specific key type that must only be used with this algorithm.
{% endhint %}

The factory is a service implementing `JWKFactoryInterface`. Inject it where you need to build keys — the Symfony Bundle autowires it, and a decorator can be put in its place to audit, cache or delegate the generation to a hardware backed implementation:

```php
<?php

use Jose\Component\KeyManagement\JWKFactory;
use Jose\Component\KeyManagement\JWKFactoryInterface;

// Outside a container:
$jwkFactory = new JWKFactory();

// In a Symfony application, type-hint the interface and let it be autowired:
public function __construct(private JWKFactoryInterface $jwkFactory) {}
```

{% hint style="warning" %}
Until 4.2, the factory was a set of static methods: `JWKFactory::createRSAKey()`, `JWKFactory::createFromKeyFile()`… They still work, but are deprecated since 4.3 and removed in 5.0. The instance methods drop the `create` prefix — see the [migration guide](../../migration/from-v4.2-to-v4.3.md#the-key-factory-is-an-injectable-service) for the full correspondence table.
{% endhint %}

### Octet String

The following example will show you how to create an `oct` key.

Additional parameters will be set to limit the scope of this key (e.g. signature/verification only with the `HS256` algorithm).

```php
<?php

$key = $jwkFactory->oct(
    1024, // Size in bits of the key. Should be at least of the same size as the hashing algorithm.
    [
        'alg' => 'HS256', // This key must only be used with the HS256 algorithm
        'use' => 'sig'    // This key is used for signature/verification operations only
    ]
);
```

If you already have a shared secret, you can use it to create an `oct` key:

```php
<?php

$jwk = $jwkFactory->fromSecret(
    'My Secret Key',       // The shared secret
    [                      // Optional additional members
        'alg' => 'HS256',
        'use' => 'sig'
    ]
);
```

### RSA Key Pair

The following example will show you how to create a `RSA` key.

The key size must be of 384 bits at least, but nowadays the recommended size is 2048 bits.

```php
<?php

$private_key = $jwkFactory->rsa(
    4096, // Size in bits of the key. We recommend at least 2048 bits.
    [
        'alg' => 'RSA-OAEP-256', // This key must only be used with the RSA-OAEP-256 algorithm
        'use' => 'enc'    // This key is used for encryption/decryption operations only
    ]);
```

### Elliptic Curve Key Pair

The following example will show you how to create a `EC` key.

```php
<?php

$key = $jwkFactory->ec('P-256');
```

The supported curves are:

* `P-256`
* `P-384`
* `P-521` (note that this is **521** and not 512)
* `BP-256`, `BP-384` and `BP-512` (the `brainpoolP256r1`, `brainpoolP384r1` and `brainpoolP512r1` curves)

The Brainpool curves can be used for ECDSA signatures — through the `BP256R1`, `BP384R1` and `BP512R1` [experimental algorithms](../signed-tokens-jws/signature-algorithms.md#experimental-algorithms) — for `ECDH-ES`/`ECDH-SS` key agreement, and for the PEM/JWK conversions in both directions.

{% hint style="warning" %}
The Brainpool curves are **not registered with IANA**. The identifiers `BP-256`, `BP-384` and `BP-512` follow the convention already adopted by the other implementations, so keys and tokens using them are only interoperable with the implementations sharing that convention.
{% endhint %}

#### Octet Key Pair

The following example will show you how to create a `OKP` key.

```php
<?php

$key = $jwkFactory->okp('X25519');
```

The supported curves are:

* `Ed25519` for signature/verification only
* `X25519` for encryption/decryption only

### None Key

The `none` key type is a special type used only for the `none` algorithm.

```php
<?php

$key = $jwkFactory->none();
```

## Create Key From External Sources

### From Values

In case you already have key values, you can create a key by passing those values as an argument:

```php
<?php

$key = $jwkFactory->fromValues([
    'kid' => '71ee230371d19630bc17fb90ccf20ae632ad8cf8',
    'kty' => 'RSA',
    'alg' => 'RS256',
    'use' => 'sig',
    'n' => 'vnMTRCMvsS04M1yaKR112aB8RxOkWHFixZO68wCRlVLxK4ugckXVD_Ebcq-kms1T2XpoWntVfBuX40r2GvcD9UsTFt_MZlgd1xyGwGV6U_tfQUll5mKxCPjr60h83LXKJ_zmLXIqkV8tAoIg78a5VRWoms_0Bn09DKT3-RBWFjk=',
    'e' => 'AQAB',
]);
```

### From A Key File

You can convert a PKCS#1 or PKCS#8 key file into a JWK. The following method supports PEM and DER formats. Encrypted keys are also supported.

```php
<?php

$key = $jwkFactory->fromKeyFile(
    '/path/to/my/key/file.pem', // The filename
    'Secret',                   // Secret if the key is encrypted, otherwise null
    [
        'use' => 'sig',         // Additional parameters
    ]
);
```

### From A PKCS#12 Certificate

You can convert a PKCS#12 Certificate into a JWK. Encrypted certificates are also supported.

```php
<?php

$key = $jwkFactory->fromPKCS12CertificateFile(
    '/path/to/my/key/file.p12', // The filename
    'Secret',                   // Secret if the key is encrypted
    [
        'use' => 'sig',         // Additional parameters
    ]
);
```

### From A X.509 Certificate

You can convert a X.509 Certificate into a JWK.

```php
<?php

$key = $jwkFactory->fromCertificateFile(
    '/path/to/my/key/file.crt', // The filename
    [
        'use' => 'sig',         // Additional parameters
    ]
);
```

{% hint style="info" %}
Please note that X.509 certificates only contain public keys.
{% endhint %}
