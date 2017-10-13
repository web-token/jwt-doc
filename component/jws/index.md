Signed Tokens
=============

# JWS Creation

Now that you have an algorithm manager and a key, it is time to create your first signed token.

This is done by the `JWSBuilder` object. This object requires the algorithm manager and a JSON converter.
In the following example, we will use the standard converter provided by the framework.

```php
<?php

require_once 'vendor/autoload.php';

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\Converter\StandardJsonConverter;
use Jose\Component\Core\JWK;
use Jose\Component\Signature\Algorithm\HS256;
use Jose\Component\Signature\JWSBuilder;

// The algorithm manager with the HS256 algorithm.
$algorithmManager = AlgorithmManager::create([
    new HS256(),
]);

// Our key.
$jwk = JWK::create([
    'kty' => 'oct',
    'k' => 'dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g',
]);

// The JSON Converter.
$jsonConverter = new StandardJsonConverter();

// We instantiate our JWS Builder.
$jwsBuilder = new JWSBuilder(
    $jsonConverter,
    $algorithmManager
);
```

Now let's create our first JWS object.

```php
// The payload we want to sign
$payload = [
    'iat' => time(),
    'nbf' => time(),
    'exp' => time() + 3600,
    'iss' => 'My service',
    'aud' => 'Your application',
];

$jws = $jwsBuilder
    ->create()                               // We want to create a new JWS
    ->withPayload($payload)                  // We set the payload
    ->addSignature($jwk, ['alg' => 'HS256']) // We add a signature with a simple protected header
    ->build();                               // We build it
```

Great! If everything is fine you will get a JWS object with one signature.
We want to send it to the audience. Before that, it must be serialized.

We will use the compact serialization mode.
This is the most common mode as it is URL safe and very compact.
Perfect for a use in a web context!

```php
use Jose\Component\Signature\Serializer\CompactSerializer;

$serializer = new CompactSerializer($jsonConverter); // The serializer

$token = $serializer->serialize($jws, 0); // We serialize the signature at index 0 (we only have one signature).
```

All good!
The variable `$token` now contains a string that should be something like that: `eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1MDc4OTY5OTIsIm5iZiI6MTUwNzg5Njk5MiwiZXhwIjoxNTA3OTAwNTkyLCJpc3MiOiJNeSBzZXJ2aWNlIiwiYXVkIjoiWW91ciBhcHBsaWNhdGlvbiJ9.eycp9PTdgO4WA-68-AMoHPwsKDr68NhjIQKz4lUkiI0`.
