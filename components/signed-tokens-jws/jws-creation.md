# JWS Creation

Now that you have an algorithm manager and a key, it is time to create your first signed token.

The computation is done by the `JWSBuilder` object. This object only requires the algorithm manager.

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
$jwsBuilder = new JWSBuilder($algorithmManager);
```

Now let's create our first JWS object.

```php
// The payload we want to sign. The payload MUST be a string hence we use our JSON Converter.
$payload = json_encode([
    'iat' => time(),
    'nbf' => time(),
    'exp' => time() + 3600,
    'iss' => 'My service',
    'aud' => 'Your application',
]);

$jws = $jwsBuilder
    ->create()                               // We want to create a new JWS
    ->withPayload($payload)                  // We set the payload
    ->addSignature($jwk, ['alg' => 'HS256']) // We add a signature with a simple protected header
    ->build();                               // We build it
```

Great! If everything is fine you will get a JWS object with one signature. We want to send it to the audience. Before that, it must be serialized.

We will use the compact serialization mode. This is the most common mode as it is URL safe and very compact. Perfect for a use in a web context!

```php
use Jose\Component\Signature\Serializer\CompactSerializer;

$serializer = new CompactSerializer(); // The serializer

$token = $serializer->serialize($jws, 0); // We serialize the signature at index 0 (we only have one signature).
```

All good! The variable `$token` now contains a string that should be something like this:

```text
eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1MDc4OTY5OTIsIm5iZiI6MTUwNzg5Njk5MiwiZXhwIjoxNTA3OTAwNTkyLCJpc3MiOiJNeSBzZXJ2aWNlIiwiYXVkIjoiWW91ciBhcHBsaWNhdGlvbiJ9.eycp9PTdgO4WA-68-AMoHPwsKDr68NhjIQKz4lUkiI0
```

Other serialization modes exist. We will see them in the Advanced Topics section.

