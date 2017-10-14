
JWS Loading
===========

Signed tokens are loaded and verified by the `JWSLoader` object.
This object requires several services for the process
* an algorithm manager
* JSON converter.
* 

In the following example, we will use the same assumptions as the ones used during the [JWS Creation process](creation.md).

```php
<?php

require_once 'vendor/autoload.php';

use Jose\Component\Checker\HeaderCheckerManager;
use Jose\Component\Checker;
use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\Converter\StandardJsonConverter;
use Jose\Component\Core\JWK;
use Jose\Component\Signature\Algorithm\HS256;
use Jose\Component\Signature\JWSLoader;
use Jose\Component\Signature\JWSTokenHeaderChecker;
use Jose\Component\Signature\Serializer\JWSSerializerManager;
use Jose\Component\Signature\Serializer\CompactSerializer;

// The algorithm manager with the HS256 algorithm.
$algorithmManager = AlgorithmManager::create([
    new HS256(),
]);

// Our key.
$jwk = JWK::create([
    'kty' => 'oct',
    'k' => 'dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g',
]);

// The header checker manager
$headerCheckerManager = HeaderCheckerManager::create(
[
    new Checker\AlgorithmChecker(['HS256']), // We only want to check the algorithm as we only support one.
],
[
    new JWSTokenHeaderChecker(),             // We add the JWS Token type (this manager is able to support other token types.
]
);

// The JSON Converter.
$jsonConverter = new StandardJsonConverter();

// The serializer manager. We only use the JWS Compact Serialization Mode.
$serializerManager = JWSSerializerManager::create([
    new CompactSerializer($jsonConverter),
]);

// We instantiate our JWS Loader.
$jwsLoader = new JWSLoader(
    $algorithmManager,
    $headerCheckerManager,
    $serializerManager
);
```

The instantiation of the JWS Loader looks complicated but it will do almost all verification for use. 
In our example, it will be able to drop any tokens that are not signed tokens or tokens signed with an algorithm other than `HS256`.

Now we can use it with the input we receive. We will continue with the result we got during the JWS creation section.

```php
// The input we want to check
$token = 'eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1MDc4OTY5OTIsIm5iZiI6MTUwNzg5Njk5MiwiZXhwIjoxNTA3OTAwNTkyLCJpc3MiOiJNeSBzZXJ2aWNlIiwiYXVkIjoiWW91ciBhcHBsaWNhdGlvbiJ9.eycp9PTdgO4WA-68-AMoHPwsKDr68NhjIQKz4lUkiI0';

// 
$jws = $jwsLoader->load($token);
$jwsLoader->verifyWithKey($jws, $jwk);

$claimChecker = new Checker\ClaimCheckerManager(
    $jsonConverter,
    [
        new Checker\IssuedAtChecker(),
        new Checker\NotBeforeChecker(),
        new Checker\ExpirationTimeChecker(),
    ]
);

$claims = $claimChecker->check($jws);
```

If all the checks succeeded, the variable `$claim` will contain all the claims in the payload, even those that have not been verified.

*Note: this example will fail because of the `exp` claim.*
