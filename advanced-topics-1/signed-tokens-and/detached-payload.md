# Detached Payload

As per the [RFC7519](https://tools.ietf.org/html/rfc7515#appendix-F),the payload of a JWS may be detached. This framework supports this feature.

## JWS Creation

There is not much difference between the creation of a JWS with or without detached payload. The following example comes from the [JWS Creation page](../../the-components/signed-tokens-jws/jws-creation.md). There is only one argument that will change during the call of `withPayload`.

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\JWK;
use Jose\Component\Signature\Algorithm\HS256;
use Jose\Component\Signature\JWSBuilder;

// The algorithm manager with the HS256 algorithm.
$algorithmManager = new AlgorithmManager([
    new HS256(),
]);

// Our key.
$jwk = new JWK([
    'kty' => 'oct',
    'k' => 'dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g',
]);

// We instantiate our JWS Builder.
$jwsBuilder = new JWSBuilder(
    $algorithmManager
);

// The payload we want to sign
$payload = json_encode([
    'iat' => time(),
    'nbf' => time(),
    'exp' => time() + 3600,
    'iss' => 'My service',
    'aud' => 'Your application',
]);

$jws = $jwsBuilder
    ->create()                               // We want to create a new JWS
    ->withPayload($payload, true)            // /!\ Here is the change! We set the payload and we indicate it is detached
    ->addSignature($jwk, ['alg' => 'HS256']) // We add a signature with a simple protected header
    ->build();
```

And voilà! When you will serialize this token, the payload will not be present.

## JWS Loading

The loading of a signed token with a detached payload is as easy as when the payload is attached. The only difference is that you have to pass the payload to the JWS Verifier when you want to check the signature.

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\JWK;
use Jose\Component\Signature\Algorithm\HS256;
use Jose\Component\Signature\JWSVerifier;
use Jose\Component\Signature\Serializer\JWSSerializerManager;
use Jose\Component\Signature\Serializer\CompactSerializer;

// The algorithm manager with the HS256 algorithm.
$algorithmManager = new AlgorithmManager([
    new HS256(),
]);

// Our key.
$jwk = new JWK([
    'kty' => 'oct',
    'k' => 'dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g',
]);

// The serializer manager. We only use the JWS Compact Serialization Mode.
$serializerManager = new JWSSerializerManager([
    new CompactSerializer(),
]);

// We instantiate our JWS Verifier.
$jwsVerifier = new JWSVerifier($algorithmManager);

// The detached payload
$payload = '{"iat":1507896992,"nbf":1507896992,"exp":1507900592,"iss":"My service","aud":"Your application"}';

// The input we want to check
$token = 'eyJhbGciOiJIUzI1NiJ9..eycp9PTdgO4WA-68-AMoHPwsKDr68NhjIQKz4lUkiI0';

// We try to load the token.
$jws = $serializerManager->unserialize($token);

// We verify the signature.
// /!\ The third argument is the detached payload.
$jwsVerifier->verifyWithKey($jws, $jwk, $payload);
```

