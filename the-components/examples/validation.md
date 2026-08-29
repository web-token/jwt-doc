# Claim and Header Validation

After verifying a signature or decrypting a token, you **must** validate the claims and headers before trusting the token content.

{% hint style="danger" %}
Never use a token payload without validating its claims. An expired or wrongly-issued token must be rejected.
{% endhint %}

## Validate Claims

The `ClaimCheckerManager` verifies claims contained in the token payload.

```php
<?php

use Jose\Component\Checker\AudienceChecker;
use Jose\Component\Checker\ClaimCheckerManager;
use Jose\Component\Checker\ExpirationTimeChecker;
use Jose\Component\Checker\IssuedAtChecker;
use Jose\Component\Checker\IssuerChecker;
use Jose\Component\Checker\NotBeforeChecker;
use Symfony\Component\Clock\NativeClock;

require_once 'vendor/autoload.php';

// A PSR-20 clock implementation is required for time-based checkers
$clock = new NativeClock();

$claimCheckerManager = new ClaimCheckerManager([
    new IssuedAtChecker($clock),
    new NotBeforeChecker($clock),
    new ExpirationTimeChecker($clock),
    new IssuerChecker(['https://auth.example.com']),
    new AudienceChecker('https://api.example.com'),
]);

// $payload is the decoded payload from a verified JWS or decrypted JWE
$payload = json_decode($jws->getPayload(), true);

// Check claims. The second parameter lists the mandatory claims.
$claimCheckerManager->check($payload, ['iss', 'aud', 'exp']);
// Throws an exception if any check fails
```

{% hint style="info" %}
The `NativeClock` class is from the `symfony/clock` component. You can use any `Psr\Clock\ClockInterface` implementation.
```bash
composer require symfony/clock
```
{% endhint %}

---

## Allow a Time Drift

Network latency or clock skew between servers may cause valid tokens to be rejected. You can allow a small time drift (in seconds):

```php
$claimCheckerManager = new ClaimCheckerManager([
    new ExpirationTimeChecker($clock, allowedTimeDrift: 10), // 10 seconds tolerance
    new NotBeforeChecker($clock, allowedTimeDrift: 10),
    new IssuedAtChecker($clock, allowedTimeDrift: 10),
]);
```

---

## Custom Claim Validation with CallableChecker

For application-specific claims, use the `CallableChecker`:

```php
<?php

use Jose\Component\Checker\CallableChecker;
use Jose\Component\Checker\ClaimCheckerManager;

// Validate that the "role" claim is one of the allowed values
$roleChecker = new CallableChecker(
    'role',
    static function (mixed $value): bool {
        return in_array($value, ['admin', 'editor', 'viewer'], true);
    }
);

$claimCheckerManager = new ClaimCheckerManager([
    $roleChecker,
    // ... other checkers
]);

$claimCheckerManager->check($payload, ['role']);
```

---

## Validate with IsEqualChecker

For simple equality checks on claims or headers:

```php
<?php

use Jose\Component\Checker\ClaimCheckerManager;
use Jose\Component\Checker\IsEqualChecker;

// Ensure the "type" claim equals "access_token"
$claimCheckerManager = new ClaimCheckerManager([
    new IsEqualChecker('type', 'access_token'),
]);

$claimCheckerManager->check($payload, ['type']);
```

---

## Complete Example: Sign, Verify, and Validate

A full example combining token creation, verification, and claim validation:

```php
<?php

use Jose\Component\Checker\AlgorithmChecker;
use Jose\Component\Checker\AudienceChecker;
use Jose\Component\Checker\ClaimCheckerManager;
use Jose\Component\Checker\ExpirationTimeChecker;
use Jose\Component\Checker\HeaderCheckerManager;
use Jose\Component\Checker\IssuedAtChecker;
use Jose\Component\Checker\IssuerChecker;
use Jose\Component\Checker\NotBeforeChecker;
use Jose\Component\Core\AlgorithmManager;
use Jose\Component\KeyManagement\JWKFactory;
use Jose\Component\Signature\Algorithm\ES256;
use Jose\Component\Signature\JWSBuilder;
use Jose\Component\Signature\JWSLoader;
use Jose\Component\Signature\JWSTokenSupport;
use Jose\Component\Signature\JWSVerifier;
use Jose\Component\Signature\Serializer\CompactSerializer;
use Jose\Component\Signature\Serializer\JWSSerializerManager;
use Symfony\Component\Clock\NativeClock;

require_once 'vendor/autoload.php';

// --- 1. Create and sign the token ---

$jwkFactory = new JWKFactory();
$privateKey = $jwkFactory->ec('P-256', ['alg' => 'ES256', 'use' => 'sig']);

$algorithmManager = new AlgorithmManager([new ES256()]);

$payload = json_encode([
    'iss' => 'https://auth.example.com',
    'aud' => 'https://api.example.com',
    'sub' => 'user-42',
    'iat' => time(),
    'nbf' => time(),
    'exp' => time() + 3600,
]);

$jws = (new JWSBuilder($algorithmManager))
    ->withPayload($payload)
    ->addSignature($privateKey, ['alg' => 'ES256'])
    ->build();

$token = (new CompactSerializer())->serialize($jws);

// --- 2. Load and verify the signature ---

$publicKey = $privateKey->toPublic();

$jwsLoader = new JWSLoader(
    new JWSSerializerManager([new CompactSerializer()]),
    new JWSVerifier($algorithmManager),
    new HeaderCheckerManager(
        [new AlgorithmChecker(['ES256'])],
        [new JWSTokenSupport()]
    )
);

$jws = $jwsLoader->loadAndVerify($token, $publicKey)->getJws();

// --- 3. Validate the claims ---

$clock = new NativeClock();

$claimCheckerManager = new ClaimCheckerManager([
    new IssuedAtChecker($clock),
    new NotBeforeChecker($clock),
    new ExpirationTimeChecker($clock),
    new IssuerChecker(['https://auth.example.com']),
    new AudienceChecker('https://api.example.com'),
]);

$claims = json_decode($jws->getPayload(), true);
$claimCheckerManager->check($claims, ['iss', 'aud', 'sub', 'exp']);

// If no exception is thrown, the token is valid and trusted
echo 'Token is valid for user: ' . $claims['sub'];
```
