# Signed Tokens (JWS) Examples

## Sign a Token with HMAC (HS256)

The simplest approach: a shared secret key is used to both sign and verify the token.

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\JWK;
use Jose\Component\Signature\Algorithm\HS256;
use Jose\Component\Signature\JWSBuilder;
use Jose\Component\Signature\Serializer\CompactSerializer;

require_once 'vendor/autoload.php';

// Create a symmetric key (shared secret)
$jwk = new JWK([
    'kty' => 'oct',
    'k' => base64_encode(random_bytes(32)), // 256-bit key
]);

$algorithmManager = new AlgorithmManager([new HS256()]);
$jwsBuilder = new JWSBuilder($algorithmManager);

$payload = json_encode([
    'iss' => 'https://my-app.example.com',
    'aud' => 'https://api.example.com',
    'sub' => 'user-42',
    'iat' => time(),
    'exp' => time() + 3600,
]);

$jws = $jwsBuilder
    ->withPayload($payload)
    ->addSignature($jwk, ['alg' => 'HS256'])
    ->build();

$token = (new CompactSerializer())->serialize($jws);
// eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL215LWFwcC...
```

### Verify the Token

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\JWK;
use Jose\Component\Signature\Algorithm\HS256;
use Jose\Component\Signature\JWSVerifier;
use Jose\Component\Signature\Serializer\CompactSerializer;

require_once 'vendor/autoload.php';

$jwk = /* the same shared key used for signing */;

$algorithmManager = new AlgorithmManager([new HS256()]);
$jwsVerifier = new JWSVerifier($algorithmManager);

$jws = (new CompactSerializer())->unserialize($token);

$isValid = $jwsVerifier->verifyWithKey($jws, $jwk, 0);
// $isValid is true if the signature is valid
```

---

## Sign a Token with RSA (RS256)

RSA keys allow the signer and the verifier to use different keys: a private key to sign, a public key to verify.

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\KeyManagement\JWKFactory;
use Jose\Component\Signature\Algorithm\RS256;
use Jose\Component\Signature\JWSBuilder;
use Jose\Component\Signature\Serializer\CompactSerializer;

require_once 'vendor/autoload.php';

// Generate an RSA key pair (2048-bit minimum recommended)
$jwkFactory = new JWKFactory();
$privateKey = $jwkFactory->rsa(2048, ['alg' => 'RS256', 'use' => 'sig']);

$algorithmManager = new AlgorithmManager([new RS256()]);
$jwsBuilder = new JWSBuilder($algorithmManager);

$payload = json_encode([
    'iss' => 'https://auth.example.com',
    'aud' => 'https://api.example.com',
    'sub' => 'user-42',
    'iat' => time(),
    'exp' => time() + 3600,
]);

$jws = $jwsBuilder
    ->withPayload($payload)
    ->addSignature($privateKey, ['alg' => 'RS256'])
    ->build();

$token = (new CompactSerializer())->serialize($jws);
```

### Verify with the Public Key

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Signature\Algorithm\RS256;
use Jose\Component\Signature\JWSVerifier;
use Jose\Component\Signature\Serializer\CompactSerializer;

require_once 'vendor/autoload.php';

// Extract the public key from the private key
$publicKey = $privateKey->toPublic();

$algorithmManager = new AlgorithmManager([new RS256()]);
$jwsVerifier = new JWSVerifier($algorithmManager);

$jws = (new CompactSerializer())->unserialize($token);

$isValid = $jwsVerifier->verifyWithKey($jws, $publicKey, 0);
```

---

## Sign a Token with Elliptic Curve (ES256)

ECDSA keys are smaller and faster than RSA for the same security level.

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\KeyManagement\JWKFactory;
use Jose\Component\Signature\Algorithm\ES256;
use Jose\Component\Signature\JWSBuilder;
use Jose\Component\Signature\Serializer\CompactSerializer;

require_once 'vendor/autoload.php';

// Generate an EC key on the P-256 curve
$jwkFactory = new JWKFactory();
$privateKey = $jwkFactory->ec('P-256', ['alg' => 'ES256', 'use' => 'sig']);

$algorithmManager = new AlgorithmManager([new ES256()]);
$jwsBuilder = new JWSBuilder($algorithmManager);

$payload = json_encode([
    'iss' => 'https://auth.example.com',
    'aud' => 'https://api.example.com',
    'sub' => 'user-42',
    'iat' => time(),
    'exp' => time() + 3600,
]);

$jws = $jwsBuilder
    ->withPayload($payload)
    ->addSignature($privateKey, ['alg' => 'ES256'])
    ->build();

$token = (new CompactSerializer())->serialize($jws);
```

### Verify with the Public Key

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Signature\Algorithm\ES256;
use Jose\Component\Signature\JWSVerifier;
use Jose\Component\Signature\Serializer\CompactSerializer;

require_once 'vendor/autoload.php';

$publicKey = $privateKey->toPublic();

$algorithmManager = new AlgorithmManager([new ES256()]);
$jwsVerifier = new JWSVerifier($algorithmManager);

$jws = (new CompactSerializer())->unserialize($token);

$isValid = $jwsVerifier->verifyWithKey($jws, $publicKey, 0);
```

---

## Sign a Token with EdDSA (Ed25519)

EdDSA with Ed25519 provides high performance and strong security. Requires the `sodium` extension.

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\KeyManagement\JWKFactory;
use Jose\Component\Signature\Algorithm\EdDSA;
use Jose\Component\Signature\JWSBuilder;
use Jose\Component\Signature\Serializer\CompactSerializer;

require_once 'vendor/autoload.php';

// Generate an Ed25519 key pair (requires ext-sodium)
$jwkFactory = new JWKFactory();
$privateKey = $jwkFactory->okp('Ed25519', ['alg' => 'EdDSA', 'use' => 'sig']);

$algorithmManager = new AlgorithmManager([new EdDSA()]);
$jwsBuilder = new JWSBuilder($algorithmManager);

$payload = json_encode([
    'iss' => 'https://auth.example.com',
    'sub' => 'user-42',
    'iat' => time(),
    'exp' => time() + 3600,
]);

$jws = $jwsBuilder
    ->withPayload($payload)
    ->addSignature($privateKey, ['alg' => 'EdDSA'])
    ->build();

$token = (new CompactSerializer())->serialize($jws);

// Verification
$publicKey = $privateKey->toPublic();
$jwsVerifier = new \Jose\Component\Signature\JWSVerifier($algorithmManager);
$jws = (new CompactSerializer())->unserialize($token);
$isValid = $jwsVerifier->verifyWithKey($jws, $publicKey, 0);
```

---

## Using the JWSLoader (Recommended)

The `JWSLoader` combines deserialization, header checking, and signature verification in a single step. This is the recommended approach for loading tokens.

```php
<?php

use Jose\Component\Checker\AlgorithmChecker;
use Jose\Component\Checker\HeaderCheckerManager;
use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\JWK;
use Jose\Component\Signature\Algorithm\HS256;
use Jose\Component\Signature\JWSLoader;
use Jose\Component\Signature\JWSTokenSupport;
use Jose\Component\Signature\JWSVerifier;
use Jose\Component\Signature\Serializer\CompactSerializer;
use Jose\Component\Signature\Serializer\JWSSerializerManager;

require_once 'vendor/autoload.php';

$jwk = /* your verification key */;

$algorithmManager = new AlgorithmManager([new HS256()]);

$jwsLoader = new JWSLoader(
    new JWSSerializerManager([new CompactSerializer()]),
    new JWSVerifier($algorithmManager),
    new HeaderCheckerManager(
        [new AlgorithmChecker(['HS256'])],  // Only allow HS256
        [new JWSTokenSupport()]
    )
);

$jws = $jwsLoader->loadAndVerify($token, $jwk)->getJws();

$payload = json_decode($jws->getPayload(), true);
```

{% hint style="info" %}
After verifying the signature, you should also validate the claims (`exp`, `iss`, `aud`, etc.). See the [Claim and Header Validation](validation.md) page.
{% endhint %}
