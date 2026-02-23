# Encrypted Tokens (JWE) Examples

## Encrypt a Token with RSA-OAEP

RSA-OAEP is widely supported. The sender encrypts with the recipient's public key; only the recipient can decrypt with their private key.

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A256GCM;
use Jose\Component\Encryption\Algorithm\KeyEncryption\RSAOAEP256;
use Jose\Component\Encryption\JWEBuilder;
use Jose\Component\Encryption\Serializer\CompactSerializer;
use Jose\Component\KeyManagement\JWKFactory;

require_once 'vendor/autoload.php';

// Generate an RSA key pair (2048-bit minimum)
$privateKey = JWKFactory::createRSAKey(2048, ['alg' => 'RSA-OAEP-256', 'use' => 'enc']);
$publicKey = $privateKey->toPublic();

$algorithmManager = new AlgorithmManager([
    new RSAOAEP256(),
    new A256GCM(),
]);
$jweBuilder = new JWEBuilder($algorithmManager);

$payload = json_encode([
    'iss' => 'https://auth.example.com',
    'sub' => 'user-42',
    'iat' => time(),
    'exp' => time() + 3600,
    'email' => 'user@example.com',
]);

$jwe = $jweBuilder
    ->create()
    ->withPayload($payload)
    ->withSharedProtectedHeader([
        'alg' => 'RSA-OAEP-256',
        'enc' => 'A256GCM',
    ])
    ->addRecipient($publicKey)
    ->build();

$token = (new CompactSerializer())->serialize($jwe, 0);
```

### Decrypt the Token

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A256GCM;
use Jose\Component\Encryption\Algorithm\KeyEncryption\RSAOAEP256;
use Jose\Component\Encryption\JWEDecrypter;
use Jose\Component\Encryption\Serializer\CompactSerializer;

require_once 'vendor/autoload.php';

$algorithmManager = new AlgorithmManager([
    new RSAOAEP256(),
    new A256GCM(),
]);
$jweDecrypter = new JWEDecrypter($algorithmManager);

$jwe = (new CompactSerializer())->unserialize($token);

$jweDecrypter->decryptUsingKey($jwe, $privateKey, 0);

$payload = json_decode($jwe->getPayload(), true);
// ['iss' => 'https://auth.example.com', 'sub' => 'user-42', ...]
```

---

## Encrypt a Token with ECDH-ES (Elliptic Curve)

ECDH-ES performs a key agreement directly, producing smaller tokens than RSA.

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A128GCM;
use Jose\Component\Encryption\Algorithm\KeyEncryption\ECDHES;
use Jose\Component\Encryption\JWEBuilder;
use Jose\Component\Encryption\Serializer\CompactSerializer;
use Jose\Component\KeyManagement\JWKFactory;

require_once 'vendor/autoload.php';

// Generate an EC key pair on the P-256 curve
$privateKey = JWKFactory::createECKey('P-256', ['alg' => 'ECDH-ES', 'use' => 'enc']);
$publicKey = $privateKey->toPublic();

$algorithmManager = new AlgorithmManager([new ECDHES(), new A128GCM()]);
$jweBuilder = new JWEBuilder($algorithmManager);

$payload = json_encode([
    'iss' => 'https://auth.example.com',
    'sub' => 'user-42',
    'iat' => time(),
    'exp' => time() + 3600,
]);

$jwe = $jweBuilder
    ->create()
    ->withPayload($payload)
    ->withSharedProtectedHeader(['alg' => 'ECDH-ES', 'enc' => 'A128GCM'])
    ->addRecipient($publicKey)
    ->build();

$token = (new CompactSerializer())->serialize($jwe, 0);
```

### Decrypt the Token

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A128GCM;
use Jose\Component\Encryption\Algorithm\KeyEncryption\ECDHES;
use Jose\Component\Encryption\JWEDecrypter;
use Jose\Component\Encryption\Serializer\CompactSerializer;

require_once 'vendor/autoload.php';

$algorithmManager = new AlgorithmManager([new ECDHES(), new A128GCM()]);
$jweDecrypter = new JWEDecrypter($algorithmManager);

$jwe = (new CompactSerializer())->unserialize($token);

$jweDecrypter->decryptUsingKey($jwe, $privateKey, 0);

$payload = json_decode($jwe->getPayload(), true);
```

---

## Encrypt a Token with a Password (PBES2)

Password-based encryption is useful when sharing tokens with users who only have a passphrase.

{% hint style="warning" %}
`spomky-labs/aes-key-wrap` is required for PBES2 algorithms:
```bash
composer require spomky-labs/aes-key-wrap
```
{% endhint %}

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A256CBCHS512;
use Jose\Component\Encryption\Algorithm\KeyEncryption\PBES2HS512A256KW;
use Jose\Component\Encryption\JWEBuilder;
use Jose\Component\Encryption\Serializer\CompactSerializer;
use Jose\Component\KeyManagement\JWKFactory;

require_once 'vendor/autoload.php';

// Create a key from a password
$password = 'my-super-secret-password';
$jwk = JWKFactory::createFromSecret($password, ['alg' => 'PBES2-HS512+A256KW', 'use' => 'enc']);

$algorithmManager = new AlgorithmManager([
    new PBES2HS512A256KW(),
    new A256CBCHS512(),
]);
$jweBuilder = new JWEBuilder($algorithmManager);

$payload = json_encode([
    'iss' => 'https://auth.example.com',
    'sub' => 'user-42',
    'data' => 'confidential information',
]);

$jwe = $jweBuilder
    ->create()
    ->withPayload($payload)
    ->withSharedProtectedHeader([
        'alg' => 'PBES2-HS512+A256KW',
        'enc' => 'A256CBC-HS512',
    ])
    ->addRecipient($jwk)
    ->build();

$token = (new CompactSerializer())->serialize($jwe, 0);
```

### Decrypt with the Same Password

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A256CBCHS512;
use Jose\Component\Encryption\Algorithm\KeyEncryption\PBES2HS512A256KW;
use Jose\Component\Encryption\JWEDecrypter;
use Jose\Component\Encryption\Serializer\CompactSerializer;
use Jose\Component\KeyManagement\JWKFactory;

require_once 'vendor/autoload.php';

$jwk = JWKFactory::createFromSecret('my-super-secret-password', [
    'alg' => 'PBES2-HS512+A256KW',
    'use' => 'enc',
]);

$algorithmManager = new AlgorithmManager([
    new PBES2HS512A256KW(),
    new A256CBCHS512(),
]);
$jweDecrypter = new JWEDecrypter($algorithmManager);

$jwe = (new CompactSerializer())->unserialize($token);

$jweDecrypter->decryptUsingKey($jwe, $jwk, 0);

$payload = json_decode($jwe->getPayload(), true);
```

---

## Encrypt a Token with a Shared Key (A256KW)

AES Key Wrap uses a symmetric key, useful for server-to-server communication.

{% hint style="warning" %}
`spomky-labs/aes-key-wrap` is required:
```bash
composer require spomky-labs/aes-key-wrap
```
{% endhint %}

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A256GCM;
use Jose\Component\Encryption\Algorithm\KeyEncryption\A256KW;
use Jose\Component\Encryption\JWEBuilder;
use Jose\Component\Encryption\Serializer\CompactSerializer;
use Jose\Component\KeyManagement\JWKFactory;

require_once 'vendor/autoload.php';

// Generate a 256-bit symmetric key
$jwk = JWKFactory::createOctKey(256, ['alg' => 'A256KW', 'use' => 'enc']);

$algorithmManager = new AlgorithmManager([new A256KW(), new A256GCM()]);
$jweBuilder = new JWEBuilder($algorithmManager);

$payload = json_encode([
    'iss' => 'https://service-a.example.com',
    'aud' => 'https://service-b.example.com',
    'data' => ['key' => 'value'],
]);

$jwe = $jweBuilder
    ->create()
    ->withPayload($payload)
    ->withSharedProtectedHeader(['alg' => 'A256KW', 'enc' => 'A256GCM'])
    ->addRecipient($jwk)
    ->build();

$token = (new CompactSerializer())->serialize($jwe, 0);

// Decryption uses the same key
$jweDecrypter = new \Jose\Component\Encryption\JWEDecrypter($algorithmManager);
$jwe = (new CompactSerializer())->unserialize($token);
$jweDecrypter->decryptUsingKey($jwe, $jwk, 0);
$payload = json_decode($jwe->getPayload(), true);
```

---

## Using the JWELoader (Recommended)

The `JWELoader` combines deserialization, header checking, and decryption in a single step.

```php
<?php

use Jose\Component\Checker\AlgorithmChecker;
use Jose\Component\Checker\HeaderCheckerManager;
use Jose\Component\Checker\IsEqualChecker;
use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A256GCM;
use Jose\Component\Encryption\Algorithm\KeyEncryption\RSAOAEP256;
use Jose\Component\Encryption\JWEDecrypter;
use Jose\Component\Encryption\JWELoader;
use Jose\Component\Encryption\JWETokenSupport;
use Jose\Component\Encryption\Serializer\CompactSerializer;
use Jose\Component\Encryption\Serializer\JWESerializerManager;

require_once 'vendor/autoload.php';

$privateKey = /* your RSA private key */;

$algorithmManager = new AlgorithmManager([new RSAOAEP256(), new A256GCM()]);

$jweLoader = new JWELoader(
    new JWESerializerManager([new CompactSerializer()]),
    new JWEDecrypter($algorithmManager),
    new HeaderCheckerManager(
        [
            new AlgorithmChecker(['RSA-OAEP-256']),
            new IsEqualChecker('enc', 'A256GCM'),
        ],
        [new JWETokenSupport()]
    )
);

$recipient = null;
$jwe = $jweLoader->loadAndDecryptWithKey($token, $privateKey, $recipient);

$payload = json_decode($jwe->getPayload(), true);
```

{% hint style="info" %}
After decryption, you should also validate the claims (`exp`, `iss`, `aud`, etc.) contained in the payload. See the [Claim and Header Validation](validation.md) page.
{% endhint %}
