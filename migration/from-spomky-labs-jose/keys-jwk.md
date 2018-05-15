# Keys \(JWK\)

The JWK object is part of the core component \(`web-token/jwt-core`\). The may change concern the construction of the object. Its use is very similar.

**Before**

```php
<?php

use Jose\Object\JWK;

$key = new JWK([
    'kty' => 'RSA',
    'n' => '0vx7agoebGcQSuuPiLJXZptN9nndrQmbXEps2aiAFbWhM78LhWx4cbbfAAtVT86zwu1RK7aPFFxuhDR1L6tSoc_BJECPebWKRXjBZCiFV4n3oknjhMstn64tZ_2W-5JsGY4Hc5n9yBXArwl93lqt7_RN5w6Cf0h4QyQ5v-65YGjQR0_FDW2QvzqY368QQMicAtaSqzs8KJZgnYb9c7d0zgdAZHzu6qMQvRL5hajrn1n91CbOpbISD08qNLyrdkt-bFTWhAI4vMQFh6WeZu0fM4lFd2NcRwr3XPksINHaQ-G_xBniIqbw0Ls1jF44-csFCur-kEgU8awapJzKnqDKgw',
    'e' => 'AQAB',
    'alg' => 'RS256',
    'kid' => '2011-04-29',
]);

$key->has('kty'); // true
$key->get('kty'); // RSA
$key->thumbprint('sha256'); // The Sha-256 thumbprint of the key: "NzbLsXh8uDCcd-6MNwXF4W_7noWXFZAfHkxZsRGC9Xs"
json_encode($key); // The key as a Json object: "{"kty":"RSA","n":"0vx7agoebGcQSuuPiLJXZptN9n...8awapJzKnqDKgw","e":"AQAB","alg":"RS256","kid":"2011-04-29"}"
$key->toPublic(); // Converts a private key to a public one (not relevant in this example as the key is public)
$key->getAll(); // All key parameters
```

**After**

```php
<?php

use Jose\Component\Core\JWK;

$key = new JWK([
    'kty' => 'RSA',
    'n' => '0vx7agoebGcQSuuPiLJXZptN9nndrQmbXEps2aiAFbWhM78LhWx4cbbfAAtVT86zwu1RK7aPFFxuhDR1L6tSoc_BJECPebWKRXjBZCiFV4n3oknjhMstn64tZ_2W-5JsGY4Hc5n9yBXArwl93lqt7_RN5w6Cf0h4QyQ5v-65YGjQR0_FDW2QvzqY368QQMicAtaSqzs8KJZgnYb9c7d0zgdAZHzu6qMQvRL5hajrn1n91CbOpbISD08qNLyrdkt-bFTWhAI4vMQFh6WeZu0fM4lFd2NcRwr3XPksINHaQ-G_xBniIqbw0Ls1jF44-csFCur-kEgU8awapJzKnqDKgw',
    'e' => 'AQAB',
    'alg' => 'RS256',
    'kid' => '2011-04-29',
]);

$key->has('kty'); // Unchanged
$key->get('kty'); // Unchanged
$key->thumbprint('sha256'); // Unchanged
json_encode($key); // Unchanged
$key->toPublic(); // Unchanged
$key->all(); // The method name changed.
```

