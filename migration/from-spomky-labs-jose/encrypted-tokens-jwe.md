# Encrypted Tokens \(JWE\)

## Encrypted Tokens \(JWE\) Migration

The JWE object, encryption algorithms and token serializers are part of the encryption component \(`web-token/jwt-encryption`\). Claim and header checkers are decoupled and can be found in the checker component \(`web-token/jwt-checker`\).

Why are encryption and checker components not together? The main reason is that when you issue encrypted tokens, you do not need any checker. Those components are decoupled to avoid the installation of unnecessary files.

**The encryption and decryption processes have been completely reviewed.**

In the examples below, we suppose we already have a JWK object \(`$key`\).

## Encryted Tokens Creation

**Before**

```php
<?php

use Jose\Factory\JWEFactory;
use Jose\Factory\JWKFactory;

// We want to encrypt a very important message
$message = 'Today, 8:00PM, train station.';
$jwe = JWEFactory::createJWEToCompactJSON(
    $message,                    // The message to encrypt
    $key,                        // The key of the recipient
    [                            // The shared protected header
        'alg' => 'RSA-OAEP-256',
        'enc' => 'A256CBC-HS512',
        'zip' => 'DEF',
    ]
);
```

**After**

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\Converter\StandardConverter;
use Jose\Component\Encryption\Algorithm\KeyEncryption\RSAOAEP256;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A256CBCHS512;
use Jose\Component\Encryption\Compression\CompressionMethodManager;
use Jose\Component\Encryption\Compression\Deflate;
use Jose\Component\Encryption\JWEBuilder;
use Jose\Component\Encryption\Serializer\CompactSerializer;

$keyEncryptionAlgorithmManager = AlgorithmManager::create([
    new RSAOAEP256(),
]);

$contentEncryptionAlgorithmManager = AlgorithmManager::create([
    new A256CBCHS512(),
]);

$compressionMethodManager = CompressionMethodManager::create([
    new Deflate(),
]);

$jsonConverter = new StandardConverter();

$jweBuilder = new JWEBuilder(
    $jsonConverter,
    $keyEncryptionAlgorithmManager,
    $contentEncryptionAlgorithmManager,
    $compressionMethodManager
);

$message = 'Today, 8:00PM, train station.';

$jwe = $jweBuilder
    ->create()
    ->withPayload($message)
    ->withSharedProtectedHeader([
        'alg' => 'RSA-OAEP-256',
        'enc' => 'A256CBC-HS512',
        'zip' => 'DEF'
    ])
    ->addRecipient($jwk)
    ->build();

$serializer = new CompactSerializer($jsonConverter);

$token = $serializer->serialize($jwe, 0);
```

## Tokens Decryption

**Before**

```php
<?php
use Jose\Factory\JWKFactory;
use Jose\Loader;

// We create our loader.
$loader = new Loader();

// This is the input we want to load verify.
$input = 'eyJhbGciOiJSU0EtT0FFUCIsImtpZCI6InNhbXdpc2UuZ2FtZ2VlQGhvYmJpdG9uLmV4YW1wbGUiLCJlbmMiOiJBMjU2R0NNIn0.rT99rwrBTbTI7IJM8fU3Eli7226HEB7IchCxNuh7lCiud48LxeolRdtFF4nzQibeYOl5S_PJsAXZwSXtDePz9hk-BbtsTBqC2UsPOdwjC9NhNupNNu9uHIVftDyucvI6hvALeZ6OGnhNV4v1zx2k7O1D89mAzfw-_kT3tkuorpDU-CpBENfIHX1Q58-Aad3FzMuo3Fn9buEP2yXakLXYa15BUXQsupM4A1GD4_H4Bd7V3u9h8Gkg8BpxKdUV9ScfJQTcYm6eJEBz3aSwIaK4T3-dwWpuBOhROQXBosJzS1asnuHtVMt2pKIIfux5BC6huIvmY7kzV7W7aIUrpYm_3H4zYvyMeq5pGqFmW2k8zpO878TRlZx7pZfPYDSXZyS0CfKKkMozT_qiCwZTSz4duYnt8hS4Z9sGthXn9uDqd6wycMagnQfOTs_lycTWmY-aqWVDKhjYNRf03NiwRtb5BE-tOdFwCASQj3uuAgPGrO2AWBe38UjQb0lvXn1SpyvYZ3WFc7WOJYaTa7A8DRn6MC6T-xDmMuxC0G7S2rscw5lQQU06MvZTlFOt0UvfuKBa03cxA_nIBIhLMjY2kOTxQMmpDPTr6Cbo8aKaOnx6ASE5Jx9paBpnNmOOKH35j_QlrQhDWUN6A2Gg8iFayJ69xDEdHAVCGRzN3woEI2ozDRs.-nBoKLH0YkLZPSI9.o4k2cnGN8rSSw3IDo1YuySkqeS_t2m1GXklSgqBdpACm6UJuJowOHC5ytjqYgRL-I-soPlwqMUf4UgRWWeaOGNw6vGW-xyM01lTYxrXfVzIIaRdhYtEMRBvBWbEwP7ua1DRfvaOjgZv6Ifa3brcAM64d8p5lhhNcizPersuhw5f-pGYzseva-TUaL8iWnctc-sSwy7SQmRkfhDjwbz0fz6kFovEgj64X1I5s7E6GLp5fnbYGLa1QUiML7Cc2GxgvI7zqWo0YIEc7aCflLG1-8BboVWFdZKLK9vNoycrYHumwzKluLWEbSVmaPpOslY2n525DxDfWaVFUfKQxMF56vn4B9QMpWAbnypNimbM8zVOw.UCGiqJxhBI3IFVdPalHHvA';

// The payload is decrypted using our key.
$jwe = $loader->loadAndDecryptUsingKey(
    $input,            // The input to load and decrypt
    $jwk,              // The symmetric or private key 
    ['RSA-OAEP'],      // A list of allowed key encryption algorithms
    ['A256GCM'],       // A list of allowed content encryption algorithms
    $recipient_index   // If decrypted, this variable will be set with the recipient index used to decrypt
);
```

**After**

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Core\Converter\StandardConverter;
use Jose\Component\Encryption\Algorithm\KeyEncryption\RSAOAEP256;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A256CBCHS512;
use Jose\Component\Encryption\Compression\CompressionMethodManager;
use Jose\Component\Encryption\Compression\Deflate;
use Jose\Component\Encryption\JWEBuilder;
use Jose\Component\Encryption\Serializer\CompactSerializer;
use Jose\Component\Encryption\Serializer\JWESerializerManager;

$keyEncryptionAlgorithmManager = AlgorithmManager::create([
    new RSAOAEP256(),
]);

$contentEncryptionAlgorithmManager = AlgorithmManager::create([
    new A256CBCHS512(),
]);

$compressionMethodManager = CompressionMethodManager::create([
    new Deflate(),
]);

$jsonConverter = new StandardConverter();

$jweBuilder = new JWEBuilder(
    $jsonConverter,
    $keyEncryptionAlgorithmManager,
    $contentEncryptionAlgorithmManager,
    $compressionMethodManager
);

$serializerManager = JWESerializerManager::create([
    new CompactSerializer($jsonConverter),
]);

$token = 'eyJhbGciOiJBMjU2S1ciLCJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiemlwIjoiREVGIn0.9RLpf3Gauf05QPNCMzPcH4XNBLmH0s3e-YWwOe57MTG844gnc-g2ywfXt_R0Q9qsR6WhkmQEhdLk2CBvfqr4ob4jFlvJK0yW.CCvfoTKO9tQlzCvbAuFAJg.PxrDlsbSRcxC5SuEJ84i9E9_R3tCyDQsEPTIllSCVxVcHiPOC2EdDlvUwYvznirYP6KMTdKMgLqxB4BwI3CWtys0fceSNxrEIu_uv1WhzJg.4DnyeLEAfB4I8Eq0UobnP8ymlX1UIfSSADaJCXr3RlU';

$jwe = $serializerManager->unserialize($token);

$jwe = $jweDecrypter->decryptUsingKey($jwe, $jwk);
```

Please note that it is important to check the token header before the decryption of the token. It will help you to reject tokens signed with unsupported algorithms or for other audiences.

