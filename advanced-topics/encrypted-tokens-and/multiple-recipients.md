# Multiple Recipients

When you need to encrypt the same payload for several audiences, you may want to do it at once. The JWE Builder supports multiple recipients.

With the example below, we will create an encrypted token for three different recipients using three different key encryption algorithms.

**Important notes:**

* The content encryption algorithm MUST be the same for all recipients.
* The Key Management Modes of the key encryption algorithms MUST be compatible \(see table below\).

```php
$jweBuilder
    ->create()
    ->withPayload('...')
    ->withSharedProtectedHeader(['enc' => 'A128GCM'])
    ->addRecipient($recipient_key_1, ['alg' => 'RSA1_5'])
    ->addRecipient($recipient_key_2, ['alg' => 'RSA-OAEP-256'])
    ->build();
```

**Note: when an unprotected header is set, the Compact Serialization mode is not available.**

## Key Management Modes

Each Key Encryption Algorithm has its own Key Management Mode.

### Key Encryption Algorithms And Associated Key Management Mode.

| Algorithm  Key Management Mode | Key Encryption | Key Wrapping | Direct Key Agreement | Key Agreement with Key Wrapping | Direct Encryption |
| :--- | :--- | :--- | :--- | :--- | :--- |
| dir |  |  |  |  | X |
| A128KW |  | X |  |  |  |
| A192KW |  | X |  |  |  |
| A256KW |  | X |  |  |  |
| ECDH-ES |  |  | X |  |  |
| ECDH-ES+A128KW |  |  |  | X |  |
| ECDH-ES+A192KW |  |  |  | X |  |
| ECDH-ES+A256KW |  |  |  | X |  |
| PBES2-HS256+A128KW |  | X |  |  |  |
| PBES2-HS384+A192KW |  | X |  |  |  |
| PBES2-HS512+A256KW |  | X |  |  |  |
| RSA1\_5 | X |  |  |  |  |
| RSA-OAEP | X |  |  |  |  |
| RSA-OAEP-256 | X |  |  |  |  |
| A128GCMKW |  | X |  |  |  |
| A192GCMKW |  | X |  |  |  |
| A256GCMKW |  | X |  |  |  |

### Compatibility table between Key Management Modes:

| Key Management Mode | Key Encryption | Key Wrapping | Direct Key Agreement | Key Agreement with Key Wrapping | Direct Encryption |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Key Encryption | YES | YES | NO | YES | NO |
| Key Wrapping | YES | YES | NO | YES | NO |
| Direct Key Agreement | NO | NO | NO | NO | NO |
| Key Agreement with Key Wrapping | YES | YES | NO | NO | NO |
| Direct Encryption | NO | NO | NO | NO | NO |

