# Examples

## JWS Creation

{% code lineNumbers="true" %}
```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\JWK;
use Jose\Component\Signature\Algorithm\ES256;
use Jose\Component\Signature\JWSBuilder;
use Jose\Component\Signature\Serializer\CompactSerializer;

require_once 'vendor/autoload.php';

$claims = [
    'iss' => 'https://example.com', // Issuer
    'sub' => '1234567890', // Subject
    'aud' => 'https://api.example.com', // Audience
    'exp' => time() + 3600, // Expiration time (1 hour)
    'nbf' => time(), // Not before
    'iat' => time(), // Issued at
    'jti' => bin2hex(random_bytes(16)), // JWT ID
];
$payload = json_encode($claims);

$privateKey = '{"use":"sig","alg":"ES256","kid":"my-key-id","kty":"EC","crv":"P-256","d":"j5RP0Z4w9JvTacrP6fGYB50U97EvGE8kAMQ-YdNva7c","x":"JQJ8BPvO1oRaTBL2BPZG3y7AhOkZ3d-IZH6GdW-eNdo","y":"nSbyi6pS1ve6eNuusDkqifCUz6Msnkm8ivJHgaQgZfI"}';
$jwk = JWK::createFromJson($privateKey);

$algorithmManager = new AlgorithmManager([new ES256()]);

$jwsBuilder = new JWSBuilder($algorithmManager);


$jws = $jwsBuilder->create()
    ->withPayload($payload)
    ->addSignature($jwk, ['alg' => 'ES256', 'kid' => 'my-key-id'])
    ->build();

$serializer = new CompactSerializer();
$token = $serializer->serialize($jws);

var_dump($token);
```
{% endcode %}

## JWS Loading and Verification

{% code lineNumbers="true" %}
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
use Jose\Component\Core\JWK;
use Jose\Component\Signature\Algorithm\ES256;
use Jose\Component\Signature\JWSLoader;
use Jose\Component\Signature\JWSTokenSupport;
use Jose\Component\Signature\JWSVerifier;
use Jose\Component\Signature\Serializer\CompactSerializer;
use Jose\Component\Signature\Serializer\JWSSerializerManager;
use Symfony\Component\Clock\NativeClock;

require_once 'vendor/autoload.php';

$publicKey = '{"use":"sig","alg":"ES256","kid":"my-key-id","kty":"EC","crv":"P-256","x":"JQJ8BPvO1oRaTBL2BPZG3y7AhOkZ3d-IZH6GdW-eNdo","y":"nSbyi6pS1ve6eNuusDkqifCUz6Msnkm8ivJHgaQgZfI"}';
$publicJWK = JWK::createFromJson($publicKey);

$input = 'eyJhbGciOiJFUzI1NiIsImtpZCI6Im15LWtleS1pZCJ9.eyJpc3MiOiJodHRwczpcL1wvZXhhbXBsZS5jb20iLCJzdWIiOiIxMjM0NTY3ODkwIiwiYXVkIjoiaHR0cHM6XC9cL2FwaS5leGFtcGxlLmNvbSIsImV4cCI6MTc1MzU1Njk4NCwibmJmIjoxNzUzNTUzMzg0LCJpYXQiOjE3NTM1NTMzODQsImp0aSI6IjM3MjEzMjRjNGMxM2E5OTY4ZTI0YmY0MDZlNmU0MGYwIn0.EpXrD7j5hjUXLVrewNG3eQkmX5dQ1TiopP7cKflFmG0pS3lKDNnxTqUW9Gbz0YDjWoyTzldZoDW4w-KgmdYJqg';

$serializerManager = new JWSSerializerManager(
    [new CompactSerializer()]
);
$algorithmManager = new AlgorithmManager([new ES256()]);
$verifier = new JWSVerifier($algorithmManager);
$clock = new NativeClock();
$headerCheckerManager = new HeaderCheckerManager(
    [
        new AlgorithmChecker(['ES256']),
    ],
    [new JWSTokenSupport()]
);
$loader = new JWSLoader(
    $serializerManager,
    $verifier,
    $headerCheckerManager
);

$verifiedSignature = null;
$jws = $loader->loadAndVerifyWithKey($input, $publicJWK, $verifiedSignature);

$payload = json_decode($jws->getPayload(), true);

$clock = new NativeClock();
$claimCheckerManager = new ClaimCheckerManager([
    new IssuedAtChecker($clock),
    new NotBeforeChecker($clock),
    new ExpirationTimeChecker($clock),
    new IssuerChecker(['https://example.com']),
    new AudienceChecker('https://api.example.com'),
]);

var_dump('Payload:', $payload);
```
{% endcode %}

## JWE Creation

{% code lineNumbers="true" %}
```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\JWK;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A128GCM;
use Jose\Component\Encryption\Algorithm\KeyEncryption\ECDHES;
use Jose\Component\Encryption\JWEBuilder;
use Jose\Component\Encryption\Serializer\CompactSerializer;

require_once 'vendor/autoload.php';

$claims = [
    'iss' => 'https://example.com', // Issuer
    'sub' => '1234567890', // Subject
    'aud' => 'https://api.example.com', // Audience
    'exp' => time() + 3600, // Expiration time (1 hour)
    'nbf' => time(), // Not before
    'iat' => time(), // Issued at
    'jti' => bin2hex(random_bytes(16)), // JWT ID
];
$payload = json_encode($claims);

$publicKey = '{"use":"enc","alg":"ECDH-ES","kid":"my-key-id","kty":"EC","crv":"P-256","x":"JQJ8BPvO1oRaTBL2BPZG3y7AhOkZ3d-IZH6GdW-eNdo","y":"nSbyi6pS1ve6eNuusDkqifCUz6Msnkm8ivJHgaQgZfI"}';
$jwk = JWK::createFromJson($publicKey);

$algorithmManager = new AlgorithmManager([new ECDHES(), new A128GCM()]);

$jweBuilder = new JWEBuilder($algorithmManager);


$jwe = $jweBuilder->create()
    ->withPayload($payload)
    ->withSharedProtectedHeader(['alg' => 'ECDH-ES', 'enc' => 'A128GCM'])
    ->addRecipient($jwk)
    ->build();

$serializer = new CompactSerializer();
$token = $serializer->serialize($jwe, 0);

var_dump($token);
```
{% endcode %}

## JWE Loading and Verification

{% code lineNumbers="true" %}
```php
<?php

use Jose\Component\Checker\AlgorithmChecker;
use Jose\Component\Checker\AudienceChecker;
use Jose\Component\Checker\ClaimCheckerManager;
use Jose\Component\Checker\ExpirationTimeChecker;
use Jose\Component\Checker\HeaderCheckerManager;
use Jose\Component\Checker\IsEqualChecker;
use Jose\Component\Checker\IssuedAtChecker;
use Jose\Component\Checker\IssuerChecker;
use Jose\Component\Checker\NotBeforeChecker;
use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\JWK;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A128GCM;
use Jose\Component\Encryption\Algorithm\KeyEncryption\ECDHES;
use Jose\Component\Encryption\JWEDecrypter;
use Jose\Component\Encryption\JWELoader;
use Jose\Component\Encryption\JWETokenSupport;
use Jose\Component\Encryption\Serializer\CompactSerializer;
use Jose\Component\Encryption\Serializer\JWESerializerManager;
use Symfony\Component\Clock\NativeClock;

require_once 'vendor/autoload.php';

$privateKey = '{"use":"enc","alg":"ECDH-ES","kid":"my-key-id","kty":"EC","crv":"P-256","d":"j5RP0Z4w9JvTacrP6fGYB50U97EvGE8kAMQ-YdNva7c","x":"JQJ8BPvO1oRaTBL2BPZG3y7AhOkZ3d-IZH6GdW-eNdo","y":"nSbyi6pS1ve6eNuusDkqifCUz6Msnkm8ivJHgaQgZfI"}';
$privateJWK = JWK::createFromJson($privateKey);

$input = 'eyJlcGsiOnsia3R5IjoiRUMiLCJjcnYiOiJQLTI1NiIsIngiOiJ2b2dMZjhzM3paaVcwSUo3dzlldk0zMlpXQnlBQnMtb25rbC1Jb3V2UUNrIiwieSI6Ikh5enpqbkE2UXc3Vm9IdzBkRWhKQ2p3cS1ka3pNaGZsOWp3SXRjVUEtV28ifSwiYWxnIjoiRUNESC1FUyIsImVuYyI6IkExMjhHQ00ifQ..pcfPa4B7CIPIs6N7.aLTQbSIQ2jRyI_5nY6RIX3FucHPtZnbuNnL0X6OTIgNVysRTI49TE_aPF98HVxeIsMhRyo8eQe-GmDM8HXRJhjJmRdnk77ElxerpXuaXGDMmDNCdxjE0zUXZECZSNsHKlSNzNADw0dQ_WzC77gRT1-V8WDqjn8nltIWkXMfN2x367XM608Kfuam236hzDgx9pt5N3-Yij7q5Ry-scZdnSeNuh_Pu6wad6ZtEzYz2qhA.B4ZiyQbCtwlWq99e74co7A';

$serializerManager = new JWESerializerManager([new CompactSerializer()]);
$algorithmManager = new AlgorithmManager([new ECDHES(), new A128GCM()]);
$jweDecrypter = new JWEDecrypter($algorithmManager);
$headerCheckerManager = new HeaderCheckerManager(
    [
        new AlgorithmChecker(['ECDH-ES']),
        new IsEqualChecker('enc', 'A128GCM'),
    ],
    [new JWETokenSupport()]
);
$jweLoader = new JWELoader(
    $serializerManager,
    $jweDecrypter,
    $headerCheckerManager
);
$decryptedRecipient = null;
$jwe = $jweLoader->loadAndDecryptWithKey($input, $privateJWK, $decryptedRecipient);
$payload = json_decode($jwe->getPayload(), true);

$clock = new NativeClock();
$claimCheckerManager = new ClaimCheckerManager([
    new IssuedAtChecker($clock),
    new NotBeforeChecker($clock),
    new ExpirationTimeChecker($clock),
    new IssuerChecker(['https://example.com']),
    new AudienceChecker('https://api.example.com'),
]);

var_dump('Payload:', $payload);


```
{% endcode %}
