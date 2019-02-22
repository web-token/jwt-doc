# Signed Tokens \(JWS\)

The JWS object, signature algorithms and token serializers are part of the signature component \(`web-token/jwt-signature`\). Claim and header checkers are decoupled and can be found in the checker component \(`web-token/jwt-checker`\).

Why are signature and checker components not together? The main reason is that when you issue signed tokens, you do not need any checker. Those components are decoupled to avoid the installation of unnecessary files.

**The signature and loading processes have been completely reviewed.**

In the examples below, we suppose we already have a JWK object \(`$key`\).

## Signed Tokens Creation

**Before**

```php
<?php

use Jose\Factory\JWKFactory;
use Jose\Factory\JWSFactory;

$header = [
  'alg' => 'RS256',
];

$jws = JWSFactory::createJWSToCompactJSON(
    $claims, // The payload
    $key,    // The private/shared key used to sign
    $header  // The token protected header
);
```

**After**

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\Converter\StandardConverter;
use Jose\Component\Signature\JWSBuilder;
use Jose\Component\Signature\Algorithm\RS256;
use Jose\Component\Signature\Serializer\CompactSerializer;

// This converter wraps json_encode/json_decode with some parameters
$jsonConverter = new StandardConverter();

// This managers handles all algorithms we need to use. 
$algorithmManager = AlgorithmManager::create([
    new RS256(),
]);

// The JWS Builder
$jwsBuilder = new JWSBuilder($jsonConverter, $algorithmManager);

// First we have to encode the payload. Now only strings are accepted.
$payload = $jsonConverter->encode($claims);

// We build our JWS object
$jws = $jwsBuilder
    ->create()                    // Indicates we want to create a new token
    ->withPayload($payload)       // We set the payload
    ->addSignature($key, $header) // We add a signature
    ->build();                    // We compute the JWS

// We need to serialize the token.
// In this example we will use the compact serialization mode (most common mode).
$serializer = new CompactSerializer($jsonConverter);
$token = $serializer->serialize($jws);
```

## Signed Tokens Loading

**Before**

```php
<?php

use Jose\Checker\AudienceChecker;
use Jose\Factory\CheckerManagerFactory;
use Jose\Loader;

// The loader
$loader = new Loader();

// We load and verify the input
$jws = $loader->loadAndVerifySignatureUsingKey(
    $input,
    $key,
    ['RS256'],
    $signature_index
);

// We prepare the claim/header checker
$checker = CheckerManagerFactory::createClaimCheckerManager(
    ['iat', 'nbf'], // We should enable 'exp', but this example will fail as the token has already expired
    ['crit']
);

// We check the token
$checker->checkJWS($jws, 0);
```

**After**

```php
<?php
use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\Converter\StandardConverter;
use Jose\Component\Checker\ClaimCheckerManager;
use Jose\Component\Checker\HeaderCheckerManager;
use Jose\Component\Checker\AlgorithmChecker;
use Jose\Component\Checker\ExpirationTimeChecker;
use Jose\Component\Signature\JWSVerifier;
use Jose\Component\Signature\Algorithm\RS256;
use Jose\Component\Signature\Serializer\CompactSerializer;
use Jose\Component\Signature\JWSTokenSupport;

$jsonConverter = new StandardConverter();
$serializer = new CompactSerializer($jsonConverter);

$jws = $serializer->unserialize($input);

$headerChecker = HeaderCheckerManager::create(
    [new AlgorithmChecker(['RS256'])], // A list of header checkers
    [new JWSTokenSupport()]            // A list of token support services (we only use the JWS token type here)
);

$algorithmManager = AlgorithmManager::create([
    new RS256(),
]);
$jwsVerifier = new JWSVerifier($algorithmManager);

$claimChecker = ClaimCheckerManager::create(
    [new ExpirationTimeChecker()] // A list of claim checkers
);

// We check all signatures
$isVerified = false;
for ($i = 0; $i < $jws->count(); $i++) {
    try {
        $headerChecker->check($jws, 0); // We check the header of the first (index=0) signature.        
        if ($jwsVerifier->verifyWithKey($jws, $key, 0)) { // We verify the signature
            $isVerified = true;
            break;
        }
    } catch (\Exception $e) {
        continue;
    }
}

if (!$isVerified) {
    //Unable to check the token. The header or the signature verification failed.
} else {
    // We check the claims.
    // If everything is ok, claims can be used.
    $claims = $jsonConverter->decode($jws->getPayload());
    $claimChecker->check($claims); // We check the claims.
}
```

Please note that it is important to check the token header before the verification of the signature. It will help you to reject tokens signed with unsupported algorithms.

